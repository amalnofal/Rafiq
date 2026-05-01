import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';

class UserService {
  final Dio _dio;

  UserService(this._dio);

  // ==========================================
  // جلب بيانات الملف الشخصي بالكامل
  // ==========================================
  Future<Response> getMyProfile() async {
    try {
      final response = await _dio.get('/User/my-profile');
      log("[UserService]: تم استلام بيانات الملف الشخصي بنجاح.");
      log("[UserService]: بيانات المستخدم: ${response.data}");
      return response;
    } catch (e) {
      log("[UserService]: فشل جلب بيانات الملف الشخصي: $e");
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
}
