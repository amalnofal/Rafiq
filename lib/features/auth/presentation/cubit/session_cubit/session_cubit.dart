import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
part 'session_state.dart';

/// Tells the app when the server has rejected the user's session.
class SessionCubit extends Cubit<SessionState> {
  SessionCubit({required Future<void> Function() clearSession})
    : _clearSession = clearSession,
      super(SessionActive());

  final Future<void> Function() _clearSession;

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
}
