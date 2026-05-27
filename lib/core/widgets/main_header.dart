import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/core/widgets/custom_search_bar.dart';

class MainHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String icon;
  final double? height;

  final double? iconSize;
  final VoidCallback? onIconTap;

  final String? searchHintText;
  final ValueChanged<String>? onSearchChanged;

  final VoidCallback? onSearchTap;
  final bool readOnlySearch;
  final bool showBackButton;
  final TextEditingController? searchController;
  final bool autofocusSearch;
  final VoidCallback? onClearSearch;

  const MainHeader({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.height,
    this.iconSize,
    this.onIconTap,
    this.searchHintText,
    this.onSearchChanged,
    this.onSearchTap,
    this.readOnlySearch = false,
    this.showBackButton = false,
    this.searchController,
    this.autofocusSearch = false,
    this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: height,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20.h,
        left: 20.w,
        right: 20.w,
        bottom: 12.h,
      ),
      decoration: BoxDecoration(
        boxShadow: isDarkMode
            ? []
            : [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 15),
                  spreadRadius: -4,
                ),
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 6),
                  spreadRadius: -3,
                ),
              ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary,
            Color.lerp(
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.surfaceContainer,
              0.2,
            )!,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. العنوان والأيقونة
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ],
              ),
              const Spacer(),

              GestureDetector(
                onTap: onIconTap ?? () {},
                child: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  child: SvgPicture.asset(
                    icon,
                    width: iconSize ?? 20.w,
                    height: iconSize ?? 20.h,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 2. شريط البحث
          if (searchHintText != null) ...[
            CustomSearchBar(
              hintText: searchHintText,
              onChanged: onSearchChanged,
              onTap: onSearchTap,
              readOnly: readOnlySearch,
              controller: searchController,
              autofocus: autofocusSearch,
              onClear: onClearSearch,
            ),
          ],
        ],
      ),
    );
  }
}
