import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rafiq/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = true;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  String get userDisplayName {
    if (_user == null) {
      return "مستخدم رفيق";
    }
    return _user!.fullName;
  }

  // دالة التحميل (المعدلة للتجربة)
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    // await prefs.clear();

    if (prefs.containsKey('userData')) {
      // لو فيه بيانات قديمة محفوظة، حملها
      final extractedUserData =
          json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
      _user = UserModel.fromJson(extractedUserData);
    } else {
      _user = UserModel(
        id: '1',
        firstName: 'Tech',
        lastName: 'Titans',
        email: 'user@example.com',
        phone: '01000000000',
        userType: 'pet owner',
        joinedAt: DateTime.now(),
        photoUrl: null,
      );
      _saveDataToPrefs();
    }

    _isLoading = false;
    notifyListeners();
  }

  void updateUserProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
  }) {
    if (_user == null) return;

    _user = _user!.copyWith(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
    );

    notifyListeners();
    _saveDataToPrefs();
  }

  // دالة الحفظ في SharedPreferences
  Future<void> _saveDataToPrefs() async {
    if (_user == null) return;
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(
      _user!.toJson(),
    ); // بنحفظ اليوزر بس بدون توكن حالياً
    await prefs.setString('userData', userData);
  }
}
