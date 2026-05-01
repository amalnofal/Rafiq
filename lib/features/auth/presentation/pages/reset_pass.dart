import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/validation_helper.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/loading_overlay.dart';
import 'package:rafiq/features/auth/presentation/manager/forget_password_cubit/forget_password_cubit.dart';
import 'package:rafiq/features/auth/presentation/pages/login_screen.dart';
import 'package:rafiq/features/auth/presentation/widgets/auth_layout.dart';
import 'package:rafiq/features/auth/presentation/widgets/password_field.dart';
import 'package:rafiq/features/settings/presentation/Widgets/password_rules.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

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
  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // 👇 استدعاء دالة تغيير الباسورد من الكيوبت
      context.read<ForgetPasswordCubit>().resetNewPassword(
        email: widget.email,
        otp: widget.otp,
        newPassword: _passController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          // ✅ 1. نجاح: رسالة ورجوع لشاشة اللوجين
          log("تم تغيير كلمة المرور بنجاح");

          showSnackBar(
            context,
            AppLocalizations.of(context)!.passwordResetSuccess,
            isError: false,
          );

          // مسح الستاك والعودة لشاشة الدخول
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        } else if (state is ForgetPasswordFailure) {
          // ❌ 2. فشل: عرض رسالة خطأ
          String getLocalizedMessage(String key) {
            final lang = AppLocalizations.of(context)!;
            // ممكن تضيفي حالات تانية حسب الحاجة
            if (key == 'connectionError') return lang.connectionError;
            return lang.unexpectedError;
          }

          showSnackBar(
            context,
            getLocalizedMessage(state.errMessage),
            isError: true,
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            // واجهة المستخدم الأصلية
            AuthLayout(
              showBackButton: false,
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
                      padding: EdgeInsets.symmetric(
                        vertical: AppDimensions.padding,
                      ),
                      child: const PasswordRules(),
                    ),

                    CustomButton(
                      title: AppLocalizations.of(context)!.changePassword,
                      onPressed: () => _submit(context),
                    ),
                  ],
                ),
              ),
            ),

            // Loading Overlay
            if (state is ForgetPasswordLoading) const LoadingOverlay(),
          ],
        );
      },
    );
  }
}
