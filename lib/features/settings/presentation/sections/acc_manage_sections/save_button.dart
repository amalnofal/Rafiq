import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class SaveButton extends StatelessWidget {
  // ✅ استبدلنا nameController بالكنترولرز المنفصلة
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  const SaveButton({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return CustomButton(
      title: AppLocalizations.of(context)!.save_changes,
      fontWeight: FontWeight.w500,
      onpressed: () {
        // 1. التحقق من الحقول الإجبارية (الاسم الأول والأخير)
        if (firstNameController.text.trim().isEmpty || 
            lastNameController.text.trim().isEmpty) {
          showSnackBar(
            context,
            "الاسم الأول والأخير مطلوبان", // يفضل إضافة ترجمة هنا
            isError: true,
          );
          return;
        }

        // 2. تحديث البيانات (مباشرة بدون دمج)
        userProvider.updateUserProfile(
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          email: emailController.text.trim(),
          // معالجة الهاتف الاختياري: لو فاضي ابعت null
          phone: phoneController.text.trim().isEmpty 
              ? null 
              : phoneController.text.trim(),
        );

        showSnackBar(
          context,
          AppLocalizations.of(context)!.changes_saved,
          isError: false,
        );
      },
    );
  }
}