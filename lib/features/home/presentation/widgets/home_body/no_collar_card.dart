import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class NoCollarCard extends StatelessWidget {
  final VoidCallback? onOrderPressed;

  const NoCollarCard({super.key, this.onOrderPressed});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Color> gradientColors = isDark
        ? [AppColors.kPrimaryDark, AppColors.kBrandPrimary]
        : [AppColors.kBrandPrimary, AppColors.kPrimaryLight];

    return Container(
      margin: EdgeInsets.all(AppDimensions.padding),
      padding: EdgeInsets.all(AppDimensions.padding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            child: SvgPicture.asset(
              'assets/icons/activity.svg',

              width: 24.w,
              height: 24.h,
            ),
          ),
          SizedBox(width: AppDimensions.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.noSmartCollarTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                SizedBox(height: 8.h),
                Text(
                  AppLocalizations.of(context)!.orderSmartCollarDescription,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                SizedBox(height: 16.h),

                ElevatedButton.icon(
                  onPressed: onOrderPressed ?? () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: Colors.white,
                    // foregroundColor: AppColors.kBrandPrimary,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radius),
                    ),
                  ),

                  icon: SvgPicture.asset('assets/icons/shop.svg'),
                  label: Text(
                    AppLocalizations.of(context)!.orderNow,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.kBrandPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
