import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value == null) return await removeData(key: key);

    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is int) return await sharedPreferences.setInt(key, value);
    if (value is bool) return await sharedPreferences.setBool(key, value);
    if (value is double) return await sharedPreferences.setDouble(key, value);
    if (value is List<String>) {
      return await sharedPreferences.setStringList(key, value);
    }
    throw ArgumentError('Unsupported type for "$key": ${value.runtimeType}');
  }

  static dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

  static Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }

  static const _keepKeys = {'onBoardingSeen', 'language', 'darkMode'};

  /// Wipes all user/session data, keeps device-level preferences.
  static Future<void> clearSession() async {
    for (final key in sharedPreferences.getKeys().toList()) {
      if (!_keepKeys.contains(key)) {
        await sharedPreferences.remove(key);
      }
    }
  }
}
