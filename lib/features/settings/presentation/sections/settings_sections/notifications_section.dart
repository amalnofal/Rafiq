import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/features/settings/presentation/Widgets/setting_switch_tile.dart';
import 'package:rafiq/l10n/app_localizations.dart';
import 'package:rafiq/core/controller/app_controller.dart';

class NotificationsSection extends StatelessWidget {
  const NotificationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = context.watch<AppController>();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.notifications,
            // style: TextStyle(color: AppColors.textSecondary),
          ),
          SizedBox(height: AppDimensions.paddingM),
          Card(
            child: SettingSwitchTile(
              icon: "assets/icons/notifications.svg",
              title: AppLocalizations.of(context)!.enable_Notifications,
              value: appController.notificationsEnabled,
              onChanged: (_) => appController.toggleNotifications(),
            ),
          ),
        ],
      ),
    );
  }
}
