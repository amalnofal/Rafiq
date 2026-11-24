import 'package:rafiq/features/auth/domain/entities/register_params.dart';

abstract class AuthRepository {
  /// Logs in and stores the session tokens. Throws a [Failure] on error.
  Future<void> login({required String email, required String password});

  /// Sends the reset code to [email]. Throws a [Failure] on error.
  Future<void> sendResetCode({required String email});

  Future<void> verifyOtp({required String email, required String otp});

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });

  /// Returns true when [email] is already registered.
  Future<bool> isEmailTaken(String email);

  /// Creates an account. Throws a [Failure] on error.
  Future<void> register(RegisterParams params);

  /// Revokes the refresh token on the server. Never throws.
  Future<void> logout();
}
