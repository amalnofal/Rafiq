import 'package:flutter/material.dart';
import 'package:rafiq/core/models/user_info.dart';

class UserProvider extends ChangeNotifier {
  final UserInfo _user;

  UserProvider({required UserInfo user}) : _user = user;

  // Getter علشان نقدر نقرأ بيانات المستخدم
  UserInfo get user => _user;

  // Methods لتحديث القيم داخل الـ UserInfo نفسه
  void updateName(String newName) {
    _user.name = newName;
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    _user.email = newEmail;
    notifyListeners();
  }

  void updatePhone(String newPhone) {
    _user.phone = newPhone;
    notifyListeners();
  }
}
