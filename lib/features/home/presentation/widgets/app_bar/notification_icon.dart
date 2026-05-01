import 'package:flutter/material.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';

class NotificationIcon extends StatelessWidget {
  final int badgeCount;

  const NotificationIcon({super.key, this.badgeCount = 0});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleIconButton(
          "assets/icons/notifications.svg",
          onTap: () {
            Navigator.pushNamed(context, '/notifications');
          },
        ),

        if (badgeCount > 0)
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
