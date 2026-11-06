import 'package:dio/dio.dart';
import 'package:rafiq/core/constants/api_constants.dart';
import 'package:rafiq/core/network/auth_interceptor.dart';
import 'package:rafiq/core/storage/token_storage.dart';

Dio createDio({
  required Future<void> Function() onSessionExpired,
  required void Function() onNetworkError,
  required TokenStorage tokenStorage,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
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
    AuthInterceptor(
      tokenStorage: tokenStorage,
      dio: dio,
      baseUrl: ApiConstants.baseUrl,
      onSessionExpired: onSessionExpired,
      onNetworkError: onNetworkError,
    ),
  );

  return dio;
}
