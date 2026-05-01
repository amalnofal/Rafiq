import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:rafiq/core/services/auth_service.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthService _authService;

  RegisterCubit(this._authService) : super(RegisterInitial());

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

    // دكتور
    String? specialization,
    String? subSpecialization,

    // ملفات
    File? frontId,
    File? backId,
    File? unionCard,
    File? profilePic,
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
      log("✅ Response Data: ${response.data}");

      // 1. التحقق من النجاح
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map && response.data['isSuccess'] == false) {
          final backendMsg =
              response.data['message']?.toString() ?? "invalidData";
          emit(RegisterFailure(errorMessage: backendMsg));
        } else {
          emit(const RegisterSuccess(message: "registrationSuccess"));
        }
      } else {
        emit(RegisterFailure(errorMessage: "registrationFailed"));
      }
    } on DioException catch (e) {
      String errorMsg = "connectionError";
      if (e.response != null) {
        // لو الرد فاضي تماماً
        if (e.response?.data == null ||
            e.response?.data.toString().isEmpty == true) {
          errorMsg = "خطأ من السيرفر (كود ${e.response?.statusCode})";
        } else {
          // لو فيه داتا، نحاول نقراها بذكاء
          if (e.response?.data is Map) {
            // لو الرد JSON ندور على مفاتيح الرسائل المعروفة
            errorMsg =
                e.response?.data['message'] ??
                e.response?.data['title'] ??
                e.response?.data['errors']?.toString() ??
                e.response?.data.toString();
          } else {
            // لو الرد نص عادي
            errorMsg = e.response?.data.toString() ?? "خطأ غير معروف";
          }
        }
      }

      log("❌ Dio Error: $errorMsg");
      emit(RegisterFailure(errorMessage: errorMsg));
    } catch (e) {
      emit(RegisterFailure(errorMessage: "unexpectedError $e"));
    }
  }

  // دالة التحقق من الإيميل
  Future<void> verifyEmail(String email) async {
    // 1. بنعرف الـ UI إننا بنحمل عشان يظهر اللودينج
    emit(EmailCheckLoading());

    try {
      // 2. بنكلم السيرفيس نسألها
      final bool isExist = await _authService.checkEmail(email);

      if (isExist) {
        // لو رجع true (يعني الإيميل موجود) -> نطلع خطأ
        emit(const EmailTaken(message: "emailAlreadyExists"));
      } else {
        // لو رجع false (يعني مش موجود) -> تمام كمل
        emit(EmailAvailable());
      }
    } catch (e) {
      emit(RegisterFailure(errorMessage: "connectionError"));
    }
  }
}
