import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
      child: CustomButton(
        title: AppLocalizations.of(context)!.log_out,
        color: Theme.of(context).cardColor,
        txtColor: AppColors.kStatusError,
        icon: 'assets/icons/logout.svg',
        iconColor: AppColors.kStatusError,
        onpressed: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login', // اسم الصفحة اللي عايزة ترجعيها
            (route) => false, // يمسح كل الصفحات القديمة
          );
        },
      ),
    );
  }
}
