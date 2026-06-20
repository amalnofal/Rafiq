import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';

class UserService {
  final Dio _dio;

  UserService(this._dio);

  // ==========================================
  // جلب بيانات الملف الشخصي بالكامل (لي)
  // ==========================================
  Future<Response> getMyProfile() async {
    try {
      final response = await _dio.get('/User/my-profile');
      log("[UserService]: تم استلام بيانات الملف الشخصي بنجاح.");
      return response;
    } catch (e) {
      log("[UserService]: فشل جلب بيانات الملف الشخصي: $e");
      rethrow;
    }
  }

  // ==========================================
  // 🚨 جلب بيانات أي مستخدم آخر عن طريق الـ ID (الجديدة)
  // ==========================================
  Future<Response> getUserProfileById(String userId) async {
    try {
      final response = await _dio.get('/User/profile/$userId');
      log("[UserService]: تم استلام بيانات بروفايل المستخدم $userId بنجاح.");
      return response;
    } catch (e) {
      log("[UserService]: فشل جلب بيانات المستخدم $userId: $e");
      rethrow;
    }
  }

  // ==========================================
  // رفع صورة الملف الشخصي
  // ==========================================
  Future<void> uploadProfilePhoto(File file) async {
    try {
      String fileName = file.path.split('/').last;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      await _dio.post('/User/profile-photo', data: formData);
      log("[UserService]: تم رفع صورة الملف الشخصي بنجاح.");
    } catch (e) {
      log("[UserService]: فشل رفع صورة الملف الشخصي: $e");
      rethrow;
    }
  }

  // ==========================================
  // رفع صورة الغلاف
  // ==========================================
  Future<void> uploadCoverPhoto(File file) async {
    try {
      String fileName = file.path.split('/').last;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      await _dio.post('/User/cover-photo', data: formData);
      log("[UserService]: تم رفع صورة الغلاف بنجاح.");
    } catch (e) {
      log("[UserService]: فشل رفع صورة الغلاف: $e");
      rethrow;
    }
  }

  // ==========================================
  // متابعة مستخدم
  // ==========================================
  Future<Response> followUser(String userId) async {
    try {
      final response = await _dio.post('/User/$userId/follow');
      log("[UserService]: تم متابعة المستخدم $userId بنجاح.");
      return response;
    } catch (e) {
      log("[UserService]: فشل متابعة المستخدم: $e");
      rethrow;
    }
  }

  // ==========================================
  // إلغاء متابعة مستخدم
  // ==========================================
  Future<Response> unfollowUser(String userId) async {
    try {
      final response = await _dio.post('/User/$userId/unfollow');
      log("[UserService]: تم إلغاء متابعة المستخدم $userId بنجاح.");
      return response;
    } catch (e) {
      log("[UserService]: فشل إلغاء المتابعة: $e");
      rethrow;
    }
  }

  // ==========================================
  // البحث عن مستخدمين
  // ==========================================
  Future<Response> searchUsers(
    String query, {
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/User/search',
        queryParameters: {
          'query': query,
          'pageNumber': pageNumber,
          'pageSize': pageSize,
        },
      );
      log("[UserService]: تم البحث عن '$query' بنجاح.");
      return response;
    } catch (e) {
      log("[UserService]: فشل البحث عن مستخدمين: $e");
      rethrow;
    }
  }

  // ==========================================
  // جلب بيانات الحساب الأساسية للتعديل
  // ==========================================
  Future<Response> getProfileForEdit() async {
    try {
      final response = await _dio.get('/User/profile-phone-email-name');
      log("[UserService]: تم جلب بيانات التعديل بنجاح.");
      return response;
    } catch (e) {
      log("[UserService]: فشل جلب بيانات التعديل: $e");
      rethrow;
    }
  }

  Future<void> updateName({
    required String firstName,
    required String lastName,
  }) async {
    await _dio.put(
      '/User/update-name',
      data: {"firstName": firstName, "lastName": lastName},
    );
  }

  Future<void> updateEmail({required String newEmail}) async {
    await _dio.put('/User/update-email', data: {"newEmail": newEmail});
  }

  Future<void> updatePhone({required String newPhoneNumber}) async {
    await _dio.put(
      '/User/change-phone-number',
      data: {"newPhoneNumber": newPhoneNumber},
    );
  }

  Future<Response> deletePhone() async {
    return await _dio.delete('/User/delete-phone-number');
  }

  // ==========================================
  // جلب إعدادات الخصوصية
  // ==========================================
  Future<Response> getUserSettings() async {
    try {
      final response = await _dio.get('/User/settings');
      log("[UserService]: تم جلب الإعدادات بنجاح.");
      return response;
    } catch (e) {
      log("[UserService]: فشل جلب الإعدادات: $e");
      rethrow;
    }
  }

  // ==========================================
  // تحديث إعدادات الخصوصية
  // ==========================================
  Future<Response> updateUserSettings(Map<String, dynamic> settingsData) async {
    try {
      final response = await _dio.patch(
        '/User/update-settings',
        data: settingsData,
      );
      log("[UserService]: تم تحديث الإعدادات بنجاح.");
      return response;
    } catch (e) {
      log("[UserService]: فشل تحديث الإعدادات: $e");
      rethrow;
    }
  }
}
