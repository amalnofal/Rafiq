import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class PasswordRules extends StatelessWidget {
  const PasswordRules({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDark
          ? AppColors.kDarkContainer
          : AppColors.kSurfaceAlt.withValues(alpha: 0.6),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingL,
          vertical: AppDimensions.paddingM,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.passwordRequirements,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            SizedBox(height: AppDimensions.paddingXS),
            _buildRequirementItem(
              context,
              AppLocalizations.of(context)!.passwordRuleLength,
            ),
            _buildRequirementItem(
              context,
              AppLocalizations.of(context)!.passwordRuleCase,
            ),
            _buildRequirementItem(
              context,
              AppLocalizations.of(context)!.passwordRuleNumber,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementItem(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.paddingXS),
      child: Row(
        children: [
          Icon(Icons.circle, size: 5.h),
          SizedBox(width: 8.w),
          Text(text, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}
