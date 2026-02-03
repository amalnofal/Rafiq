import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        title: Text(
          AppLocalizations.of(context)!.privacy_security,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: SingleChildScrollView(
        clipBehavior: Clip.none,
        child: Column(
          children: [
            PasswordSection(),
            PrivacySection(),
            SizedBox(height: 8.h),
            Card(
              color: Theme.of(context).colorScheme.secondary,
              elevation: 1,
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.padding),
                child: Text(
                  AppLocalizations.of(context)!.privacy_note,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
