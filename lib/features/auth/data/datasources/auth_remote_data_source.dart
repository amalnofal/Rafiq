import 'package:dio/dio.dart';
import 'package:rafiq/core/error/failure.dart';
import 'package:rafiq/features/auth/data/models/auth_response_model.dart';
import 'package:rafiq/features/auth/domain/entities/register_params.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);

  final Dio _dio;

  static const _loginPath = '/Account/Login';
  static const _forgetPasswordPath = '/Account/Forget-Password';
  static const _verifyOtpPath = '/Account/Verify-Otp';
  static const _resetPasswordPath = '/Account/Reset-Password';
  static const _registerPath = '/Account/Register';
  static const _checkEmailPath = '/Account/check-email';

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

  Future<bool> isEmailTaken(String email) async {
    final response = await _dio.get(
      _checkEmailPath,
      queryParameters: {'email': email},
    );
    return response.data['exists'] as bool;
  }

  Future<void> register(RegisterParams p) async {
    final isDoctor = p.role == 'Doctor';

    final formData = FormData.fromMap({
      'FirstName': p.firstName,
      'LastName': p.lastName,
      'Email': p.email,
      'PhoneNumber': p.phone ?? '',
      'Password': p.password,
      'ConfirmPassword': p.confirmPassword,
      'Gender': p.gender,
      'Role': p.role,
      'DateOfBirth': p.dateOfBirth.toIso8601String().split('T')[0],
      'IsHealthAndCare': p.isHealthAndCare,
      'IsNutritionAndFood': p.isNutritionAndFood,
      'IsTrainingAndBehavior': p.isTrainingAndBehavior,
      'IsGroomingAndAppearances': p.isGroomingAndAppearances,
      'IsStoriesAndExperiences': p.isStoriesAndExperiences,
      'IsTravelAndTransport': p.isTravelAndTransport,
      'IsAdoptionAndRescue': p.isAdoptionAndRescue,
      'IsUpbringingAndParenting': p.isUpbringingAndParenting,
      if (isDoctor && p.specialization != null)
        'Specialization': p.specialization,
      if (isDoctor && p.subSpecialization != null)
        'SupSpecialization': p.subSpecialization,
    });

    final files = {
      'FrontNationalID': (p.frontId, 'front.jpg'),
      'BackNationalID': (p.backId, 'back.jpg'),
      'UnionMembershipCard': (p.unionCard, 'union.jpg'),
    };
    for (final entry in files.entries) {
      final (file, name) = entry.value;
      if (file == null) continue;
      formData.files.add(
        MapEntry(
          entry.key,
          await MultipartFile.fromFile(file.path, filename: name),
        ),
      );
    }

    final response = await _dio.post(_registerPath, data: formData);

    // The server can answer 200 with isSuccess: false.
    final body = response.data;
    if (body is Map && body['isSuccess'] == false) {
      throw BadRequestFailure(body['message']?.toString());
    }
  }
}
