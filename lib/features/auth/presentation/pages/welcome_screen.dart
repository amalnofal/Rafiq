import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/features/auth/presentation/widgets/auth_buttons/apple_button.dart';
import 'package:rafiq/features/auth/presentation/widgets/auth_buttons/google_button.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: isDarkMode
          ? AppColors.kDarkMutedBackground
          : AppColors.kSurfaceBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- 1. اللوجو والعناوين ---
              Container(
                height: 96.h,
                width: 96.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(2.r),
                child: Image.asset(
                  "assets/icons/rafiq logo.png",
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: 16.h),

              Text(
                AppLocalizations.of(context)!.rafiq,
                style: Theme.of(context).textTheme.headlineLarge,
              ),

              SizedBox(height: 8.h),

              Text(
                AppLocalizations.of(context)!.pet_care_assistant,
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 32.h),
              // --- 2. الأزرار ---
              CustomButton(
                icon: "assets/icons/email.svg",
                txtColor: Theme.of(context).colorScheme.onPrimary,
                iconColor: Theme.of(context).colorScheme.onPrimary,
                elevation: 3,
                title: AppLocalizations.of(context)!.login_with_email,
                onpressed: () {
                  Navigator.of(context).pushNamed('/login');
                },
              ),
              SizedBox(height: 16.h),

              GoogleButton(
                title: AppLocalizations.of(context)!.login_with_google,
                onPressed: () {
                  // هيسجل دخول بحساب google
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  );
                },
              ),
              SizedBox(height: 16.h),

              AppleButton(
                title: AppLocalizations.of(context)!.login_with_apple,
                onPressed: () {
                  // هيسجل دخول بحساب apple
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  );
                },
              ),

              SizedBox(height: 32.h),

              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.no_account_question,
                    ),
                    TextSpan(
                      text:
                          " ${AppLocalizations.of(context)!.create_new_account}",
                      style: Theme.of(context).textTheme.titleMedium,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).pushNamed("/register");
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
