import 'package:flutter/material.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class LoginButtons extends StatelessWidget {
  const LoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Column(
          children: [
            CustomButton(
              icon: "assets/icons/email.svg",
              txtColor: Theme.of(context).colorScheme.onPrimary,
              iconColor: Theme.of(context).colorScheme.onPrimary,
              title: AppLocalizations.of(context)!.login_with_email,
              onpressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home', // الصفحة الجديدة
                  (route) => false, // احذف كل الصفحات القديمة
                );
              },
              width: double.infinity,
            ),
            CustomButton(
              icon: "assets/icons/google.svg",
              title: AppLocalizations.of(context)!.login_with_google,
              color: Theme.of(context).cardTheme.color,
              txtColor: Theme.of(context).colorScheme.onSurface,
              preserveIconColors: true,
              onpressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home', // الصفحة الجديدة
                  (route) => false, // احذف كل الصفحات القديمة
                );
              },
              width: double.infinity,
            ),
            CustomButton(
              title: AppLocalizations.of(context)!.login_with_apple,
              color: Theme.of(context).colorScheme.tertiary,
              txtColor: Theme.of(context).cardTheme.color,
              icon: "assets/icons/apple.svg",
              iconColor: Theme.of(context).cardTheme.color,
              onpressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home', // الصفحة الجديدة
                  (route) => false, // احذف كل الصفحات القديمة
                );
              },
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
