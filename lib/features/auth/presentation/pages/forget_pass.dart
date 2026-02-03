import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/features/auth/presentation/pages/verification_screen.dart';
import 'package:rafiq/features/auth/presentation/widgets/auth_layout.dart';
import 'package:rafiq/features/auth/presentation/widgets/email_field.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({super.key});

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {});
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationScreen(email: email),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: AppLocalizations.of(context)!.recoverPassword,
      subtitle: AppLocalizations.of(context)!.enterEmailSubtitle,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            EmailField(
              controller: _emailController,
              onChanged: (_) => setState(() {}),
              onFieldSubmitted: (_) => _submit(),
            ),
            SizedBox(height: 20.h),
            CustomButton(
              title: AppLocalizations.of(context)!.sendCode,
              onpressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
