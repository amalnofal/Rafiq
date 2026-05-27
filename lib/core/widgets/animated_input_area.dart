import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';

class AnimatedInputArea extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final Function(String) onChanged;
  final TextDirection textDirection;
  final String hintText;

  // خلينا دول اختياريين عشان تناسب كل الحالات
  final FocusNode? focusNode;
  final int maxLines;

  const AnimatedInputArea({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onChanged,
    required this.textDirection,
    required this.hintText,
    this.focusNode,
    this.maxLines = 4,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 6.h,
        bottom: 12.h + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: CustomTextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              textDirection: textDirection,
              hintText: hintText,
              hintStyle: theme.textTheme.labelMedium,
              borderColor: theme.colorScheme.primary.withValues(alpha: 0.15),
              fillColor: theme.scaffoldBackgroundColor,
              focusedFillColor: theme.scaffoldBackgroundColor,

              maxLines: maxLines,
              minLines: 1,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
            ),
          ),
          SizedBox(width: 12.w),

          // زرار الإرسال الذكي
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              final hasText = value.text.trim().isNotEmpty;

              return Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: InkWell(
                  onTap: hasText ? onSend : null,
                  borderRadius: BorderRadius.circular(50.r),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: hasText
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primary.withValues(alpha: 0.5),
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/send.svg",
                      height: 20.h,
                      colorFilter: ColorFilter.mode(
                        theme.colorScheme.onPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
