import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rafiq/core/error/failure.dart';
import 'package:rafiq/core/helper/cache_helper.dart';
import 'package:rafiq/features/auth/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(LoginInitial());

  void userLogin({required String email, required String password}) async {
    emit(LoginLoading());

    try {
      await _authRepository.login(email: email, password: password);

      // TODO: leftovers, move or delete in the SessionCubit step.
      await CacheHelper.saveData(key: 'userEmail', value: email);
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userData');

      emit(LoginSuccess());
    } on Failure catch (f) {
      emit(LoginFailure(errMessage: _errorKey(f)));
    } catch (e) {
      log("❌ General Error: $e");
      emit(LoginFailure(errMessage: "unexpectedError"));
    }
  }

  String _errorKey(Failure f) => switch (f) {
    BadRequestFailure() || UnauthorizedFailure() => 'wrongCredentials',
    NotFoundFailure() => 'userNotFound',
    NetworkFailure() => 'connectionError',
    _ => 'unexpectedError',
  };
}
