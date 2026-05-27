import 'package:flutter/material.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';

class BadgedIconButton extends StatelessWidget {
  final String iconPath;
  final int badgeCount;
  final void Function(BuildContext) onTap;
  const BadgedIconButton({
    super.key,
    required this.iconPath,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleIconButton(iconPath, onTap: () => onTap(context)),

        // النقطة الحمراء
        if (badgeCount > 0)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFFE63946),
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
