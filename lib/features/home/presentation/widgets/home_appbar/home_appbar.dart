import 'package:flutter/material.dart';
import 'package:rafiq/features/home/presentation/widgets/home_appbar/notification_icon.dart';
import 'package:rafiq/features/home/presentation/widgets/home_appbar/settings_icon.dart';
import 'package:rafiq/features/home/presentation/widgets/home_appbar/user_greeting.dart';

AppBar homeAppBar({required String userName}) {
  return AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UserGreeting(userName: userName),
        Row(
          children: [
            NotificationIcon(badgeCount: 1, onTap: () {}),
            const SizedBox(width: 12),
            SettingsIcon(),
          ],
        ),
      ],
    ),
  );
}
