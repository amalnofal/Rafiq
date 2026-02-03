import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';

class MainHeader extends StatelessWidget {
  final String title;
  final String icon;
  final double? height;

  final String? searchHintText;
  final ValueChanged<String>? onSearchChanged;

  final List<String>? filterCategories;
  final int selectedFilterIndex;
  final ValueChanged<int>? onFilterSelected;

  const MainHeader({
    super.key,
    required this.title,
    required this.icon,
    this.height,
    this.searchHintText,
    this.onSearchChanged,
    this.filterCategories,
    this.selectedFilterIndex = 0,
    this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20.h,
        left: 20.w,
        right: 20.w,
        bottom: 20.h,
      ),
      decoration: BoxDecoration(
        boxShadow: [
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
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
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
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const Spacer(),
              SvgPicture.asset(
                icon,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),

          // 2. شريط البحث
          if (searchHintText != null) ...[_buildSearchBar(context)],

          // 3. الفلاتر
          if (filterCategories != null && filterCategories!.isNotEmpty) ...[
            _buildFilterList(context),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.padding),
      child: TextField(
        onChanged: onSearchChanged,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 14.h,
          ),

          hintText: searchHintText ?? "ابحث هنا...",
          hintStyle: Theme.of(context).textTheme.labelLarge,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),

          suffixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(
              "assets/icons/search.svg",
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSecondary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterList(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(filterCategories!.length, (index) {
          final bool isSelected = index == selectedFilterIndex;
          return Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: GestureDetector(
              onTap: () => onFilterSelected?.call(index),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  filterCategories![index],
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSecondary,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
