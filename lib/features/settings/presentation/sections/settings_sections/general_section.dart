import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/features/settings/presentation/Widgets/setting_choice_tile.dart';
import 'package:rafiq/features/settings/presentation/Widgets/setting_switch_tile.dart';
import 'package:rafiq/features/settings/presentation/pages/change_language.dart';
import 'package:rafiq/l10n/app_localizations.dart';
import 'package:rafiq/core/controller/app_controller.dart';

class GeneralSection extends StatelessWidget {
  const GeneralSection({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = context.watch<AppController>();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.general,
            // style: TextStyle(color: AppColors.textSecondary),
          ),
          SizedBox(height: AppDimensions.paddingM),
          Card(
            child: Column(
              children: [
                SettingChoiceTile(
                  icon: 'assets/icons/language.svg',
                  title: AppLocalizations.of(context)!.language,
                  subtitle: AppLocalizations.of(context)!.lan,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangeLanguage(),
                      ),
                    );
                  },
                ),
                Divider(),
                SettingSwitchTile(
                  icon: "assets/icons/theme.svg",
                  title: AppLocalizations.of(context)!.dark_mode,
                  value: appController.isDarkMode,
                  onChanged: (_) => appController.toggleTheme(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
