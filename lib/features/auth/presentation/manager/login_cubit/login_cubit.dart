import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rafiq/core/services/auth_service.dart';
import 'package:rafiq/core/helper/cache_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthService _authService;

  LoginCubit(this._authService) : super(LoginInitial());

  void userLogin({required String email, required String password}) async {
    emit(LoginLoading());

    try {
      final authModel = await _authService.login(
        email: email,
        password: password,
      );

      // log("🎉 Login Success!");
      // log("🔑 Access Token: ${authModel.accessToken}");
      // log("🔄 Refresh Token: ${authModel.refreshToken}");

      await CacheHelper.saveData(
        key: 'accessToken',
        value: authModel.accessToken,
      );
      await CacheHelper.saveData(
        key: 'refreshToken',
        value: authModel.refreshToken,
      );
      await CacheHelper.saveData(key: 'userEmail', value: email);

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userData');

      emit(LoginSuccess());
    } on DioException catch (e) {
      // القيمة الافتراضية لأي خطأ مش متوقع (مشكلة سيرفر 500 مثلاً)
      String errorKey = "unexpectedError";

      if (e.response != null) {
        final statusCode = e.response!.statusCode;

        // 1️⃣ دمجنا 400 و 401 عشان نقول "البيانات غلط" في الحالتين
        if (statusCode == 400 || statusCode == 401) {
          errorKey = "wrongCredentials";
        }
        // 2️⃣ لو السيرفر قال الحساب مش موجود صراحة
        else if (statusCode == 404) {
          errorKey = "userNotFound";
        }
        // أي كود تاني (زي 500) هيفضل unexpectedError زي ما هو
      }

      log("❌ Login Error Key: $errorKey");
      emit(LoginFailure(errMessage: errorKey));
    } catch (e) {
      log("❌ General Error: $e");
      emit(LoginFailure(errMessage: "unexpectedError"));
    }
  }
}
