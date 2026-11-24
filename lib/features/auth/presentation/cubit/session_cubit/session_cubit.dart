import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rafiq/features/auth/domain/repositories/auth_repository.dart';
part 'session_state.dart';

/// Tells the app when the server has rejected the user's session.
class SessionCubit extends Cubit<SessionState> {
  SessionCubit({
    required Future<void> Function() clearSession,
    required AuthRepository authRepository,
  }) : _authRepository = authRepository,
       _clearSession = clearSession,

       super(SessionActive());

  final Future<void> Function() _clearSession;
  final AuthRepository _authRepository;

  // Set before any await, so parallel 401s open only one dialog.
  bool _expiring = false;

  /// Called by the network layer when the refresh token is rejected.
  Future<void> expire() async {
    if (_expiring) return;
    _expiring = true;
    await _clearSession();
    emit(SessionExpired());
  }

  /// Called when the user leaves the expired-session dialog.
  void reset() {
    _expiring = false;
    emit(SessionActive());
  }

  Future<void> logout() async {
    await _authRepository.logout();
    await _clearSession();
  }
}
