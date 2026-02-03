import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/validation_helper.dart';
import 'package:rafiq/features/auth/presentation/widgets/password_field.dart';
import 'package:rafiq/features/auth/presentation/widgets/next_button.dart';
import 'package:rafiq/features/settings/presentation/Widgets/password_rules.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class Step4Password extends StatefulWidget {
  final TextEditingController passController;
  final TextEditingController confirmController;
  final VoidCallback onNext;

  const Step4Password({
    super.key,
    required this.passController,
    required this.confirmController,
    required this.onNext,
  });

  @override
  State<Step4Password> createState() => _Step4PasswordState();
}

class _Step4PasswordState extends State<Step4Password> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _validateAndProceed() {
    if (_formKey.currentState!.validate()) {
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            PasswordField(
              controller: widget.passController,
              labelText: AppLocalizations.of(context)!.password,
              textInputAction: TextInputAction.next,
              validator: (val) =>
                  ValidationHelper.validateStrongPassword(val, context),
            ),
            PasswordField(
              controller: widget.confirmController,
              labelText: AppLocalizations.of(context)!.confirmPassword,
              textInputAction: TextInputAction.done,
              validator: (val) => ValidationHelper.validateMatch(
                val,
                widget.passController.text,
                context,
              ),
            ),
            SizedBox(height: AppDimensions.paddingM),
            PasswordRules(),
            NextButton(onNext: _validateAndProceed),
          ],
        ),
      ),
    );
  }
}
