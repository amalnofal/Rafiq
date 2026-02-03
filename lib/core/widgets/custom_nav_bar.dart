import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onFabTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onFabTap,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor = Theme.of(context).colorScheme.primary;
    final unselectedColor = Theme.of(context).colorScheme.onTertiary;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final isFabSelected = currentIndex == 2;

    return SizedBox(
      height: 80.h,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 80.h,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                  width: 1.2.w,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(
                        context,
                        "assets/icons/home.svg",
                        AppLocalizations.of(context)!.home,
                        0,
                        selectedColor,
                        unselectedColor,
                      ),
                      _buildNavItem(
                        context,
                        "assets/icons/community.svg",
                        AppLocalizations.of(context)!.community,
                        1,
                        selectedColor,
                        unselectedColor,
                      ),
                    ],
                  ),
                ),

                // === المنتصف (الطوق الذكي - Index 2) ===
                SizedBox(
                  width: 80.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: 35.h),
                      Text(
                        AppLocalizations.of(context)!.smartCollar,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: isFabSelected
                                  ? selectedColor
                                  : unselectedColor,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 14.h),
                    ],
                  ),
                ),

                // ==========================================
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(
                        context,
                        "assets/icons/clinics.svg",
                        AppLocalizations.of(context)!.clinics,
                        3,
                        selectedColor,
                        unselectedColor,
                      ),

                      _buildNavItem(
                        context,
                        "assets/icons/store.svg",
                        AppLocalizations.of(context)!.store,
                        4,
                        selectedColor,
                        unselectedColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // الزر العائم
          Positioned(
            bottom: 40.h,
            child: GestureDetector(
              onTap: onFabTap,
              child: Container(
                width: 56.w,
                height: 56.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: isDarkMode
                      ? null
                      : const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 3),
                          ),
                        ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.padding),
                  child: SvgPicture.asset(
                    "assets/icons/activity.svg",
                    colorFilter: ColorFilter.mode(
                      AppColors.kSurfaceCard,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String icon,
    String label,
    int index,
    Color selColor,
    Color unselColor,
  ) {
    final isSelected = currentIndex == index;
    return InkWell(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          SvgPicture.asset(
            icon,
            colorFilter: ColorFilter.mode(
              isSelected ? selColor : unselColor,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: isSelected ? selColor : unselColor,
            ),
          ),
        ],
      ),
    );
  }
}
