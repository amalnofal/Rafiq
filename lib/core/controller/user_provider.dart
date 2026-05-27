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
import 'package:rafiq/core/services/auth_service.dart';
import 'package:rafiq/core/services/user_service.dart';
import 'package:rafiq/features/community/presentation/widgets/post_video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rafiq/features/community/data/models/post_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  bool _hasError = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  bool get isAuth => _user != null;

  final Map<String, bool> _followCache = {};
  final Map<String, int> _followersCountCache = {};

  bool? getFollowState(String userId) => _followCache[userId];
  int? getFollowersCount(String userId) => _followersCountCache[userId];

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

      log("👤 ريسبونس بروفايلي الشخصي: ${response.data}");

      final dynamic rawData = response.data['data'] ?? response.data;

      _user = UserModel.fromJson(rawData);
      await _saveDataToPrefs();

      getIt<PetProvider>().setPetsFromProfile(rawData);
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

  Future<void> setUser(UserModel user) async {
    _user = user;
    notifyListeners();
    await _saveDataToPrefs();
  }

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
    await prefs.remove('userData');

    VideoCacheManager.clearAllCache();

    notifyListeners();
    log("[UserProvider]: تم تسجيل الخروج ومسح بيانات المستخدم بنجاح.");
  }

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
          if (statusCode == 400) throw Exception("imageUpdateFailed");
          if (statusCode == 401) throw Exception("sessionExpired");
          if (statusCode! >= 500) throw Exception("serverError");
        }
      }
      throw Exception("unexpectedError");
    }
  }

  void updateLocalProfileImage(File file) {
    _localProfileImage = file;
    notifyListeners();
  }

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

  void addPostLocally(PostModel newPost) {
    if (_user != null) {
      final currentPosts = _user!.posts ?? [];
      _user = _user!.copyWith(
        posts: [newPost, ...currentPosts],
        postsCount: _user!.postsCount + 1,
      );
      notifyListeners();
    }
  }

  void removePostLocally(String postId) {
    if (_user?.posts != null) {
      final updatedPosts = List<PostModel>.from(_user!.posts!);

      updatedPosts.removeWhere((p) => p.id == postId);

      _user = _user!.copyWith(
        posts: updatedPosts,
        postsCount: (_user!.postsCount - 1) < 0 ? 0 : (_user!.postsCount - 1),
      );

      notifyListeners();
    }
  }

  void updatePostLocally(PostModel updatedPost) {
    if (_user?.posts != null) {
      final index = _user!.posts!.indexWhere((p) => p.id == updatedPost.id);
      if (index != -1) {
        final updatedPosts = List<PostModel>.from(_user!.posts!);
        updatedPosts[index] = updatedPost;
        _user = _user!.copyWith(posts: updatedPosts);
        notifyListeners();
      }
    }
  }

  // ==========================================================
  // جلب بيانات أي مستخدم آخر عن طريق الـ ID وتحديث الكاش
  // ==========================================================
  Future<UserModel?> fetchUserProfileById(String userId) async {
    try {
      final userService = getIt<UserService>();
      final response = await userService.getUserProfileById(userId);

      log("🔥 داتا بروفايل المستخدم ($userId): ${response.data}");

      final dynamic rawData = response.data['data'] ?? response.data;
      final fetchedUser = UserModel.fromJson(rawData);

      if (rawData.containsKey('isFollowing') ||
          rawData.containsKey('IsFollowing')) {
        _followCache[userId] = fetchedUser.isFollowing;
      } else {
        _followCache.putIfAbsent(userId, () => fetchedUser.isFollowing);
      }

      if (rawData.containsKey('numberOfFollowers') ||
          rawData.containsKey('followersCount') ||
          rawData.containsKey('FollowersCount')) {
        _followersCountCache[userId] = fetchedUser.followersCount;
      } else {
        _followersCountCache.putIfAbsent(
          userId,
          () => fetchedUser.followersCount,
        );
      }

      return fetchedUser;
    } catch (e) {
      log("❌ [UserProvider]: فشل جلب بيانات المستخدم بالـ ID: $e");
      return null;
    }
  }

  // ==========================================================
  // 🚀 متابعة / إلغاء متابعة مستخدم مع تحديث الكاش
  // ==========================================================
  Future<bool> toggleFollow(
    String userId,
    bool isCurrentlyFollowing,
    int currentFollowers,
  ) async {
    try {
      final userService = getIt<UserService>();
      if (isCurrentlyFollowing) {
        await userService.unfollowUser(userId);

        // تحديث الكاش فوراً بالإلغاء
        _followCache[userId] = false;
        _followersCountCache[userId] = (currentFollowers - 1).clamp(0, 999999);
      } else {
        await userService.followUser(userId);

        // تحديث الكاش فوراً بالمتابعة
        _followCache[userId] = true;
        _followersCountCache[userId] = currentFollowers + 1;
      }
      notifyListeners();
      return true;
    } catch (e) {
      log("❌ [UserProvider]: فشل تعديل المتابعة: $e");
      return false;
    }
  }

  // ==========================================================
  // 🚀 البحث عن مستخدمين بالاسم
  // ==========================================================
  Future<List<UserModel>> searchUsers(
    String query, {
    int pageNumber = 1,
  }) async {
    try {
      final userService = getIt<UserService>();
      final response = await userService.searchUsers(
        query,
        pageNumber: pageNumber,
      );

      log("🔍 ريسبونس السيرش بالكامل: ${response.data}");

      final List data = response.data['data'] ?? [];
      return data.map((e) => UserModel.fromJson(e)).toList();
    } catch (e) {
      log("❌ [UserProvider]: فشل البحث عن مستخدمين: $e");
      throw Exception('ConnectionError');
    }
  }

  // حذف الاكونت
  Future<void> deleteAccount(String password) async {
    try {
      final authService = getIt<AuthService>();
      await authService.deleteAccount(password: password);

      await logout();
    } catch (e) {
      log("❌ [UserProvider]: فشل حذف الحساب: $e");

      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          throw Exception("connectionError");
        }

        if (e.response != null) {
          final statusCode = e.response!.statusCode;

          if (statusCode == 400 || statusCode == 401) {
            throw Exception("wrongPassword");
          }

          if (statusCode! >= 500) {
            throw Exception("serverError");
          }
        }
      }

      throw Exception("unexpectedError");
    }
  }
}
