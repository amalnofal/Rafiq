import 'package:dio/dio.dart';
import 'package:rafiq/features/auth/data/models/auth_response_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);

  final Dio _dio;

  static const _loginPath = '/Account/Login';

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
}
