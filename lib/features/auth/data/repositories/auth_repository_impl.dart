import 'package:dio/dio.dart';
import 'package:rafiq/core/network/dio_client.dart';
import 'package:rafiq/core/storage/token_storage.dart';
import 'package:rafiq/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:rafiq/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote, this._tokenStorage);

  final AuthRemoteDataSource _remote;
  final TokenStorage _tokenStorage;

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final tokens = await _remote.login(email: email, password: password);
      await _tokenStorage.save(
        access: tokens.accessToken,
        refresh: tokens.refreshToken,
      );
    } on DioException catch (e) {
      throw e.toFailure();
    }
  }
}