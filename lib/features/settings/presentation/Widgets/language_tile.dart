import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';

class LanguageTile extends StatelessWidget {
  const LanguageTile({
    super.key,
    this.onTap,
    required this.title,
    required this.isSelected,
  });

  final String title;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
        child: ListTile(
          onTap: onTap,
          leading: Container(
            height: 20.w,
            width: 20.w,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primaryColor, width: 2.w),
            ),
            child: isSelected
                ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                    ),
                  )
                : null,
          ),

          title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
          trailing: CircleIconButton("assets/icons/language.svg"),
        ),
      ),
    );
  }
}
