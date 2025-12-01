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
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.secondaryContainer
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
        child: ListTile(
          leading: Container(
            height: 22.w,
            width: 22.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              border: Border.all(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
            child: isSelected
                ? Icon(Icons.check, size: 14.w, color: Colors.white)
                : null,
          ),
          title: Text(title),
          trailing: CircleIconButton("assets/icons/language.svg"),
          onTap: onTap,
        ),
      ),
    );
  }
}
