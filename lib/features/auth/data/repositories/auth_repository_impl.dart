import 'package:dio/dio.dart';
import 'package:rafiq/core/network/dio_client.dart';
import 'package:rafiq/core/storage/token_storage.dart';
import 'package:rafiq/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:rafiq/features/auth/domain/entities/register_params.dart';
import 'package:rafiq/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote, this._tokenStorage);

  final AuthRemoteDataSource _remote;
  final TokenStorage _tokenStorage;

  @override
  Future<void> login({required String email, required String password}) {
    return _guard(() async {
      final tokens = await _remote.login(email: email, password: password);
      await _tokenStorage.save(
        access: tokens.accessToken,
        refresh: tokens.refreshToken,
      );
    });
  }

  @override
  Future<void> sendResetCode({required String email}) =>
      _guard(() => _remote.sendResetCode(email: email));

  @override
  Future<void> verifyOtp({required String email, required String otp}) =>
      _guard(() => _remote.verifyOtp(email: email, otp: otp));

  @override
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) => _guard(
    () =>
        _remote.resetPassword(email: email, otp: otp, newPassword: newPassword),
  );

  /// Runs [call] and converts any DioException to a Failure.
  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw e.toFailure();
    }
  }

  @override
  Future<bool> isEmailTaken(String email) =>
      _guard(() => _remote.isEmailTaken(email));

  @override
  Future<void> register(RegisterParams params) =>
      _guard(() => _remote.register(params));

  @override
  Future<void> logout() async {
    final refresh = _tokenStorage.refreshToken;
    if (refresh == null || refresh.isEmpty) return;
    try {
      await _remote.revokeToken(refresh).timeout(const Duration(seconds: 5));
    } catch (_) {} // best effort
  }
}
