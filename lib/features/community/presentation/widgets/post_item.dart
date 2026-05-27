import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/community_provider.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/enums/post_category.dart';
import 'package:rafiq/core/helper/arabic_numbers_formatter.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/dialog_helper.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/helper/menu_utils.dart';
import 'package:rafiq/core/widgets/expandable_text.dart';
import 'package:rafiq/core/widgets/smart_image_display.dart';
import 'package:rafiq/core/models/user_model.dart';
import 'package:rafiq/features/community/data/models/post_model.dart';
import 'package:rafiq/features/community/presentation/pages/create_post_screen.dart';
import 'package:rafiq/features/community/presentation/widgets/full_screen_image_viewer.dart';
import 'package:rafiq/features/community/presentation/widgets/post_interaction_bar.dart';
import 'package:rafiq/features/community/presentation/widgets/post_user_header.dart';
import 'package:rafiq/features/community/presentation/widgets/post_video_player.dart';

class PostItem extends StatefulWidget {
  final UserModel author;
  final PostModel post;
  final String timeAgo;
  final String postText;

  final List<PostMedia> postMedia;

  final List<PostCategory> categories;
  final int likesCount;
  final int commentsCount;

  final Function(PostModel)? onEdit;
  final VoidCallback? onDelete;

  const PostItem({
    super.key,
    required this.post,
    required this.author,
    required this.timeAgo,
    required this.postText,
    required this.postMedia,
    required this.categories,
    required this.likesCount,
    required this.commentsCount,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  int _currentMediaIndex = 0;

  void _showPostOptions(BuildContext context, Offset globalPosition) {
    final latestPost = context.read<CommunityProvider>().posts.firstWhere(
      (p) => p.id == widget.post.id,
      orElse: () => widget.post,
    );

    MenuUtils.showContextMenu(
      context,
      globalPosition,
      onEdit: () async {
        final updatedPost = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatePostScreen(postToEdit: latestPost),
          ),
        );

        if (updatedPost != null &&
            updatedPost is PostModel &&
            context.mounted) {
          context.read<CommunityProvider>().updateLocalPost(updatedPost);
          context.read<UserProvider>().updatePostLocally(updatedPost);

          if (widget.onEdit != null) {
            widget.onEdit!(updatedPost);
          }
        }
      },
      onDelete: () {
        showDialog(
          context: context,
          builder: (dialogContext) {
            return CustomInfoDialog(
              title: context.l10n.deletePostTitle,
              description: context.l10n.deleteDialogMessage,
              confirmBtnText: context.l10n.deleteAction,
              mainColor: Colors.red,
              onConfirm: () async {
                final successMsg = context.l10n.postDeletedSuccessfully;
                final provider = context.read<CommunityProvider>();

                Navigator.pop(dialogContext);

                bool deleted = await provider.deletePost(widget.post);

                if (deleted && context.mounted) {
                  showSnackBar(context, successMsg, isError: false);
                }
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context, listen: false).user;
    final isMyPost =
        currentUser != null && widget.post.userId == currentUser.id;
    String finalSubtitle = widget.timeAgo;

    return Container(
      padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w, bottom: 8.h),
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==========================================
          // 🚀 واجهة جاري الرفع (شريط تحميل وشوية أنيميشن)
          // ==========================================
          if (widget.post.isUploading)
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        context.l10n.uploadingPost,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 12.w,
                        height: 12.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  LinearProgressIndicator(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ],
              ),
            ),

          // ==========================================
          // ❌ واجهة فشل الرفع (زرار إعادة وزرار مسح)
          // ==========================================
          if (widget.post.isUploadFailed)
            Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 20.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      context.l10n.uploadPostFailed,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // زرار الإعادة 🔄
                  IconButton(
                    icon: Icon(Icons.refresh, color: Colors.red, size: 24.sp),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: context.l10n.retryBtn,
                    onPressed: () {
                      context.read<CommunityProvider>().retryPostUpload(
                        widget.post,
                      );
                    },
                  ),
                  SizedBox(width: 16.w),
                  // زرار الإلغاء ✖️
                  IconButton(
                    icon: Icon(Icons.close, size: 20.sp),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: context.l10n.cancelUploadBtn,
                    onPressed: () {
                      context.read<CommunityProvider>().removeLocalPost(
                        widget.post.id,
                      );
                    },
                  ),
                ],
              ),
            ),

          PostUserHeader(
            user: widget.post.user,
            subtitle: finalSubtitle,
            onMoreTap: (isMyPost && !widget.post.isUploading)
                ? (offset) => _showPostOptions(context, offset)
                : null,
          ),

          SizedBox(height: 16.h),

          // نص البوست
          if (widget.postText.isNotEmpty) ...[
            SizedBox(
              width: double.infinity,
              child: ExpandableText(
                widget.postText,
                style: Theme.of(context).textTheme.bodyLarge,
                isArabic:
                    ArabicToEnglishNumbersFormatter.getTextDirection(
                      widget.postText,
                    ) ==
                    TextDirection.rtl,
              ),
            ),
            SizedBox(height: 12.h),
          ],

          // منطقة عرض الصور المتعددة (Carousel)
          if (widget.postMedia.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 280.h),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // الـ PageView عشان نقلب بين الصور
                    PageView.builder(
                      itemCount: widget.postMedia.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentMediaIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final media = widget.postMedia[index];
                        final isLocal = !media.url.startsWith('http');

                        // لو فيديو، هنعرض المشغل اللي لسه عاملينه
                        if (media.isVideo) {
                          return PostVideoPlayer(
                            videoUrl: media.url,
                            isLocal: isLocal,
                          );
                        }

                        // لو صوره اعرضها كامله عند الضغط
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FullScreenImageViewer(
                                  imageUrl: media.url,
                                  heroTag: 'image_${widget.post.id}_$index',
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: 'image_${widget.post.id}_$index',
                            child: isLocal
                                ? Image.file(File(media.url), fit: BoxFit.cover)
                                : SmartImageDisplay(
                                    path: media.url,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        );
                      },
                    ),

                    // النقط (Dots) بتظهر بس لو في أكتر من صورة
                    if (widget.postMedia.length > 1)
                      Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            widget.postMedia.length,
                            (index) => Container(
                              margin: EdgeInsets.symmetric(horizontal: 3.w),
                              width: _currentMediaIndex == index ? 8.r : 6.r,
                              height: _currentMediaIndex == index ? 8.r : 6.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentMediaIndex == index
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
          ],

          PostInteractionBar(
            postId: widget.post.id,
            likesCount: widget.post.likesCount,
            commentsCount: widget.post.commentsCount,
            isLiked: widget.post.isLiked,
          ),
        ],
      ),
    );
  }
}
