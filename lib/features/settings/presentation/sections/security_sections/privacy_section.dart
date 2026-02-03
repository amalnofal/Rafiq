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
                title: (AppLocalizations.of(context)!.profile_public),
                subtitle: (AppLocalizations.of(context)!.profile_public_sub),
                value: true,
              ),
              const Divider(),
              SettingSwitchTile(
                icon: "assets/icons/privacy.svg",
                title: (AppLocalizations.of(context)!.show_email),
                subtitle: (AppLocalizations.of(context)!.show_email_sub),
              ),
              const Divider(),
              SettingSwitchTile(
                icon: "assets/icons/privacy.svg",
                title: (AppLocalizations.of(context)!.show_phone),
                subtitle: (AppLocalizations.of(context)!.show_phone_sub),
              ),
              const Divider(),
              SettingSwitchTile(
                icon: "assets/icons/notifications.svg",
                title: (AppLocalizations.of(context)!.allow_messages),
                subtitle: (AppLocalizations.of(context)!.allow_messages_sub),
                value: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
