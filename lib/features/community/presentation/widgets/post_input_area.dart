import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/core/helper/image_picker_helper.dart';
import 'package:rafiq/core/widgets/smart_image_display.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class PostInputArea extends StatelessWidget {
  final TextEditingController controller;
  final File? selectedImage;
  final String? existingImageUrl;

  final ValueChanged<File> onImageSelected;
  final VoidCallback onImageRemoved;

  const PostInputArea({
    super.key,
    required this.controller,
    required this.selectedImage,
    this.existingImageUrl,
    required this.onImageSelected,
    required this.onImageRemoved,
  });

  @override
  Widget build(BuildContext context) {
    bool hasImage =
        selectedImage != null ||
        (existingImageUrl != null && existingImageUrl!.isNotEmpty);

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
              hintText: AppLocalizations.of(context)!.shareMomentHint,
              hintStyle: Theme.of(context).textTheme.labelMedium,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),

          SizedBox(height: 8.h),
          
          // 2. منطقة الصورة الموحدة
          if (hasImage) ...[
            SizedBox(height: 8.h),
            Stack(
              children: [
                // الصورة (سواء ملف أو رابط)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: SizedBox(
                    width: double.infinity,
                    height: 200.h,
                    child: selectedImage != null
                        ? Image.file(selectedImage!, fit: BoxFit.cover)
                        : SmartImageDisplay(
                            path: existingImageUrl!,
                            fit: BoxFit.cover,
                            radius: 0,
                          ),
                  ),
                ),

                // زر الحذف
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: InkWell(
                    onTap: onImageRemoved,
                    child: Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            // زر إضافة صورة
            InkWell(
              onTap: () {
                ImagePickerHelper.showOptionSheet(context, (file) {
                  onImageSelected(file);
                });
              },
              borderRadius: BorderRadius.circular(8.r),
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
                        AppLocalizations.of(context)!.addPhotoLabel,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
