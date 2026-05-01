import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
      child: CustomButton(
        title: AppLocalizations.of(context)!.logout,
        color: Theme.of(context).cardColor,
        txtColor: AppColors.kStatusError,
        icon: 'assets/icons/logout.svg',
        iconColor: AppColors.kStatusError,
        height: AppDimensions.buttonHeightL,
        elevation: 1,
        onPressed: () async {
          await context.read<UserProvider>().logout();
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          }
        },
      ),
    );
  }
}
