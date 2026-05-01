import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rafiq/core/controller/clinic_provider.dart';
import 'package:rafiq/core/controller/pet_provider.dart';
import 'package:rafiq/core/di/service_locator.dart';
import 'package:rafiq/core/helper/cache_helper.dart';
import 'package:rafiq/core/models/user_model.dart';
import 'package:rafiq/core/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  bool _hasError = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  bool get isAuth => _user != null;

  File? _localProfileImage;
  File? get localProfileImage => _localProfileImage;
  File? _localCoverImage;
  File? get localCoverImage => _localCoverImage;

  UserProvider() {
    loadDataFromCache();
  }

  Future<void> loadDataFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('userData');

      if (userDataString != null) {
        final Map<String, dynamic> extractedData = json.decode(userDataString);
        _user = UserModel.fromJson(extractedData);
        notifyListeners();
        log("[UserProvider]: تم تحميل البيانات من الكاش بنجاح.");
      }
    } catch (e) {
      log("[UserProvider]: خطأ في قراءة الكاش: $e");
    }
  }

  Future<void> loadUserData() async {
    if (_user == null) {
      _isLoading = true;
      notifyListeners();
    }

    _hasError = false;

    _localProfileImage = null;
    _localCoverImage = null;

    try {
      final userService = getIt<UserService>();
      final response = await userService.getMyProfile();

      final dynamic rawData = response.data['data'] ?? response.data;

      // تحديث بيانات المستخدم
      _user = UserModel.fromJson(rawData);
      await _saveDataToPrefs();

      // تحديث بيانات الحيوانات الأليفة
      getIt<PetProvider>().setPetsFromProfile(rawData);
      // تحديث بيانات العيادات
      getIt<ClinicProvider>().setClinicsFromProfile(rawData);

      _hasError = false;
    } catch (e) {
      if (_user == null) {
        _hasError = true;
      }
      log("[UserProvider]: فشل التحديث من السيرفر: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==========================================================
  // حفظ بيانات المستخدم
  // ==========================================================
  Future<void> setUser(UserModel user) async {
    _user = user;
    notifyListeners();
    await _saveDataToPrefs();
  }

  // ==========================================================
  // تسجيل الخروج
  // ==========================================================
  Future<void> logout() async {
    _user = null;
    _localProfileImage = null;
    _localCoverImage = null;
    _hasError = false;

    getIt<PetProvider>().setPetsFromProfile(null);
    getIt<ClinicProvider>().setClinicsFromProfile(null);

    await CacheHelper.removeData(key: 'accessToken');
    await CacheHelper.removeData(key: 'refreshToken');
    await CacheHelper.removeData(key: 'userEmail');

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
    log("[UserProvider]: تم تسجيل الخروج ومسح الكاش بالكامل بنجاح.");
  }

  // ==========================================================
  // تحديث البيانات المحلية
  // ==========================================================
  void updateUserProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? photoUrl,
  }) {
    if (_user == null) return;

    _user = _user!.copyWith(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      photoUrl: photoUrl,
    );

    notifyListeners();
    _saveDataToPrefs();
  }

  Future<void> _saveDataToPrefs() async {
    if (_user == null) return;
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(_user!.toJson());
    await prefs.setString('userData', userData);
  }

  // ==========================================================
  // رفع وتحديث صورة الملف الشخصي
  // ==========================================================
  Future<void> uploadProfileImage(File file) async {
    try {
      updateLocalProfileImage(file);

      final userService = getIt<UserService>();
      await userService.uploadProfilePhoto(file);

      await loadUserData();
    } catch (e) {
      _localProfileImage = null;
      notifyListeners();

      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          throw Exception("connectionError");
        }

        if (e.response != null) {
          final statusCode = e.response!.statusCode;

          if (statusCode == 400) {
            throw Exception("imageUpdateFailed");
          } else if (statusCode == 401) {
            throw Exception("sessionExpired");
          } else if (statusCode! >= 500) {
            throw Exception("serverError");
          }
        }
      }
      throw Exception("unexpectedError");
    }
  }

  void updateLocalProfileImage(File file) {
    _localProfileImage = file;
    notifyListeners();
  }

  // ==========================================================
  // رفع وتحديث صورة الغلاف
  // ==========================================================
  Future<void> uploadCoverImage(File file) async {
    try {
      _localCoverImage = file;
      notifyListeners();

      final userService = getIt<UserService>();
      await userService.uploadCoverPhoto(file);
      await loadUserData();
    } catch (e) {
      _localCoverImage = null;
      notifyListeners();

      if (e is DioException) {
        if (e.response?.statusCode == 400) throw Exception("imageUpdateFailed");
        if (e.response?.statusCode == 401) throw Exception("sessionExpired");
      }
      throw Exception("unexpectedError");
    }
  }

  void updateLocalCoverImage(File file) {
    _localCoverImage = file;
    notifyListeners();
  }
}
