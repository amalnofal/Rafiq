import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rafiq/core/services/auth_service.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final AuthService _authService;

  ForgetPasswordCubit(this._authService) : super(ForgetPasswordInitial());
  DateTime? lastTimeSent;
  // 1. خطوة إرسال الكود
  Future<void> sendCode({required String email}) async {
    if (isClosed) return;
    lastTimeSent = DateTime.now();
    emit(ForgetPasswordLoading());
    try {
      await _authService.sendForgetPasswordCode(email: email);
      if (isClosed) return;
      emit(SendCodeSuccess());
    } on DioException catch (e) {
      String errorKey = "unexpectedError";
      if (e.response?.statusCode == 400 || e.response?.statusCode == 404) {
        errorKey = "userNotFound"; // الإيميل مش مسجل
      } else if (_isConnectionError(e)) {
        errorKey = "connectionError";
      }
      if (isClosed) return;
      emit(ForgetPasswordFailure(errMessage: errorKey));
    } catch (e) {
      if (isClosed) return;
      emit(ForgetPasswordFailure(errMessage: "unexpectedError"));
    }
  }

  // 2. خطوة التحقق من الـ OTP
  Future<void> verifyOtp({required String email, required String otp}) async {
    emit(ForgetPasswordLoading());
    try {
      await _authService.verifyOtp(email: email, otp: otp);
      if (isClosed) return;
      emit(VerifyOtpSuccess());
    } on DioException catch (e) {
      String errorKey = "unexpectedError";
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        errorKey = "invalidCode"; // الكود غلط أو انتهى
      } else if (_isConnectionError(e)) {
        errorKey = "connectionError";
      }
      if (isClosed) return;
      emit(ForgetPasswordFailure(errMessage: errorKey));
      return;
    } catch (e) {
      if (isClosed) return;
      emit(ForgetPasswordFailure(errMessage: "unexpectedError"));
    }
  }

  // 3. خطوة تعيين كلمة مرور جديدة
  Future<void> resetNewPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    if (isClosed) return;
    emit(ForgetPasswordLoading());
    try {
      await _authService.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
      if (isClosed) return;
      emit(ResetPasswordSuccess());
    } on DioException catch (e) {
      String errorKey = "unexpectedError";
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        errorKey = "invalidCode";
      } else if (_isConnectionError(e)) {
        errorKey = "connectionError";
      }
      if (isClosed) return;
      emit(ForgetPasswordFailure(errMessage: errorKey));
    } catch (e) {
      if (isClosed) return;
      emit(ForgetPasswordFailure(errMessage: "unexpectedError"));
    }
  }

  bool _isConnectionError(DioException e) {
    return e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout;
  }
}
