abstract class AuthRepository {
  /// Logs in and stores the session tokens. Throws a [Failure] on error.
  Future<void> login({required String email, required String password});
}