import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/validation_helper.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';
import 'package:rafiq/features/auth/presentation/widgets/auth_buttons/apple_button.dart';
import 'package:rafiq/features/auth/presentation/widgets/auth_buttons/google_button.dart';
import 'package:rafiq/features/auth/presentation/widgets/next_button.dart';
import 'package:rafiq/features/auth/presentation/widgets/or_divider.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class Step1Name extends StatefulWidget {
  final TextEditingController fNameController;
  final TextEditingController lNameController;
  final VoidCallback onNext;
  final VoidCallback onSocialLogin;

  const Step1Name({
    super.key,
    required this.fNameController,
    required this.lNameController,
    required this.onNext,
    required this.onSocialLogin,
  });

  @override
  State<Step1Name> createState() => _Step1NameState();
}

class _Step1NameState extends State<Step1Name> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _validateAndNext() {
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: widget.fNameController,
              labelText: AppLocalizations.of(context)!.firstName,
              prefixIcon: "assets/icons/user_icon.svg",
              validator: (val) => ValidationHelper.validateName(val, context),
            ),

            CustomTextField(
              controller: widget.lNameController,
              labelText: AppLocalizations.of(context)!.lastName,
              prefixIcon: "assets/icons/user_icon.svg",
              validator: (val) => ValidationHelper.validateName(val, context),
            ),

            NextButton(onNext: _validateAndNext),

            OrDivider(),

            GoogleButton(
              title: AppLocalizations.of(context)!.signUpWithGoogle,
              onPressed: widget.onSocialLogin,
            ),

            SizedBox(height: AppDimensions.paddingM),

            AppleButton(
              title: AppLocalizations.of(context)!.signUpWithApple,
              onPressed: widget.onSocialLogin,
            ),
          ],
        ),
      ),
    );
  }
}
