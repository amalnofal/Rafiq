import 'package:dio/dio.dart';
import 'package:rafiq/features/auth/data/models/auth_response_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);

  final Dio _dio;

  static const _loginPath = '/Account/Login';
  static const _forgetPasswordPath = '/Account/Forget-Password';
  static const _verifyOtpPath = '/Account/Verify-Otp';
  static const _resetPasswordPath = '/Account/Reset-Password';

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      _loginPath,
      data: {'email': email, 'password': password},
    );
    return AuthResponseModel.fromJson(response.data);
  }

  Future<void> sendResetCode({required String email}) async {
    await _dio.post(_forgetPasswordPath, data: {'email': email});
  }

  Future<void> verifyOtp({required String email, required String otp}) async {
    await _dio.post(_verifyOtpPath, data: {'email': email, 'otp': otp});
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    await _dio.post(
      _resetPasswordPath,
      data: {
        'email': email,
        'otp': otp,
        'newPassword': newPassword,
        'confirmNewPassword': newPassword,
      },
    );
  }
}
