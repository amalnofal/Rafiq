import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class ImageUploadCard extends StatelessWidget {
  final String? label;
  final File? imageFile;
  final String? imageUrl;
  final VoidCallback onTap;
  final VoidCallback? onRemove;
  final bool showError;
  final String? hintText;
  final double? height;

  const ImageUploadCard({
    super.key,
    this.label,
    required this.imageFile,
    this.imageUrl,
    required this.onTap,
    this.onRemove,
    this.showError = false,
    this.hintText,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImage =
        imageFile != null || (imageUrl != null && imageUrl!.isNotEmpty);
    // تحديد لون الحدود
    Color borderColor;
    if (showError) {
      borderColor = Colors.red;
    } else if (imageFile != null) {
      borderColor = Theme.of(context).primaryColor;
    } else {
      borderColor = Theme.of(context).colorScheme.outline;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. العنوان (اختياري)
        if (label != null) ...[
          Text(label!, style: Theme.of(context).textTheme.bodyMedium),
          SizedBox(height: 10.h),
        ],

        // 2. منطقة الرفع
        Stack(
          children: [
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                height: height ?? 150.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: borderColor, width: 1.5),
                  image: imageFile != null
                      ? DecorationImage(
                          image: FileImage(imageFile!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: hasImage
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: imageFile != null
                            ? Image.file(
                                imageFile!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : CachedNetworkImage(
                                imageUrl: imageUrl!,
                                cacheKey: imageUrl!.split('?').first,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                placeholder: (context, url) =>
                                    Container(color: Colors.grey[100]),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.file_upload_outlined,
                            size: 32.sp,
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            hintText ?? context.l10n.uploadIdText,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
              ),
            ),

            // زر الحذف (يظهر فقط لو فيه صورة وفيه دالة حذف)
            if (hasImage && onRemove != null)
              PositionedDirectional(
                top: 8.h,
                end: 8.w,
                child: InkWell(
                  onTap: onRemove,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 16.sp),
                  ),
                ),
              ),
          ],
        ),

        // رسالة الخطأ
        if (showError)
          Padding(
            padding: EdgeInsets.only(top: 6.h, right: 4.w),
            child: Text(
              AppLocalizations.of(context)!.fieldRequired,
              style: TextStyle(color: Colors.red, fontSize: 12.sp),
            ),
          ),
      ],
    );
  }
}
