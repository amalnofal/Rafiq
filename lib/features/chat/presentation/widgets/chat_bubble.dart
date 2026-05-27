
// ==========================================
// 🚀 ويدجت فقاعة واتساب المطورة والموسعة بالـ ScreenUtil
// ==========================================
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/helper/arabic_numbers_formatter.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final String time;
  final bool isMe;

  const ChatBubble({
    super.key,
    required this.message,
    required this.time,
    required this.isMe,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  bool _isExpanded = false;
  final int _maxLines = 5;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textDirection = ArabicToEnglishNumbersFormatter.getTextDirection(
      widget.message,
    );

    return Align(
      alignment: widget.isMe
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        constraints: BoxConstraints(
          minWidth: 80.w,
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: widget.isMe ? theme.colorScheme.primary : theme.cardColor,
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(16.r),
            topEnd: Radius.circular(16.r),
            bottomStart: Radius.circular(widget.isMe ? 16.r : 0),
            bottomEnd: Radius.circular(widget.isMe ? 0 : 16.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // نص الرسالة
              Text(
                widget.message,
                maxLines: _isExpanded ? null : _maxLines,
                overflow: _isExpanded
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
                textDirection: textDirection,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: widget.isMe ? theme.colorScheme.onPrimary : null,
                  fontSize: 14.sp, // 🚀 حجم خط فريش وواضح ومناسب لكل الأجهزة
                  height: 1.3, // تباعد سطور مريح للقراءة
                ),
              ),

              // زرار عرض المزيد لو النص تخطى 200 حرف
              if (widget.message.length > 200 && !_isExpanded) ...[
                SizedBox(height: 4.h),
                InkWell(
                  onTap: () => setState(() => _isExpanded = true),
                  child: Text(
                    context.l10n.showMoreBtn,
                    style: theme.textTheme.labelSmall!.copyWith(
                      color: widget.isMe
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],

              SizedBox(height: 4.h),

              // وقت الرسالة
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: Text(
                  widget.time,
                  style: theme.textTheme.labelSmall!.copyWith(
                    color: widget.isMe
                        ? theme.colorScheme.onPrimary.withValues(alpha: 0.7)
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
