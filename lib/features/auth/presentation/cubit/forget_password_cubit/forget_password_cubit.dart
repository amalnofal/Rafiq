import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rafiq/core/error/failure.dart';
import 'package:rafiq/features/auth/domain/repositories/auth_repository.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final AuthRepository _authRepository;

  ForgetPasswordCubit(this._authRepository) : super(ForgetPasswordInitial());

  // 1. Send the reset code to the email.
  Future<void> sendCode({required String email}) async {
    emit(ForgetPasswordLoading());
    try {
      await _authRepository.sendResetCode(email: email);
      emit(SendCodeSuccess());
    } on Failure catch (f) {
      emit(ForgetPasswordFailure(errMessage: _sendCodeKey(f)));
    } catch (_) {
      emit(ForgetPasswordFailure(errMessage: 'unexpectedError'));
    }
  }

  // 2. Check the OTP.
  Future<void> verifyOtp({required String email, required String otp}) async {
    emit(ForgetPasswordLoading());
    try {
      await _authRepository.verifyOtp(email: email, otp: otp);
      emit(VerifyOtpSuccess());
    } on Failure catch (f) {
      emit(ForgetPasswordFailure(errMessage: _codeKey(f)));
    } catch (_) {
      emit(ForgetPasswordFailure(errMessage: 'unexpectedError'));
    }
  }

  // 3. Set the new password.
  Future<void> resetNewPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    emit(ForgetPasswordLoading());
    try {
      await _authRepository.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
      emit(ResetPasswordSuccess());
    } on Failure catch (f) {
      emit(ForgetPasswordFailure(errMessage: _codeKey(f)));
    } catch (_) {
      emit(ForgetPasswordFailure(errMessage: 'unexpectedError'));
    }
  }

  String _sendCodeKey(Failure f) => switch (f) {
    BadRequestFailure() || NotFoundFailure() => 'userNotFound',
    NetworkFailure() => 'connectionError',
    _ => 'unexpectedError',
  };

  String _codeKey(Failure f) => switch (f) {
    BadRequestFailure() || UnauthorizedFailure() => 'invalidCode',
    NetworkFailure() => 'connectionError',
    _ => 'unexpectedError',
  };

  // Ignore emits after the cubit is closed (screen left while a request runs).
  @override
  void emit(ForgetPasswordState state) {
    if (!isClosed) super.emit(state);
  }
}
