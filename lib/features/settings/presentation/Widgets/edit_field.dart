import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';

class EditField extends StatelessWidget {
  const EditField({
    super.key,
    // required this.hint,
    required this.controller,
    required this.icon,
    this.isFName = false,
    this.isLName = false,
  });

  // final String hint;
  final TextEditingController controller;
  final String icon;
  final bool isFName;
  final bool isLName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        // left: AppDimensions.padding,
        // right: AppDimensions.padding,
        top: AppDimensions.paddingS,
        bottom: AppDimensions.paddingS,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: 4.0.h),
          // child:

          // ),
          Row(
            children: [
              if (!isLName) CircleIconButton(icon),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: CustomTextField(
                    // hintText: hint,
                    padding: EdgeInsets.all(AppDimensions.paddingS),
                    contentpadding: EdgeInsets.all(AppDimensions.paddingM),

                    controller: controller,

                    fillColor: colorScheme.primaryContainer.withValues(
                      alpha: 0.2, // غير نشط
                    ),

                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onTertiary.withValues(alpha: 0.6),
                    ),

                    focusedFillColor: colorScheme.surface, // نشط

                    focusedStyle: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              if (!isFName)
                SvgPicture.asset(
                  "assets/icons/edit.svg",
                  height: AppDimensions.iconS,
                  colorFilter: ColorFilter.mode(
                    colorScheme.onTertiary,
                    BlendMode.srcIn,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
