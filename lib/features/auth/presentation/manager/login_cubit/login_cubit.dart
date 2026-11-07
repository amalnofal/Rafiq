import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rafiq/core/services/auth_service.dart';
import 'package:rafiq/core/helper/cache_helper.dart';
import 'package:rafiq/core/storage/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthService _authService;
  final TokenStorage _tokenStorage;

  LoginCubit(this._authService, this._tokenStorage) : super(LoginInitial());

  void userLogin({required String email, required String password}) async {
    emit(LoginLoading());

    try {
      final authModel = await _authService.login(
        email: email,
        password: password,
      );

      await _tokenStorage.save(
        access: authModel.accessToken,
        refresh: authModel.refreshToken,
      );
      await CacheHelper.saveData(key: 'userEmail', value: email);

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userData');

      emit(LoginSuccess());
    } on DioException catch (e) {
      String errorKey = "unexpectedError";

      if (e.response != null) {
        final statusCode = e.response!.statusCode;

        if (statusCode == 400 || statusCode == 401) {
          errorKey = "wrongCredentials";
        } else if (statusCode == 404) {
          errorKey = "userNotFound";
        }
      }

      log("❌ Login Error Key: $errorKey");
      emit(LoginFailure(errMessage: errorKey));
    } catch (e) {
      log("❌ General Error: $e");
      emit(LoginFailure(errMessage: "unexpectedError"));
    }
  }
}
