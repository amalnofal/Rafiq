import 'dart:io';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:get_it/get_it.dart';
import 'package:rafiq/core/controller/appointment_provider.dart';
import 'package:rafiq/core/controller/clinic_provider.dart';
import 'package:rafiq/core/controller/pet_provider.dart';
import 'package:rafiq/core/services/appointment_service.dart';
import 'package:rafiq/core/services/auth_service.dart';
import 'package:rafiq/core/services/clinic_service.dart';
import 'package:rafiq/core/services/pet_service.dart';
import 'package:rafiq/core/services/user_service.dart';
import 'package:rafiq/features/auth/presentation/manager/forget_password_cubit/forget_password_cubit.dart';
import 'package:rafiq/features/auth/presentation/manager/login_cubit/login_cubit.dart';
import 'package:rafiq/features/auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:rafiq/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rafiq/core/helper/cache_helper.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ==========================================
  // 1. Core Services & Providers
  // ==========================================
  getIt.registerLazySingleton(() => AuthService(getIt()));
  getIt.registerLazySingleton(() => UserService(getIt()));
  getIt.registerLazySingleton(() => PetService(getIt()));
  getIt.registerLazySingleton(() => PetProvider());
  getIt.registerLazySingleton(() => ClinicService(getIt()));
  getIt.registerLazySingleton(() => ClinicProvider(getIt()));
  getIt.registerLazySingleton(() => AppointmentService(getIt()));
  getIt.registerLazySingleton(() => AppointmentProvider());

  // ==========================================
  // 2. External Packages
  // ==========================================
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  // ==========================================
  // 3. Dio Setup & Interceptors
  // ==========================================
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://rafiq-app.runasp.net/api',
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    // Bypassing SSL Certificate validation
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    // Adding Interceptor for Token Management
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = CacheHelper.getData(key: 'accessToken');

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            log(
              "[DioInterceptor]: Unauthorized request at ${error.requestOptions.path}",
            );

            final currentCacheAccessToken = CacheHelper.getData(
              key: 'accessToken',
            );
            final requestToken = error.requestOptions.headers['Authorization']
                ?.replaceAll('Bearer ', '');

            // Handling Race Condition
            if (currentCacheAccessToken != null &&
                currentCacheAccessToken != requestToken) {
              log(
                "[DioInterceptor]: Token already refreshed by another request. Retrying...",
              );
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

                log(
                  "[DioInterceptor]: Attempting to fetch a new access token...",
                );
                final response = await refreshDio.post(
                  '/Account/RefreshToken',
                  data: {
                    "AccessToken": currentCacheAccessToken,
                    "RefreshToken": oldRefreshToken,
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
                      "[DioInterceptor]: Token refreshed successfully. Retrying original request.",
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
                log(
                  "[DioInterceptor]: Token refresh failed. Logging user out: $e",
                );

                await CacheHelper.clearData();
                navigatorKey.currentState?.pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );

                return handler.next(error);
              }
            }
          }
          return handler.next(error);
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
}
