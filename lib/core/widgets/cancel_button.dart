import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomButton(
      onpressed: () => Navigator.of(context).pop(),
      height: AppDimensions.buttonHeightS,
      title: AppLocalizations.of(context)!.cancel,
      fontWeight: FontWeight.w500,
      color: isDark ? AppColors.kDarkContainer : Color(0xFFF3F4F6),
      txtColor: Theme.of(context).textTheme.bodyMedium?.color,
      elevation: 0,
    );
  }
}
