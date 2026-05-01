import 'dart:io';

import 'package:flutter/material.dart';

class RegisterController extends ChangeNotifier {
  final PageController pageController = PageController();

  int currentPage = 0;
  bool isSocialLogin = false;

  int? gender;
  String? accountType; // "Doctor" or "PetOwner"

  File? frontIdImage;
  File? backIdImage;
  File? unionCardImage;
  File? profileImage;

  void setVetImages({File? front, File? back, File? union, File? profile}) {
    if (front != null) frontIdImage = front;
    if (back != null) backIdImage = back;
    if (union != null) unionCardImage = union;
    if (profile != null) profileImage = profile;
    notifyListeners();
  }

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController =
      TextEditingController(); // YYYY-MM-DD
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  // داتا الدكتور
  final TextEditingController specController = TextEditingController();
  final TextEditingController subSpecController = TextEditingController();

  @override
  void dispose() {
    pageController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dobController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    specController.dispose();
    subSpecController.dispose();
    super.dispose();
  }

  // ==========================
  // دوال الـ UI (التنقل) فقط
  // ==========================
  void nextPage() {
    if (currentPage < 4) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void prevPage(BuildContext context) {
    if (currentPage == 0) {
      Navigator.pop(context);
      return;
    }
    if (currentPage == 4 && isSocialLogin) {
      pageController.jumpToPage(0);
      updatePage(0);
      isSocialLogin = false;
      return;
    }
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void updatePage(int index) {
    currentPage = index;
    notifyListeners();
  }

  void setAccountType(String type) {
    accountType = type;
    notifyListeners();
  }

  void setGender(int val) {
    gender = val;
    notifyListeners();
  }
}
