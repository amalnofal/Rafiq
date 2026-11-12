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
}
