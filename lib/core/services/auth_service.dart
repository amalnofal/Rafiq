import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio;

  AuthService(this._dio);

  // Logout
  Future<void> revokeToken(String refreshToken) async {
    await _dio.post(
      '/Account/RevokeToken',
      data: jsonEncode(refreshToken),
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  // ==========================================
  // تغيير كلمة المرور من الإعدادات
  // ==========================================
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await _dio.put(
        '/User/change-password',
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );
      log("[AuthService]: تم تغيير كلمة المرور بنجاح.");
    } catch (e) {
      log("[AuthService]: فشل تغيير كلمة المرور: $e");
      rethrow;
    }
  }

  // ==========================================
  // حذف الحساب
  // ==========================================
  Future<void> deleteAccount({required String password}) async {
    try {
      await _dio.delete('/User/delete-account', data: {'password': password});
      log("[AuthService]: تم حذف الحساب بنجاح.");
    } catch (e) {
      log("[AuthService]: فشل حذف الحساب: $e");
      rethrow;
    }
  }
}
