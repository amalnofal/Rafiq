import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rafiq/features/auth/presentation/pages/interests_screen.dart';
import 'package:rafiq/features/auth/presentation/pages/vet_verification.dart';

class RegisterController extends ChangeNotifier {
  final PageController pageController = PageController();

  int currentPage = 0;
  bool isSocialLogin = false;
  String? gender;
  String? accountType;
  List<String> selectedInterests = [];

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
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

  void nextPage() {
    if (currentPage == 2 && isSocialLogin) {
      pageController.jumpToPage(4);
    } else if (currentPage < 5) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void prevPage(BuildContext context) {
    if (currentPage == 4 && isSocialLogin) {
      pageController.jumpToPage(2);
    } else if (currentPage == 2 && isSocialLogin) {
      isSocialLogin = false;
      notifyListeners();

      pageController.jumpToPage(1);
    } else if (currentPage > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void updatePage(int index) {
    currentPage = index;
    notifyListeners();
  }

  void setAccountType(String type) {
    accountType = type;
    notifyListeners();
  }

  void setGender(String val) {
    gender = val;
    notifyListeners();
  }

  Future<void> registerUser(BuildContext context) async {
    Map<String, dynamic> requestData = {
      "firstName": firstNameController.text,
      "lastName": lastNameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "password": passController.text,
      "gender": gender,
      "userType": accountType,
      "dateOfBirth": dobController.text,
      "isSocial": isSocialLogin,
    };

    log("🚀 1. Registering Basic User: $requestData");

    try {
      // Call API (Register Endpoint) here
      // await authRepo.register(requestData);

      // بفرض إن التسجيل نجح، هنوجه المستخدم دلوقتي
      if (accountType == "vet") {
        // لو دكتور -> روح لصفحة رفع المستندات
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => VetVerification(controller: this)),
        );
      } else {
        // لو مربي -> روح لصفحة الاهتمامات
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => InterestsScreen(controller: this)),
        );
      }
    } catch (e) {
      // Show Error
      log("Error registering: $e");
    }
  }

  // دالة استكمال بيانات الدكتور
  Future<void> uploadVetDocuments({
    required File idFront,
    required File idBack,
    required File license,
  }) async {
    Map<String, dynamic> vetData = {
      "specialization": specController.text,
      "subSpecialization": subSpecController.text,
      "idFront": idFront.path,
      "idBack": idBack.path,
      "license": license.path,
    };

    log("🚀 2. Uploading Vet Docs: $vetData");
    // Call API (Upload Docs)
    // وبعد النجاح: Navigator.pushReplacementNamed(context, '/home');
  }

  // 4. دالة حفظ الاهتمامات
  Future<void> saveInterests(List<String> interests) async {
    selectedInterests = interests;
    log("🚀 3. Saving Interests: $interests");
    // Call API (Save Interests)
    // وبعد النجاح: Navigator.pushReplacementNamed(context, '/home');
  }
}
