import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/settings/presentation/Widgets/setting_choice_tile.dart';
import 'package:rafiq/features/settings/presentation/pages/account_management.dart';
import 'package:rafiq/features/settings/presentation/pages/privacy_security.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.account,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          CustomContainer(
            padding: EdgeInsets.all(0),
            child: Column(
              children: [
                SettingChoiceTile(
                  icon: 'assets/icons/user_icon.svg',
                  title: AppLocalizations.of(context)!.account_management,
                  subtitle:
                      "${AppLocalizations.of(context)!.name} , ${AppLocalizations.of(context)!.email} , ${AppLocalizations.of(context)!.phone}",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccountManagement(),
                      ),
                    );
                  },
                ),

                Divider(),

                SettingChoiceTile(
                  icon: 'assets/icons/security.svg',
                  title: AppLocalizations.of(context)!.privacy_security,
                  subtitle:
                      "${AppLocalizations.of(context)!.password} , ${AppLocalizations.of(context)!.privacy}",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrivacySecurity(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
