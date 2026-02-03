import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/features/community/presentation/widgets/comments_bottom_sheet.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class PostInteractionBar extends StatefulWidget {
  final int initialLikes;
  final int initialComments;

  const PostInteractionBar({
    super.key,
    required this.initialLikes,
    required this.initialComments,
  });

  @override
  State<PostInteractionBar> createState() => _PostInteractionBarState();
}

class _PostInteractionBarState extends State<PostInteractionBar> {
  late int likes;
  late int comments;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    likes = widget.initialLikes;
    comments = widget.initialComments;
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        likes++;
      } else {
        likes--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Stats Row
        if (likes > 0 || comments > 0) ...[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                // أيقونة ورقم اللايكات
                if (likes > 0) ...[
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 10.sp,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '$likes',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],

                const Spacer(),

                // رقم التعليقات
                if (comments > 0)
                  Text(
                    '$comments ${AppLocalizations.of(context)!.commentAction}',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
                  ),
              ],
            ),
          ),
        ],
        Divider(height: 1.h),
        SizedBox(height: 4.h),

        // Action Buttons
        Row(
          children: [
            // زر اللايك
            Expanded(
              child: _buildActionButton(
                context,
                icon: isLiked
                    ? "assets/icons/like.svg"
                    : "assets/icons/unlike.svg",
                label: AppLocalizations.of(context)!.likeAction,
                color: isLiked ? Colors.red : null,
                onTap: _toggleLike,
              ),
            ),

            // زر التعليق
            Expanded(
              child: _buildActionButton(
                context,
                icon: "assets/icons/comment.svg",
                label: AppLocalizations.of(context)!.commentAction,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const CommentsBottomSheet(),
                  );
                },
              ),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String icon,
    required String label,
    Color? color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon, height: 18.h),
            SizedBox(width: 8.w),
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium!.copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
