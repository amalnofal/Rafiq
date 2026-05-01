import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/app_controller.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/settings/presentation/Widgets/language_tile.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class ChangeLanguage extends StatelessWidget {
  const ChangeLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = context.watch<AppController>();

    return RafiqScaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.language,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
            child: Text(
              AppLocalizations.of(context)!.choose_lan,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),

          CustomContainer(
            padding: EdgeInsets.all(0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radius),
              child: Column(
                children: [
                  LanguageTile(
                    title: "العربية",
                    isSelected: appController.locale.languageCode == 'ar',
                    onTap: () {
                      if (appController.locale.languageCode != 'ar') {
                        appController.toggleLanguage();
                      }
                    },
                  ),
                  Divider(height: 1),
                  LanguageTile(
                    title: "English",
                    isSelected: appController.locale.languageCode == 'en',
                    onTap: () {
                      if (appController.locale.languageCode != 'en') {
                        appController.toggleLanguage();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Card(
            color: Theme.of(context).colorScheme.secondary,
            elevation: 1,
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.padding),
              child: Text(
                AppLocalizations.of(context)!.lan_note,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
