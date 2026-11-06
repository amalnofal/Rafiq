import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:rafiq/core/controller/appointment_provider.dart';
import 'package:rafiq/core/controller/clinic_provider.dart';
import 'package:rafiq/core/controller/collar_provider.dart';
import 'package:rafiq/core/controller/community_provider.dart';
import 'package:rafiq/core/controller/pet_provider.dart';
import 'package:rafiq/core/controller/store_provider.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/helper/cache_helper.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/services/appointment_service.dart';
import 'package:rafiq/core/services/auth_service.dart';
import 'package:rafiq/core/services/chat_service.dart';
import 'package:rafiq/core/services/clinic_service.dart';
import 'package:rafiq/core/services/collar_service.dart';
import 'package:rafiq/core/services/community_service.dart';
import 'package:rafiq/core/services/pet_service.dart';
import 'package:rafiq/core/services/store_service.dart';
import 'package:rafiq/core/services/user_service.dart';
import 'package:rafiq/features/auth/presentation/manager/forget_password_cubit/forget_password_cubit.dart';
import 'package:rafiq/features/auth/presentation/manager/login_cubit/login_cubit.dart';
import 'package:rafiq/features/auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:rafiq/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:rafiq/main.dart';

final getIt = GetIt.instance;

const String _baseUrl = 'https://rafiq-app.runasp.net/api';

DateTime? _lastErrorTime;

// Shared in-flight refresh, so parallel 401s trigger only one refresh call.
Future<String?>? _refreshFuture;

// Prevents showing the session-expired dialog more than once.
bool _sessionExpiring = false;

Future<void> setupServiceLocator() async {
  // ---------- Services & providers ----------
  getIt.registerLazySingleton(() => AuthService(getIt()));
  getIt.registerLazySingleton(() => UserProvider());
  getIt.registerLazySingleton(() => UserService(getIt()));
  getIt.registerLazySingleton(() => PetService(getIt()));
  getIt.registerLazySingleton(() => PetProvider());
  getIt.registerLazySingleton(() => ClinicService(getIt()));
  getIt.registerLazySingleton(() => ClinicProvider(getIt()));
  getIt.registerLazySingleton(() => AppointmentService(getIt()));
  getIt.registerLazySingleton(() => AppointmentProvider());
  getIt.registerLazySingleton(() => CommunityService(getIt()));
  getIt.registerLazySingleton(() => CommunityProvider(getIt()));
  getIt.registerLazySingleton(() => ChatService(getIt<Dio>()));
  getIt.registerLazySingleton(() => StoreService(getIt<Dio>()));
  getIt.registerLazySingleton(() => StoreProvider(getIt<StoreService>()));
  getIt.registerLazySingleton(() => CollarService(getIt<Dio>()));
  getIt.registerLazySingleton(() => CollarProvider(getIt<CollarService>()));

  // ---------- Dio ----------
  getIt.registerLazySingleton<Dio>(_createDio);

  // ---------- Cubits ----------
  getIt.registerFactory(() => ForgetPasswordCubit(getIt()));
  getIt.registerFactory(() => LoginCubit(getIt()));
  getIt.registerFactory(() => RegisterCubit(getIt()));
  getIt.registerFactory(() => ChatCubit(getIt()));
}

