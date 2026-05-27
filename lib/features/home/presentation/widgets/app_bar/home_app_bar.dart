import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/di/service_locator.dart';
import 'package:rafiq/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:rafiq/features/chat/presentation/screens/conversations_screen.dart';
import 'package:rafiq/features/home/presentation/widgets/app_bar/settings_icon.dart';
import 'package:rafiq/features/home/presentation/widgets/app_bar/user_greeting.dart';
import 'package:rafiq/features/home/presentation/widgets/app_bar/badged_icon_button.dart';

AppBar homeAppBar({
  required int notificationsCount,
  required int unreadMessagesCount,
}) {
  return AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UserGreeting(),
        Row(
          children: [
            // 1. أيقونة الشات
            BadgedIconButton(
              iconPath: "assets/icons/chat.svg",
              // badgeCount: unreadMessagesCount,
              onTap: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => getIt<ChatCubit>(),
                      child: const ConversationsScreen(),
                    ),
                  ),
                );
              },
            ),
            SizedBox(width: AppDimensions.paddingM),

            // 2. أيقونة الإشعارات
            BadgedIconButton(
              iconPath: "assets/icons/notifications.svg",
              // badgeCount: notificationsCount,
              onTap: (context) {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
            SizedBox(width: AppDimensions.paddingM),

            // 3. أيقونة الإعدادات
            SettingsIcon(),
          ],
        ),
      ],
    ),
  );
}
