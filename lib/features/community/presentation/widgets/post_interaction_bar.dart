import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/community_provider.dart';
import 'package:rafiq/features/community/presentation/widgets/comments_bottom_sheet.dart';

class PostInteractionBar extends StatelessWidget {
  final String postId;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;

  const PostInteractionBar({
    super.key,
    required this.postId,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // زر اللايكات
            _buildInteractionButton(
              context,
              count: likesCount,
              iconWidget: SvgPicture.asset(
                isLiked ? "assets/icons/like.svg" : "assets/icons/unlike.svg",
                height: 20.h,
                colorFilter: ColorFilter.mode(
                  isLiked
                      ? Colors.red
                      : Theme.of(context).colorScheme.onTertiary,
                  BlendMode.srcIn,
                ),
              ),
              onTap: () {
                // 🚨 ندهنا على الدالة اللي عملناها في الـ Provider
                context.read<CommunityProvider>().toggleLike(postId, isLiked);
              },
            ),
            SizedBox(width: 16.w),
            // زر التعليقات
            _buildInteractionButton(
              context,
              count: commentsCount,
              iconWidget: SvgPicture.asset(
                "assets/icons/comment.svg",
                height: 19.h,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onTertiary,
                  BlendMode.srcIn,
                ),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  enableDrag: false,
                  builder: (context) => CommentsBottomSheet(postId: postId),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInteractionButton(
    BuildContext context, {
    required int count,
    required Widget iconWidget,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        constraints: BoxConstraints(minWidth: 50.w, minHeight: 32.h),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconWidget,
              SizedBox(width: 6.w),
              if (count > 0) ...[
                Padding(
                  padding: EdgeInsets.only(top: 3.h),
                  child: Text(
                    '$count',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
