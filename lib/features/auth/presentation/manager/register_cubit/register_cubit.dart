import 'dart:developer';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:rafiq/core/services/auth_service.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthService _authService;

  RegisterCubit(this._authService) : super(RegisterInitial());

  // ==========================================================
  // 1. دالة تسجيل حساب جديد
  // ==========================================================
  Future<void> submitRegister({
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
    bool isTravelAndTransport = false,
    bool isAdoptionAndRescue = false,
    bool isStoriesAndExperiences = false,
    bool isUpbringingAndParenting = false,

    // بيانات الدكتور
    String? specialization,
    String? subSpecialization,

    // ملفات وصور
    File? frontId,
    File? backId,
    File? unionCard,
    File? profilePic, // 👈 تم استخدامه الآن في نداء السيرفيس
  }) async {
    emit(RegisterLoading());

    try {
      final response = await _authService.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        password: password,
        confirmPassword: confirmPassword,
        gender: gender,
        role: role,
        dateOfBirth: dateOfBirth,

        isHealthAndCare: isHealthAndCare,
        isNutritionAndFood: isNutritionAndFood,
        isTrainingAndBehavior: isTrainingAndBehavior,
        isGroomingAndAppearances: isGroomingAndAppearances,
        isStoriesAndExperiences: isStoriesAndExperiences,
        isTravelAndTransport: isTravelAndTransport,
        isAdoptionAndRescue: isAdoptionAndRescue,
        isUpbringingAndParenting: isUpbringingAndParenting,

        specialization: specialization,
        subSpecialization: subSpecialization,

        frontNationalId: frontId,
        backNationalId: backId,
        unionMembershipCard: unionCard,
      );

      log("✅ Server Response: ${response.statusCode}");

      // التحقق من نجاح العملية
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map && data['isSuccess'] == false) {
          final backendMsg =
              data['message']?.toString() ?? "registrationFailed";
          emit(RegisterFailure(errorMessage: backendMsg));
        } else {
          emit(const RegisterSuccess(message: "registrationSuccess"));
        }
      } else {
        emit(const RegisterFailure(errorMessage: "registrationFailed"));
      }
    } on DioException catch (e) {
      // 🚨 هنا بنحدد نوع الخطأ بدون ما نطلع SnackBar يدوية
      String errorKey = "unexpectedError";

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        errorKey =
            "connectionError"; // السناك بار هتطلع من الـ Interceptor أوتوماتيك
      } else if (e.response != null) {
        final data = e.response?.data;
        if (data is Map) {
          // استخراج رسالة الخطأ المحددة من الباك إند (مثلاً: الإيميل موجود فعلاً)
          errorKey = data['message'] ?? data['title'] ?? "registrationFailed";
        } else {
          errorKey = "serverError";
        }
      }

      log("❌ Register Error Key: $errorKey");
      emit(RegisterFailure(errorMessage: errorKey));
    } catch (e) {
      log("❌ General Register Error: $e");
      emit(const RegisterFailure(errorMessage: "unexpectedError"));
    }
  }

  // ==========================================================
  // 2. دالة التحقق من الإيميل
  // ==========================================================
  Future<void> verifyEmail(String email) async {
    emit(EmailCheckLoading());

    try {
      final bool isExist = await _authService.checkEmail(email);

      if (isExist) {
        emit(const EmailTaken(message: "emailAlreadyExists"));
      } else {
        emit(EmailAvailable());
      }
    } on DioException catch (e) {
      String errorKey = "unexpectedError";
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        errorKey = "connectionError";
      }
      emit(RegisterFailure(errorMessage: errorKey));
    } catch (e) {
      emit(const RegisterFailure(errorMessage: "unexpectedError"));
    }
  }
}
