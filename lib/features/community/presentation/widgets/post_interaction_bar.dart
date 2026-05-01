import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/features/community/presentation/widgets/comments_bottom_sheet.dart';

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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // زر اللايكات
            _buildInteractionButton(
              context,
              count: likes,
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
              onTap: _toggleLike,
            ),
            SizedBox(width: 16.w),
            // زر التعليقات
            _buildInteractionButton(
              context,
              count: comments,
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
                  builder: (context) => const CommentsBottomSheet(),
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
              // الأيقونة
              iconWidget,
              SizedBox(width: 6.w),
              // الرقم (لو صفر مش هيظهر رقم عشان تبقى أنضف)
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
