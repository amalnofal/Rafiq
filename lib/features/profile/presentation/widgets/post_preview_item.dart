import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/core/widgets/smart_image_display.dart';
import 'package:rafiq/features/community/data/models/post_model.dart';

class PostPreviewItem extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onTap;

  const PostPreviewItem({super.key, required this.post, this.onTap});

  @override
  Widget build(BuildContext context) {
    bool hasImage = post.media.isNotEmpty;
    Color interactionColor = hasImage
        ? Colors.white.withValues(alpha: 0.9)
        : Theme.of(context).colorScheme.onTertiary;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ==========================================
            // المحتوى: صورة أو فيديو
            // ==========================================
            if (hasImage) ...[
              post.media.first.isVideo
                  ? Container(
                      color: const Color(0xFF1E1E1E),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: const BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 35.sp,
                          ),
                        ),
                      ),
                    )
                  : SmartImageDisplay(
                      path: post.media.first.url,
                      fit: BoxFit.cover,
                      radius: 0,
                    ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 50.h,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
              ),
            ] else ...[
              Container(
                color: Theme.of(context).cardTheme.color,
                padding: EdgeInsets.all(8.r),
                child: Center(
                  child: Text(
                    post.text,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ],

            // ==========================================
            // التفاعلات
            // ==========================================
            Positioned(
              bottom: 8.h,
              left: 4.w,
              right: 4.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // اللايكات
                  SvgPicture.asset(
                    post.isLiked
                        ? "assets/icons/like.svg"
                        : "assets/icons/unlike.svg",
                    height: 14.h,
                    width: 14.w,
                    colorFilter: ColorFilter.mode(
                      interactionColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      '${post.likesCount}',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: interactionColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),

                  // الكومنتات
                  SvgPicture.asset(
                    "assets/icons/comment.svg",
                    height: 14.h,
                    width: 14.w,
                    colorFilter: ColorFilter.mode(
                      interactionColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      '${post.commentsCount}',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: interactionColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
