import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';

class CustomSearchBar extends StatelessWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final TextEditingController? controller;
  final bool autofocus;
  final VoidCallback? onClear;

  const CustomSearchBar({
    super.key,
    this.hintText,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.controller,
    this.autofocus = false,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    // التحقق هل اليوزر كاتب كلام عشان نظهر علامة X ولا أيقونة البحث
    bool hasText = controller != null && controller!.text.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.padding),
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        onChanged: onChanged,
        onTap: onTap,
        readOnly: readOnly,
        textAlignVertical: TextAlignVertical.center,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          isDense: true,
          fillColor: Theme.of(context).colorScheme.surface,
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          hintText: hintText ?? "ابحث هنا...",
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
          
          // تغيير الأيقونة ديناميكياً
          suffixIcon: hasText
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () {
                    controller?.clear();
                    if (onClear != null) onClear!();
                  },
                )
              : Padding(
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
}