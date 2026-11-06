import 'package:rafiq/core/helper/cache_helper.dart';

/// Single place that reads and writes the auth tokens.
class TokenStorage {
  static const _accessKey = 'accessToken';
  static const _refreshKey = 'refreshToken';

  String? get accessToken => CacheHelper.getData(key: _accessKey) as String?;
  String? get refreshToken => CacheHelper.getData(key: _refreshKey) as String?;

  Future<void> save({required String access, required String refresh}) async {
    await CacheHelper.saveData(key: _accessKey, value: access);
    await CacheHelper.saveData(key: _refreshKey, value: refresh);
  }

  Future<void> clear() async {
    await CacheHelper.removeData(key: _accessKey);
    await CacheHelper.removeData(key: _refreshKey);
  }
}
