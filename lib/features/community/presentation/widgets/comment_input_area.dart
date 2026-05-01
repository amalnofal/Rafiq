import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class CommentInputArea extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;

  const CommentInputArea({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 6.h,
        bottom: 8.h + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              hintText: AppLocalizations.of(context)!.writeCommentHint,
              hintStyle: theme.textTheme.labelMedium,
              controller: controller,
              focusNode: focusNode,
              borderColor: theme.colorScheme.primary.withValues(alpha: 0.15),
              fillColor: theme.scaffoldBackgroundColor,
              focusedFillColor: theme.scaffoldBackgroundColor,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
            ),
          ),
          SizedBox(width: 12.w),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              final hasText = value.text.trim().isNotEmpty;

              return InkWell(
                onTap: hasText ? onSend : null,
                borderRadius: BorderRadius.circular(50.r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(10.w),
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
              );
            },
          ),
        ],
      ),
    );
  }
}
