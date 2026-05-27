import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/helper/arabic_numbers_formatter.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/core/widgets/expandable_text.dart';
import 'package:rafiq/features/community/data/models/comment_model.dart';
import 'package:rafiq/features/profile/presentation/pages/profile_screen.dart'; // 💡 استيراد شاشة البروفايل

class CommentItem extends StatelessWidget {
  final CommentModel comment;
  final VoidCallback? onLongPress;

  const CommentItem({super.key, required this.comment, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    // 💡 التحقق إذا كان صاحب الكومنت هو المستخدم الحالي
    final userProvider = context.read<UserProvider>();
    final isMe = comment.user.id == userProvider.user?.id;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. الصورة (مغلفة بـ InkWell للضغط)
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProfileScreen(user: comment.user, isMe: isMe),
                ),
              );
            },
            borderRadius: BorderRadius.circular(20.r),
            child: CircleAvatar(
              radius: 20.r,
              backgroundColor: Colors.grey[200],
              backgroundImage:
                  comment.user.photoUrl != null &&
                      comment.user.photoUrl!.isNotEmpty
                  ? CachedNetworkImageProvider(
                      comment.user.photoUrl!,
                      cacheKey: comment.user.photoUrl!.split('?').first,
                    )
                  : const AssetImage("assets/images/user_placeholder.jpg")
                        as ImageProvider,
            ),
          ),
          SizedBox(width: 12.w),

          // 2. المحتوى
          Expanded(
            child: InkWell(
              onLongPress: onLongPress,
              borderRadius: BorderRadius.circular(8.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 💡 تغليف الاسم بـ InkWell للضغط
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(user: comment.user, isMe: isMe),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(4.r),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          comment.user.fullName,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          DateHelper.timeAgoShort(comment.createdAt, context),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6.h),
                  ExpandableText(
                    comment.content,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(height: 1.4),
                    isArabic:
                        ArabicToEnglishNumbersFormatter.getTextDirection(
                          comment.content,
                        ) ==
                        TextDirection.rtl,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
