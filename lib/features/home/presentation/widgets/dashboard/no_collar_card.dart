import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/app_controller.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
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

                CustomButton(
                  color: Theme.of(context).colorScheme.onPrimary,
                  radius: 16.r,
                  title: AppLocalizations.of(context)!.orderNow,
                  txtColor: Theme.of(context).colorScheme.primary,
                  iconColor: Theme.of(context).colorScheme.primary,
                  icon: 'assets/icons/shop.svg',
                  iconSize: 18.w,
                  width: 130.w,
                  height: 38.h,
                  elevation: 0,
                  onPressed: () {
                    Provider.of<AppController>(
                      context,
                      listen: false,
                    ).changeHomeIndex(4);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
