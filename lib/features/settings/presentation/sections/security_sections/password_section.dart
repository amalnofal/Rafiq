import 'package:flutter/material.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/features/settings/presentation/Widgets/setting_choice_tile.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class PasswordSection extends StatelessWidget {
  const PasswordSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.password),
          SizedBox(height: 12),
          Card(
            child: SettingChoiceTile(
              icon: "assets/icons/security.svg",
              title: AppLocalizations.of(context)!.change_password,
              subtitle: AppLocalizations.of(context)!.password_last_update(
                DateHelper.timeAgo(
                  DateTime.now().subtract(
                    Duration(days: 65),
                  ), // مثال: قبل شهرين و5 أيام
                  context,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
