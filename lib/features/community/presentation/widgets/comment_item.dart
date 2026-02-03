import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class CommentItem extends StatelessWidget {
  final Map<String, dynamic> commentData;
  final bool isReply;
  final VoidCallback? onReplyTap;
  final VoidCallback onLikeTap;
  final VoidCallback? onLongPress;

  const CommentItem({
    super.key,
    required this.commentData,
    required this.isReply,
    this.onReplyTap,
    required this.onLikeTap,
    this.onLongPress,
  });

  ImageProvider? _getAvatarImage(String path) {
    if (path.isEmpty) return null;
    if (path.startsWith('http')) return NetworkImage(path);
    return FileImage(File(path));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: isReply ? 14.r : 18.r,
            backgroundColor: Colors.grey[200],
            backgroundImage: _getAvatarImage(commentData['image']),
            child: _getAvatarImage(commentData['image']) == null
                ? Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: isReply ? 16.sp : 20.sp,
                  )
                : null,
          ),
          SizedBox(width: 10.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bubble (With InkWell for Long Press)
                InkWell(
                  onLongPress: onLongPress,
                  borderRadius: BorderRadius.circular(16.r),
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          commentData['name'],
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          commentData['text'],
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),

                // Actions Row
                Padding(
                  padding: EdgeInsets.only(left: 8.w, top: 4.h, right: 8.w),
                  child: Row(
                    children: [
                      Text(
                        commentData['time'],
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      if (commentData['isEdited'] == true) ...[
                        SizedBox(width: 8.w),
                        Text(
                          ". ${AppLocalizations.of(context)!.edited}",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                      SizedBox(width: 16.w),

                      if (onReplyTap != null)
                        InkWell(
                          onTap: onReplyTap,
                          child: Text(
                            AppLocalizations.of(context)!.replyAction,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                          ),
                        ),

                      const Spacer(),

                      // Like Button
                      InkWell(
                        onTap: onLikeTap,
                        borderRadius: BorderRadius.circular(50),
                        child: Row(
                          children: [
                            Icon(
                              commentData['isLiked']
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 16.sp,
                              color: commentData['isLiked']
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            if (commentData['likesCount'] > 0) ...[
                              SizedBox(width: 4.w),
                              Text(
                                "${commentData['likesCount']}",
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: commentData['isLiked']
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
