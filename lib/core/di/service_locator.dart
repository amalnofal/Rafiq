import 'dart:io';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:rafiq/core/controller/appointment_provider.dart';
import 'package:rafiq/core/controller/clinic_provider.dart';
import 'package:rafiq/core/controller/community_provider.dart';
import 'package:rafiq/core/controller/pet_provider.dart';
import 'package:rafiq/core/controller/store_provider.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/services/appointment_service.dart';
import 'package:rafiq/core/services/auth_service.dart';
import 'package:rafiq/core/services/chat_service.dart';
import 'package:rafiq/core/services/clinic_service.dart';
import 'package:rafiq/core/services/community_service.dart';
import 'package:rafiq/core/services/pet_service.dart';
import 'package:rafiq/core/services/store_service.dart';
import 'package:rafiq/core/services/user_service.dart';
import 'package:rafiq/features/auth/presentation/manager/forget_password_cubit/forget_password_cubit.dart';
import 'package:rafiq/features/auth/presentation/manager/login_cubit/login_cubit.dart';
import 'package:rafiq/features/auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:rafiq/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:rafiq/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rafiq/core/helper/cache_helper.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ==========================================
  // 1. Core Services & Providers
  // ==========================================
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

  // ==========================================
  // 2. External Packages
  // ==========================================
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  // ==========================================
  // 3. Dio Setup & Unified Interceptor
  // ==========================================
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://rafiq-app.runasp.net/api',
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // Bypassing SSL Certificate validation
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    // 🚀 الرادار الموحد (Unified Interceptor)
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 🚀 1. الفحص الاستباقي (Fail Fast) لكل الأبلكيشن
          final connectivityResult = await Connectivity().checkConnectivity();
          if (connectivityResult.contains(ConnectivityResult.none)) {
            // لو مفيش نت، ارفض الريكويست فوراً في 0 ثانية كأنه Connection Error
            return handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.connectionError,
                error: 'No Internet Connection',
              ),
            );
          }

          // 🔑 2. لو في نت، حط التوكن وكمل طريقك عادي
          final token = CacheHelper.getData(key: 'accessToken');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          final context = navigatorKey.currentContext;

          // 📡 أولاً: فحص مشاكل الإنترنت والـ Timeout
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.connectionError ||
              error.type == DioExceptionType.unknown) {
            if (context != null) {
              try {
                showSnackBar(
                  context,
                  context.l10n.connectionError,
                  isError: true,
                );
              } catch (_) {}
            }
            return handler.next(error);
          }

          // 🔑 ثانياً: معالجة انتهاء التوكن (401)
          if (error.response?.statusCode == 401) {
            log(
              "[DioInterceptor]: Unauthorized at ${error.requestOptions.path}",
            );

            final currentCacheAccessToken = CacheHelper.getData(
              key: 'accessToken',
            );
            final requestToken = error.requestOptions.headers['Authorization']
                ?.replaceAll('Bearer ', '');

            // معالجة الـ Race Condition
            if (currentCacheAccessToken != null &&
                currentCacheAccessToken != requestToken) {
              log("[DioInterceptor]: Token already refreshed. Retrying...");
              error.requestOptions.headers['Authorization'] =
                  'Bearer $currentCacheAccessToken';

              if (error.requestOptions.data is FormData) {
                error.requestOptions.data =
                    (error.requestOptions.data as FormData).clone();
              }
              final clonedRequest = await dio.fetch(error.requestOptions);
              return handler.resolve(clonedRequest);
            }

            final oldRefreshToken = CacheHelper.getData(key: 'refreshToken');
            if (oldRefreshToken != null) {
              try {
                final refreshDio = Dio(
                  BaseOptions(baseUrl: 'https://rafiq-app.runasp.net/api'),
                );

                log("[DioInterceptor]: Refreshing access token...");
                final response = await refreshDio.post(
                  '/Account/RefreshToken',
                  data: {
                    "accessToken": currentCacheAccessToken,
                    "refreshToken": oldRefreshToken,
                  },
                );

                if (response.statusCode == 200) {
                  final responseData =
                      response.data.containsKey('data') &&
                          response.data['data'] != null
                      ? response.data['data']
                      : response.data;

                  final newAccessToken =
                      responseData['AccessToken'] ??
                      responseData['accessToken'];
                  final newRefreshToken =
                      responseData['RefreshToken'] ??
                      responseData['refreshToken'];

                  if (newAccessToken != null && newRefreshToken != null) {
                    await CacheHelper.saveData(
                      key: 'accessToken',
                      value: newAccessToken,
                    );
                    await CacheHelper.saveData(
                      key: 'refreshToken',
                      value: newRefreshToken,
                    );

                    log(
                      "[DioInterceptor]: Refreshed. Retrying original request.",
                    );
                    error.requestOptions.headers['Authorization'] =
                        'Bearer $newAccessToken';

                    if (error.requestOptions.data is FormData) {
                      error.requestOptions.data =
                          (error.requestOptions.data as FormData).clone();
                    }
                    final clonedRequest = await dio.fetch(error.requestOptions);
                    return handler.resolve(clonedRequest);
                  }
                }
              } catch (e) {
                log("[DioInterceptor]: Refresh failed: $e");
                await CacheHelper.clearData();
                _showSessionExpiredDialog();
                return handler.next(error);
              }
            }
          }

          return handler.next(error); // لأي إيرور تاني زي 400 أو 500
        },
      ),
    );

    return dio;
  });

  // ==========================================
  // 4. Cubits (Blocs)
  // ==========================================
  getIt.registerFactory(() => ForgetPasswordCubit(getIt()));
  getIt.registerFactory(() => LoginCubit(getIt()));
  getIt.registerFactory(() => RegisterCubit(getIt()));
  getIt.registerFactory(() => ChatCubit(getIt()));
}

void _showSessionExpiredDialog() {
  final context = navigatorKey.currentContext;
  if (context == null) return;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
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
