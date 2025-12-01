import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/settings/presentation/sections/security_sections/password_section.dart';
import 'package:rafiq/features/settings/presentation/sections/security_sections/privacy_section.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class PrivacySecurity extends StatelessWidget {
  const PrivacySecurity({super.key});

  @override
  Widget build(BuildContext context) {
    return RafiqScaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.privacy_security),
      ),
      body: Column(
        children: [
          PasswordSection(),
          PrivacySection(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.padding),
                child: Text(
                  AppLocalizations.of(context)!.privacy_note,
                  // style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  //   color: AppColors.textSecondary,
                  // ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
