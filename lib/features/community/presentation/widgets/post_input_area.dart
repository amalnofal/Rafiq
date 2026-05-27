import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/core/helper/image_picker_helper.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/smart_image_display.dart';
import 'package:rafiq/features/community/data/models/post_model.dart';
import 'package:rafiq/features/community/presentation/widgets/post_video_player.dart';

class PostInputArea extends StatelessWidget {
  final TextEditingController controller;

  final List<File> selectedImages;
  final List<PostMedia> existingMedia;

  final ValueChanged<File> onImageAdded;
  final Function(int index) onNewImageRemoved;
  final Function(int index) onExistingImageRemoved;

  const PostInputArea({
    super.key,
    required this.controller,
    required this.selectedImages,
    required this.existingMedia,
    required this.onImageAdded,
    required this.onNewImageRemoved,
    required this.onExistingImageRemoved,
  });

  @override
  Widget build(BuildContext context) {
    bool hasAnyMedia = selectedImages.isNotEmpty || existingMedia.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. حقل النص
          TextField(
            controller: controller,
            maxLines: 5,
            minLines: 3,
            decoration: InputDecoration(
              hintText: context.l10n.shareMomentHint,
              hintStyle: Theme.of(context).textTheme.labelMedium,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),

          SizedBox(height: 8.h),

          // 2. منطقة عرض الميديا (شريط أفقي)
          if (hasAnyMedia) ...[
            SizedBox(
              height: 100.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  // أ. الصور والفيديوهات القديمة (الجاية من السيرفر)
                  ...existingMedia.asMap().entries.map((entry) {
                    int index = entry.key;
                    PostMedia media = entry.value;
                    return _buildMediaItem(
                      context,
                      // 🚨 الـ Key السحري لمنع لخبطة المسح
                      key: ValueKey('existing_${media.id}'),
                      isNetwork: true,
                      path: media.url,
                      isMediaVideo: media.isVideo,
                      onRemove: () => onExistingImageRemoved(index),
                    );
                  }),

                  // ب. الصور والفيديوهات الجديدة (من الجهاز)
                  ...selectedImages.asMap().entries.map((entry) {
                    int index = entry.key;
                    File file = entry.value;

                    final pathLower = file.path.toLowerCase();
                    bool isNewVideo =
                        pathLower.endsWith('.mp4') ||
                        pathLower.endsWith('.mov') ||
                        pathLower.endsWith('.avi');

                    return _buildMediaItem(
                      context,
                      key: ValueKey('new_${file.path}'),
                      isNetwork: false,
                      path: file.path,
                      isMediaVideo: isNewVideo,
                      onRemove: () => onNewImageRemoved(index),
                    );
                  }),

                  // ج. زر إضافة المزيد
                  _buildAddMoreButton(context),
                ],
              ),
            ),
          ] else ...[
            // زر إضافة ميديا لأول مرة
            _buildInitialAddButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildInitialAddButton(BuildContext context) {
    return InkWell(
      onTap: () {
        ImagePickerHelper.showOptionSheet(context, (file) {
          onImageAdded(file);
        }, allowVideo: true);
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset("assets/icons/camera.svg", height: 20.h),
            SizedBox(width: 8.w),
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Text(
                context.l10n.addMedia,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaItem(
    BuildContext context, {
    required Key key,
    required bool isNetwork,
    required String path,
    required bool isMediaVideo,
    required VoidCallback onRemove,
  }) {
    return Container(
      key: key,
      width: 100.h,
      margin: EdgeInsets.only(right: 8.w),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: SizedBox(
              width: 100.h,
              height: 100.h,
              child: isMediaVideo
                  ? PostVideoPlayer(
                      videoUrl: path,
                      isLocal: !isNetwork,
                      isPreview: true,
                    )
                  : (isNetwork
                        ? SmartImageDisplay(
                            path: path,
                            fit: BoxFit.cover,
                            radius: 0,
                          )
                        : Image.file(File(path), fit: BoxFit.cover)),
            ),
          ),
          Positioned(
            top: 4.h,
            right: 4.w,
            child: InkWell(
              onTap: onRemove,
              child: Container(
                padding: EdgeInsets.all(4.r),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.white, size: 16.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMoreButton(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(left: 4.w),
        child: InkWell(
          onTap: () {
            ImagePickerHelper.showOptionSheet(context, (file) {
              onImageAdded(file);
            }, allowVideo: true);
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset("assets/icons/camera.svg", height: 20.h),
                SizedBox(width: 8.w),
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Text(
                    context.l10n.addMedia,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
