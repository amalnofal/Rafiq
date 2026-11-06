import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:rafiq/core/helper/cache_helper.dart';

/// Adds the access token, refreshes it on 401, and retries the request once.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.dio,
    required this.baseUrl,
    required this.onSessionExpired,
    required this.onNetworkError,
  });

  final Dio dio;
  final String baseUrl;
  final Future<void> Function() onSessionExpired;
  final void Function() onNetworkError;

  // Shared in-flight refresh, so parallel 401s trigger only one refresh call.
  Future<String?>? _refreshFuture;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
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
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Network problems: notify and pass the error on.
    if (_isNetworkError(err)) {
      onNetworkError();
      return handler.next(err);
    }

    final is401 = err.response?.statusCode == 401;
    final alreadyRetried = err.requestOptions.extra['retried'] == true;
    final isLogin = err.requestOptions.path.contains('/Account/Login');

    if (!is401 || alreadyRetried || isLogin) {
      return handler.next(err);
    }

    // Get a fresh access token.
    String? token;
    final cachedToken = CacheHelper.getData(key: 'accessToken');
    final sentToken = err.requestOptions.headers['Authorization']
        ?.toString()
        .replaceAll('Bearer ', '');

    if (cachedToken != null && cachedToken != sentToken) {
      // Another request already refreshed the token.
      token = cachedToken as String;
    } else {
      if (CacheHelper.getData(key: 'refreshToken') == null) {
        return handler.next(err);
      }
      try {
        token = await _refreshAccessToken();
      } on DioException catch (e) {
        final status = e.response?.statusCode;
        // Only a rejected refresh token means the session is really over.
        if (status == 400 || status == 401) {
          await onSessionExpired();
        }
        return handler.next(err);
      } catch (e) {
        log('[AuthInterceptor]: Refresh failed: $e');
        return handler.next(err);
      }
    }

    if (token == null) return handler.next(err);

    // Retry the original request (outside the refresh try/catch).
    final options = err.requestOptions
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
  }

  bool _isNetworkError(DioException e) =>
      e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.unknown;

  Future<String?> _refreshAccessToken() {
    return _refreshFuture ??= _doRefresh().whenComplete(() {
      _refreshFuture = null;
    });
  }

  Future<String?> _doRefresh() async {
    log('[AuthInterceptor]: Refreshing access token...');

    // Separate Dio instance: no interceptors, no loop.
    final response = await Dio(BaseOptions(baseUrl: baseUrl)).post(
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
}
