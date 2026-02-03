import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';

class SettingChoiceTile extends StatelessWidget {
  const SettingChoiceTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppDimensions.padding,
        vertical: 0,
      ),
      leading: CircleIconButton(icon),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.labelMedium),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppColors.kContentSecondary,
        size: AppDimensions.iconXS,
      ),
      onTap: onTap,
    );
  }
}
