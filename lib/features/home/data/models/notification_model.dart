import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_colors.dart';

enum NotificationType { community, appointment, collar, alert }

class NotificationModel {
  final String title;
  final String subtitle;
  final String time;
  final NotificationType type;
  final bool isUnread;

  NotificationModel({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.type,
    this.isUnread = false,
  });

  String get icon {
    switch (type) {
      case NotificationType.community:
        return "assets/icons/community.svg";
      case NotificationType.appointment:
        return "assets/icons/calendar.svg";
      case NotificationType.collar:
        return "assets/icons/activity.svg";
      case NotificationType.alert:
        return "assets/icons/alert.svg";
    }
  }

  Color get iconColor {
    switch (type) {
      case NotificationType.community:
        return AppColors.kBrandPrimary;
      case NotificationType.appointment:
        return Colors.blue;
      case NotificationType.collar:
        return Colors.green;
      case NotificationType.alert:
        return Colors.orange;
    }
  }

  Color get bgColor => iconColor.withValues(alpha: 0.1);
}
