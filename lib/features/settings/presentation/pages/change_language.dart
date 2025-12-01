import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/app_controller.dart';
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
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              (AppLocalizations.of(context)!.choose_lan),
              // style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              child: Card(
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
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.padding),
                child: Text(
                  AppLocalizations.of(context)!.lan_note,
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
