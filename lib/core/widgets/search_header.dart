import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_search_bar.dart';

class SearchHeader extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final VoidCallback? onClear;
  const SearchHeader({
    super.key,
    this.onChanged,
    this.controller,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        left: 10.w,
        right: 10.w,
        bottom: 12.h,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
            spreadRadius: -4,
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

      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.h),
        child: Row(
          children: [
            // 1. زرار الرجوع
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                isRTL ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 8.w),
            // 2. شريط البحث
            Expanded(
              child: CustomSearchBar(
                hintText: context.l10n.search,
                controller: controller,
                autofocus: true,
                onChanged: onChanged,
                onClear: onClear,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