// TODO(clean-arch): move to core/network/dio_client.dart + auth_interceptor.dart
Dio _createDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  dio.interceptors.add(
    LogInterceptor(
      request: false,
      requestHeader: false,
      requestBody: false,
      responseHeader: false,
      responseBody: false,
      error: true,
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Fail fast when offline.
        final connectivity = await Connectivity().checkConnectivity();
        if (connectivity.contains(ConnectivityResult.none)) {
          return handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.connectionError,
              error: 'No Internet Connection',
            ),
          );
        }

        final token = CacheHelper.getData(key: 'accessToken');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        // Network problems: notify (throttled) and pass the error on.
        if (_isNetworkError(error)) {
          _showNetworkErrorThrottled();
          return handler.next(error);
        }

        final is401 = error.response?.statusCode == 401;
        final alreadyRetried = error.requestOptions.extra['retried'] == true;
        final isLogin = error.requestOptions.path.contains('/Account/Login');

        if (!is401 || alreadyRetried || isLogin) {
          return handler.next(error);
        }

        // Get a fresh access token.
        String? token;
        final cachedToken = CacheHelper.getData(key: 'accessToken');
        final sentToken = error.requestOptions.headers['Authorization']
            ?.toString()
            .replaceAll('Bearer ', '');

        if (cachedToken != null && cachedToken != sentToken) {
          // Another request already refreshed the token.
          token = cachedToken as String;
        } else {
          if (CacheHelper.getData(key: 'refreshToken') == null) {
            return handler.next(error);
          }
          try {
            token = await _refreshAccessToken();
          } on DioException catch (e) {
            final status = e.response?.statusCode;
            // Only a rejected refresh token means the session is really over.
            if (status == 400 || status == 401) {
              await _expireSession();
            }
            return handler.next(error);
          } catch (e) {
            log('[DioInterceptor]: Refresh failed: $e');
            return handler.next(error);
          }
        }

        if (token == null) return handler.next(error);

        // Retry the original request (outside the refresh try/catch).
        final options = error.requestOptions
          ..headers['Authorization'] = 'Bearer $token'
          ..extra['retried'] = true;

        if (options.data is FormData) {
          options.data = (options.data as FormData).clone();
        }

        try {
          final response = await dio.fetch(options);
          return handler.resolve(response);
        } on DioException catch (e) {
          return handler.next(e);
        }
      },
    ),
  );

  return dio;
}

bool _isNetworkError(DioException e) =>
    e.type == DioExceptionType.connectionTimeout ||
    e.type == DioExceptionType.receiveTimeout ||
    e.type == DioExceptionType.connectionError ||
    e.type == DioExceptionType.unknown;

void _showNetworkErrorThrottled() {
  final context = navigatorKey.currentContext;
  if (context == null) return;

  final now = DateTime.now();
  if (_lastErrorTime != null && now.difference(_lastErrorTime!).inSeconds <= 3) {
    return;
  }
  _lastErrorTime = now;

  try {
    showSnackBar(context, context.l10n.connectionError, isError: true);
  } catch (_) {}
}

Future<String?> _refreshAccessToken() {
  return _refreshFuture ??= _doRefresh().whenComplete(() {
    _refreshFuture = null;
  });
}

Future<String?> _doRefresh() async {
  log('[DioInterceptor]: Refreshing access token...');

  // Separate Dio instance: no interceptors, no loop.
  final response = await Dio(BaseOptions(baseUrl: _baseUrl)).post(
    '/Account/RefreshToken',
    data: {
      'accessToken': CacheHelper.getData(key: 'accessToken'),
      'refreshToken': CacheHelper.getData(key: 'refreshToken'),
    },
  );

  final body = response.data;
  final data = (body is Map && body['data'] != null) ? body['data'] : body;

  final newAccess = data['AccessToken'] ?? data['accessToken'];
  final newRefresh = data['RefreshToken'] ?? data['refreshToken'];
  if (newAccess == null || newRefresh == null) return null;

  await CacheHelper.saveData(key: 'accessToken', value: newAccess);
  await CacheHelper.saveData(key: 'refreshToken', value: newRefresh);
  return newAccess as String;
}

Future<void> _expireSession() async {
  if (_sessionExpiring) return;
  _sessionExpiring = true;

  // Full local cleanup (providers + cache). Token is already dead, no revoke.
  try {
    await getIt<UserProvider>().logout(revoke: false);
  } catch (e) {
    log('[DioInterceptor]: Logout cleanup failed: $e');
    await CacheHelper.clearSession();
  }

  _showSessionExpiredDialog();
}

// TODO(clean-arch): move to presentation layer, trigger via an auth-state stream.
void _showSessionExpiredDialog() {
  final context = navigatorKey.currentContext;
  if (context == null) {
    _sessionExpiring = false;
    return;
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8.w),
            Text(
              context.l10n.sessionExpiredTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        content: Text(
          context.l10n.sessionExpiredMessage,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              _sessionExpiring = false;
              Navigator.of(dialogContext).pop();
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            },
            child: Text(
              context.l10n.login,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    },
  );
}