import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/validation_helper.dart'; // 1. استدعاء Helper
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/features/auth/presentation/pages/login_screen.dart';
import 'package:rafiq/features/auth/presentation/widgets/auth_layout.dart';
import 'package:rafiq/features/auth/presentation/widgets/password_field.dart';
import 'package:rafiq/features/settings/presentation/Widgets/password_rules.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  // دالة الحفظ
  void _submit() async {
    if (_formKey.currentState!.validate()) {
      // 1. هنا كود الـ API
      // await authProvider.resetPassword(...);

      log("تم تغيير كلمة المرور والدخول بنجاح");

      // 2. التوجيه للـ Home
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      // زرار الرجوع
      onBackTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => route.isFirst,
        );
      },

      title: AppLocalizations.of(context)!.newPassword,
      subtitle: AppLocalizations.of(context)!.chooseStrongPassword,

      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // --- 1. كلمة المرور الجديدة ---
            PasswordField(
              controller: _passController,
              labelText: AppLocalizations.of(context)!.newPassword,
              textInputAction: TextInputAction.next,
              validator: (val) =>
                  ValidationHelper.validateStrongPassword(val, context),
            ),

            SizedBox(height: 16.h),
            // --- 2. تأكيد كلمة المرور ---
            PasswordField(
              controller: _confirmPassController,
              labelText: AppLocalizations.of(context)!.confirmPassword,
              validator: (val) => ValidationHelper.validateMatch(
                val,
                _passController.text,
                context,
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: AppDimensions.padding),
              child: const PasswordRules(),
            ),

            CustomButton(
              title: AppLocalizations.of(context)!.changePassword,
              onpressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
