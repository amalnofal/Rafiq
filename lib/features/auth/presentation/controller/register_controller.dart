import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:rafiq/core/enums/post_category.dart';
import 'package:rafiq/features/auth/domain/entities/register_params.dart';

class RegisterController extends ChangeNotifier {
  final PageController pageController = PageController();

  int currentPage = 0;

  int? gender;
  String? accountType; // "Doctor" or "PetOwner"

  File? frontIdImage;
  File? backIdImage;
  File? unionCardImage;

  void setVetImages({File? front, File? back, File? union, File? profile}) {
    if (front != null) frontIdImage = front;
    if (back != null) backIdImage = back;
    if (union != null) unionCardImage = union;
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

  /// Builds the register request from the form and the chosen interests.
  RegisterParams toParams(List<int> interests) {
    bool has(PostCategory c) => interests.contains(c.id);
    final isDoctor = accountType == 'Doctor';

    return RegisterParams(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      password: passController.text,
      confirmPassword: confirmPassController.text,
      gender: gender!,
      role: accountType!,
      dateOfBirth: DateFormat('dd/MM/yyyy').parse(dobController.text),
      isHealthAndCare: has(PostCategory.health),
      isNutritionAndFood: has(PostCategory.food),
      isTrainingAndBehavior: has(PostCategory.training),
      isGroomingAndAppearances: has(PostCategory.grooming),
      isStoriesAndExperiences: has(PostCategory.stories),
      isTravelAndTransport: has(PostCategory.travel),
      isAdoptionAndRescue: has(PostCategory.adoption),
      isUpbringingAndParenting: has(PostCategory.activities),
      specialization: isDoctor ? specController.text.trim() : null,
      subSpecialization: isDoctor ? subSpecController.text.trim() : null,
      frontId: isDoctor ? frontIdImage : null,
      backId: isDoctor ? backIdImage : null,
      unionCard: isDoctor ? unionCardImage : null,
    );
  }
}
