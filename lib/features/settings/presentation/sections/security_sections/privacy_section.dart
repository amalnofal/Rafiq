import 'package:flutter/material.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/settings/presentation/Widgets/setting_switch_tile.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class PrivacySection extends StatelessWidget {
  const PrivacySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.privacy_settings,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        // SizedBox(height: AppDimensions.paddingM),
        CustomContainer(
          padding: EdgeInsets.all(0),
          child: Column(
            children: [
              SettingSwitchTile(
                icon: "assets/icons/public_profile.svg",
                title: (AppLocalizations.of(context)!.publicProfileTitle),
                subtitle: (AppLocalizations.of(context)!.publicProfileSubtitle),
                value: true,
              ),
              const Divider(),
              SettingSwitchTile(
                icon: "assets/icons/show.svg",
                title: (AppLocalizations.of(context)!.displayPetsTitle),
                subtitle: (AppLocalizations.of(context)!.displayPetsSubtitle),
                value: true,
              ),
              const Divider(),
              SettingSwitchTile(
                icon: "assets/icons/phone.svg",
                title: (AppLocalizations.of(context)!.displayPhoneTitle),
                subtitle: (AppLocalizations.of(context)!.displayPhoneSubtitle),
              ),
              const Divider(),
              SettingSwitchTile(
                icon: "assets/icons/notifications.svg",
                title: (AppLocalizations.of(context)!.allowMessagesTitle),
                subtitle: (AppLocalizations.of(context)!.allowMessagesSubtitle),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
