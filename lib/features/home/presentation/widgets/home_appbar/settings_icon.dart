import 'package:flutter/material.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/features/settings/presentation/pages/settings_screen.dart';

class SettingsIcon extends StatelessWidget {
  final VoidCallback? onTap;

  const SettingsIcon({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CircleIconButton(
      "assets/icons/settings.svg",
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsScreen()),
        );
      },
    );
  }
}
