import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/core/widgets/custom_search_bar.dart';

class MainHeader extends StatelessWidget {
  final String title;
  final String icon;
  final double? height;

  final String? searchHintText;
  final ValueChanged<String>? onSearchChanged;

  final List<String>? filterCategories;
  final int selectedFilterIndex;
  final ValueChanged<int>? onFilterSelected;

  final VoidCallback? onSearchTap;
  final bool readOnlySearch;
  final bool showBackButton;
  final TextEditingController? searchController;
  final bool autofocusSearch;
  final VoidCallback? onClearSearch;

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
