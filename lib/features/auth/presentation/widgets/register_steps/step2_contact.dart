import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/helper/validation_helper.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';
import 'package:rafiq/features/auth/presentation/widgets/email_field.dart';
import 'package:rafiq/features/auth/presentation/widgets/next_button.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class Step2Contact extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final VoidCallback onNext;
  final bool isSocialLogin;

  const Step2Contact({
    super.key,
    required this.emailController,
    required this.phoneController,
    required this.onNext,
    this.isSocialLogin = false,
  });

  @override
  State<Step2Contact> createState() => _Step2ContactState();
}

class _Step2ContactState extends State<Step2Contact> {
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
            EmailField(
              controller: widget.emailController,
              readOnly: widget.isSocialLogin,
            ),

            CustomTextField(
              controller: widget.phoneController,
              labelText:
                  "${AppLocalizations.of(context)!.phone_number} ${AppLocalizations.of(context)!.optional}",
              prefixIcon: "assets/icons/phone.svg",
              keyboardType: TextInputType.phone,
              validator: (val) => ValidationHelper.validatePhone(
                val,
                context,
                isOptional: true,
              ),
            ),
            NextButton(onNext: _validateAndProceed),
          ],
        ),
      ),
    );
  }
}
