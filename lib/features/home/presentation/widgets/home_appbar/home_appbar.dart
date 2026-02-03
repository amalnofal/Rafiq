import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/features/home/presentation/widgets/home_appbar/notification_icon.dart';
import 'package:rafiq/features/home/presentation/widgets/home_appbar/settings_icon.dart';
import 'package:rafiq/features/home/presentation/widgets/home_appbar/user_greeting.dart';

AppBar homeAppBar() {
  return AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UserGreeting(),
        Row(
          children: [
            NotificationIcon(badgeCount: 1, onTap: () {}),
            SizedBox(width: AppDimensions.paddingM),
            SettingsIcon(),
          ],
        ),
      ],
    ),
  );
}
