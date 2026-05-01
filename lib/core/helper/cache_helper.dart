import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  // بننادي عليها في الـ main.dart>
  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  // دالة الحفظ (Generic)
  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value == null) return await removeData(key: key);

    if (value is String) return await sharedPreferences.setString(key, value);
    if (value is int) return await sharedPreferences.setInt(key, value);
    if (value is bool) return await sharedPreferences.setBool(key, value);
    return await sharedPreferences.setDouble(key, value);
  }

  // دالة القراءة
  static dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

  // دالة الحذف (للخروج)
  static Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }

  // دالة مسح كل حاجة (Clear All)
  static Future<bool> clearData() async {
    return await sharedPreferences.clear();
  }
}
