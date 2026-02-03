import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/features/settings/presentation/Widgets/custom_switch.dart';

class SettingSwitchTile extends StatelessWidget {
  const SettingSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    this.value,
    this.onChanged,
    this.subtitle,
  });
  final String icon;
  final String title;
  final bool? value;
  final ValueChanged<bool>? onChanged;
  final String? subtitle;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppDimensions.padding,
        vertical: 8.h,
      ),
      leading: CircleIconButton(icon),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: subtitle != null
          ? Text(subtitle!, style: Theme.of(context).textTheme.labelMedium)
          : null,
      trailing: CustomSwitch(value: value, onChanged: onChanged),
    );
  }
}
