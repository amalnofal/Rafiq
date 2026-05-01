import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:rafiq/core/models/auth_response_model.dart';

class AuthService {
  final Dio _dio;

  AuthService(this._dio);

  // ==========================================
  // تسجيل حساب جديد
  // ==========================================
  Future<Response> register({
    required String firstName,
    required String lastName,
    required String email,
    String? phone,
    required String password,
    required String confirmPassword,
    required int gender,
    required String role,
    required DateTime dateOfBirth,
    bool isHealthAndCare = false,
    bool isNutritionAndFood = false,
    bool isTrainingAndBehavior = false,
    bool isGroomingAndAppearances = false,
    bool isStoriesAndExperiences = false,
    bool isTravelAndTransport = false,
    bool isAdoptionAndRescue = false,
    bool isUpbringingAndParenting = false,
    String? specialization,
    String? subSpecialization,
    File? frontNationalId,
    File? backNationalId,
    File? unionMembershipCard,
  }) async {
    try {
      Map<String, dynamic> dataMap = {
        "FirstName": firstName,
        "LastName": lastName,
        "Email": email,
        "PhoneNumber": phone ?? "",
        "Password": password,
        "ConfirmPassword": confirmPassword,
        "Gender": gender,
        "Role": role, 
        "DateOfBirth": dateOfBirth.toIso8601String().split('T')[0],
        "IsHealthAndCare": isHealthAndCare,
        "IsNutritionAndFood": isNutritionAndFood,
        "IsTrainingAndBehavior": isTrainingAndBehavior,
        "IsGroomingAndAppearances": isGroomingAndAppearances,
        "IsStoriesAndExperiences": isStoriesAndExperiences,
        "IsTravelAndTransport": isTravelAndTransport,
        "IsAdoptionAndRescue": isAdoptionAndRescue,
        "IsUpbringingAndParenting": isUpbringingAndParenting,
      };

      if (role == "Doctor") {
        if (specialization != null) dataMap["Specialization"] = specialization;
        if (subSpecialization != null) {
          dataMap["SupSpecialization"] = subSpecialization;
        }
      }

      FormData formData = FormData.fromMap(dataMap);

      if (frontNationalId != null) {
        formData.files.add(
          MapEntry(
            "FrontNationalID",
            await MultipartFile.fromFile(
              frontNationalId.path,
              filename: "front.jpg",
            ),
          ),
        );
      }
      if (backNationalId != null) {
        formData.files.add(
          MapEntry(
            "BackNationalID",
            await MultipartFile.fromFile(
              backNationalId.path,
              filename: "back.jpg",
            ),
          ),
        );
      }
      if (unionMembershipCard != null) {
        formData.files.add(
          MapEntry(
            "UnionMembershipCard",
            await MultipartFile.fromFile(
              unionMembershipCard.path,
              filename: "union.jpg",
            ),
          ),
        );
      }

      final response = await _dio.post(
        '/Account/Register',
        data: formData,
        options: Options(validateStatus: (status) => status! < 500),
      );

      log("[AuthService]: تم إرسال طلب تسجيل الحساب بنجاح.");
      return response;
    } catch (e) {
      log("[AuthService]: فشل في إرسال طلب تسجيل الحساب: $e");
      rethrow;
    }
  }

  // ==========================================
  // التحقق من وجود الإيميل
  // ==========================================
  Future<bool> checkEmail(String email) async {
    try {
      final response = await _dio.get(
        '/Account/check-email',
        queryParameters: {'email': email},
      );
      return response.data['exists'];
    } catch (e) {
      log("[AuthService]: خطأ أثناء التحقق من الإيميل: $e");
      rethrow;
    }
  }

  // ==========================================
  // تسجيل الدخول
  // ==========================================
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/Account/Login',
        data: {'email': email, 'password': password},
      );

      log("[AuthService]: تم تسجيل الدخول بنجاح.");
      return AuthResponseModel.fromJson(response.data);
    } catch (e) {
      log("[AuthService]: فشل تسجيل الدخول: $e");
      rethrow;
    }
  }

  // ==========================================
  // إرسال كود استعادة كلمة المرور
  // ==========================================
  Future<void> sendForgetPasswordCode({required String email}) async {
    try {
      await _dio.post('/Account/Forget-Password', data: {'email': email});
      log("[AuthService]: تم إرسال كود استعادة كلمة المرور بنجاح.");
    } catch (e) {
      log("[AuthService]: فشل إرسال كود استعادة كلمة المرور: $e");
      rethrow;
    }
  }

  // ==========================================
  // التحقق من الكود (OTP)
  // ==========================================
  Future<void> verifyOtp({required String email, required String otp}) async {
    try {
      await _dio.post(
        '/Account/Verify-Otp',
        data: {'email': email, 'otp': otp},
      );
      log("[AuthService]: تم التحقق من الكود بنجاح.");
    } catch (e) {
      log("[AuthService]: فشل التحقق من الكود: $e");
      rethrow;
    }
  }

  // ==========================================
  // تعيين كلمة مرور جديدة
  // ==========================================
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      await _dio.post(
        '/Account/Reset-Password',
        data: {
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
          'confirmNewPassword': newPassword,
        },
      );
      log("[AuthService]: تم تغيير كلمة المرور بنجاح.");
    } catch (e) {
      log("[AuthService]: فشل تغيير كلمة المرور: $e");
      rethrow;
    }
  }
}