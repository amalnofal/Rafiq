import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class CommentItem extends StatelessWidget {
  final Map<String, dynamic> commentData;
  final bool isReply;
  final VoidCallback? onReplyTap;
  final VoidCallback onLikeTap;
  final VoidCallback? onLongPress;
  final bool isReplyingToThis;

  const CommentItem({
    super.key,
    required this.commentData,
    required this.isReply,
    this.onReplyTap,
    required this.onLikeTap,
    this.onLongPress,
    this.isReplyingToThis = false,
  });

  ImageProvider? _getAvatarImage(String path) {
    if (path.isEmpty) return null;
    if (path.startsWith('http')) return NetworkImage(path);
    return FileImage(File(path));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: isReplyingToThis
          ? Theme.of(context).cardTheme.color!.withValues(alpha: 0.5)
          : Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. الصورة (Avatar)
          CircleAvatar(
            radius: isReply ? 16.r : 20.r,
            backgroundColor: Colors.grey[200],
            backgroundImage:
                commentData['image'] != null &&
                    commentData['image'].toString().isNotEmpty
                ? _getAvatarImage(commentData['image'])!
                : const AssetImage("assets/images/user_placeholder.jpg"),
          ),

          SizedBox(width: 12.w),

          // 2. المحتوى الأساسي
          Expanded(
            child: InkWell(
              onLongPress: onLongPress,
              borderRadius: BorderRadius.circular(8.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // سطر الاسم والوقت
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        commentData['name'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // الوقت
                      Text(
                        commentData['time'],
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // كلمة Edited
                      if (commentData['isEdited'] == true) ...[
                        SizedBox(width: 4.w),
                        Text(
                          "• ${AppLocalizations.of(context)!.edited}",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 6.h),

                  // نص الكومنت
                  Text(
                    commentData['text'],
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(height: 1.4),
                  ),

                  SizedBox(height: 8.h),

                  // زر الرد
                  if (onReplyTap != null)
                    InkWell(
                      onTap: onReplyTap,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          // vertical: 4.h,
                          horizontal: 2.w,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.replyAction,
                          style: Theme.of(context).textTheme.labelSmall!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // 3. قسم اللايكات
          Column(
            children: [
              InkWell(
                onTap: onLikeTap,
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: SvgPicture.asset(
                    commentData['isLiked']
                        ? "assets/icons/like.svg"
                        : "assets/icons/unlike.svg",
                    height: 18.h,
                    colorFilter: ColorFilter.mode(
                      commentData['isLiked']
                          ? Colors.red
                          : Theme.of(context).colorScheme.onTertiary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              Text(
                "${commentData['likesCount']}",
                style: Theme.of(
                  context,
                ).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
