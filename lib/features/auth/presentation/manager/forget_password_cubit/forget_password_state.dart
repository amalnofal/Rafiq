part of 'forget_password_cubit.dart';

abstract class ForgetPasswordState {}

class ForgetPasswordInitial extends ForgetPasswordState {}

class ForgetPasswordLoading extends ForgetPasswordState {}

// 1. نجاح إرسال الكود -> الانتقال لشاشة OTP
class SendCodeSuccess extends ForgetPasswordState {}

// 2. نجاح التحقق من الكود -> الانتقال لشاشة تغيير الباسورد
class VerifyOtpSuccess extends ForgetPasswordState {}

// 3. نجاح تغيير الباسورد -> الانتقال لشاشة اللوجين
class ResetPasswordSuccess extends ForgetPasswordState {}

class ForgetPasswordFailure extends ForgetPasswordState {
  final String errMessage;
  ForgetPasswordFailure({required this.errMessage});
}