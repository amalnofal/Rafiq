import 'package:flutter/material.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/settings/presentation/Widgets/log_out_button.dart';
import 'package:rafiq/features/settings/presentation/sections/settings_sections/account_info_section.dart';
import 'package:rafiq/features/settings/presentation/sections/settings_sections/account_section.dart';
import 'package:rafiq/features/settings/presentation/sections/settings_sections/general_section.dart';
import 'package:rafiq/features/settings/presentation/sections/settings_sections/notifications_section.dart';
import 'package:rafiq/features/settings/presentation/sections/settings_sections/version_section.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RafiqScaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          GeneralSection(),
          NotificationsSection(),
          AccountSection(),
          AccountInfoSection(),
          VersionSection(),
          LogOutButton(),
        ],
      ),
    );
  }
}
