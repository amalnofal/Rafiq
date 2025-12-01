import 'package:flutter/material.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';

class NotificationIcon extends StatelessWidget {
  final int? badgeCount;
  final VoidCallback? onTap;

  const NotificationIcon({super.key, this.badgeCount, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleIconButton("assets/icons/notifications.svg", onTap: () {}),

        // 🔴 النقطة الحمراء (badge)
        if (badgeCount != null && badgeCount! > 0)
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
