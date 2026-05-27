import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/auth/presentation/widgets/rafiq_logo.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class EmptyStateLayout extends StatelessWidget {
  final String buttonText;
  final VoidCallback onMainAction;
  final List<DashboardItemData> gridItems;
  final String tipContent;

  const EmptyStateLayout({
    super.key,
    required this.buttonText,
    required this.onMainAction,
    required this.gridItems,
    required this.tipContent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingS),
      child: Column(
        children: [
          // welcome message + main action button
          CustomContainer(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
            child: Column(
              children: [
                RafiqLogo(
                  title: AppLocalizations.of(context)!.welcomeToRafiq,
                  subtitle: AppLocalizations.of(context)!.welcomeSubtitle,
                ),
                SizedBox(height: 12.h),
                CustomButton(
                  height: 50.h,
                  width: 190.w,
                  icon: "assets/icons/add.svg",
                  iconSize: 22.sp,
                  iconColor: Colors.white,
                  fontSize: 16.sp,
                  title: buttonText,
                  fontWeight: FontWeight.w500,
                  elevation: 0,
                  onPressed: onMainAction,
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),

          // feature grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              childAspectRatio: 0.9,
            ),
            itemCount: gridItems.length,
            itemBuilder: (context, index) {
              return _buildGridItem(context, gridItems[index]);
            },
          ),

          SizedBox(height: 12.h),

          // tip section
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: Colors.yellow,
                            size: 20.sp,
                          ),
                          SizedBox(width: 4.w),
                          Padding(
                            padding: EdgeInsets.only(top: 2.h),
                            child: Text(
                              AppLocalizations.of(context)!.tipTitle,
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          tipContent,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall!.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, DashboardItemData item) {
    return CustomContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 23.r,
            backgroundColor: item.color.withValues(alpha: 0.1),
            child: SvgPicture.asset(
              item.iconPath,
              colorFilter: ColorFilter.mode(item.color, BlendMode.srcIn),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            item.title,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4.h),
          Text(
            item.subtitle,
            style: Theme.of(context).textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class DashboardItemData {
  final String title;
  final String subtitle;
  final String iconPath;
  final Color color;
  // final VoidCallback onTap;

  DashboardItemData({
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.color,
    // required this.onTap,
  });
}
