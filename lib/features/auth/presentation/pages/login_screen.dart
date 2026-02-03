import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';
import 'package:rafiq/features/auth/presentation/widgets/auth_layout.dart';
import 'package:rafiq/features/auth/presentation/widgets/email_field.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateState);
    _passwordController.addListener(_updateState);
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // دالة تسجيل الدخول (اللوجيك)
  void _login() {
    if (!_formKey.currentState!.validate()) return;

    // أ) تجهيز البيانات للإرسال (.NET Login DTO)
    final Map<String, dynamic> loginBody = {
      "email": _emailController.text.trim(),
      "password": _passwordController.text,
    };

    // طباعة للتجربة
    log("Sending to .NET API: $loginBody");

    // ب) سيناريو استقبال الرد (محاكاة لما سيحدث لاحقاً)
    /*
    final response = await http.post(...);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      // 1. استخراج التوكن (مهم جداً في .NET)
      String token = data['token']; 
      // SecureStorage.write(key: 'token', value: token);

      // 2. تحويل بيانات المستخدم للمودل بتاعنا
      if (data['user'] != null) {
         UserModel currentUser = UserModel.fromJson(data['user']);
         print("Welcome back ${currentUser.name}");
      }
    }
    */

    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: AppLocalizations.of(context)!.login,
      subtitle: AppLocalizations.of(context)!.welcomeBack,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            EmailField(
              controller: _emailController,
              onChanged: (_) => setState(() {}),
            ),

            CustomTextField(
              labelText: AppLocalizations.of(context)!.password,
              keyboardType: TextInputType.visiblePassword,
              prefixIcon: "assets/icons/security.svg",
              isPassword: true,
              controller: _passwordController,
            ),
            SizedBox(height: AppDimensions.paddingM),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/forget_pass');
              },
              child: Text(
                AppLocalizations.of(context)!.forgotPassword,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.end,
              ),
            ),
            SizedBox(height: AppDimensions.paddingL),

            CustomButton(
              title: AppLocalizations.of(context)!.login,
              onpressed: _login,
            ),
          ],
        ),
      ),
    );
  }
}
