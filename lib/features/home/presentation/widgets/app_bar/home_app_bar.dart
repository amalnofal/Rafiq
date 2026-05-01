import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/features/home/presentation/widgets/app_bar/notification_icon.dart';
import 'package:rafiq/features/home/presentation/widgets/app_bar/settings_icon.dart';
import 'package:rafiq/features/home/presentation/widgets/app_bar/user_greeting.dart';

AppBar homeAppBar({required int notificationsCount}) {
  return AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UserGreeting(),
        Row(
          children: [
            NotificationIcon(badgeCount: notificationsCount),
            SizedBox(width: AppDimensions.paddingM),
            SettingsIcon(),
          ],
        ),
      ],
    ),
  );
}
