import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class ImageUploadCard extends StatelessWidget {
  final String? label; // النص اللي فوق (اختياري)
  final File? imageFile; // ملف الصورة
  final VoidCallback onTap; // عند الضغط
  final VoidCallback? onRemove; // زر حذف للصورة (مفيد للبوستات)
  final bool showError; // لو فيه خطأ
  final String? hintText; // النص اللي جوه المربع

  const ImageUploadCard({
    super.key,
    this.label,
    required this.imageFile,
    required this.onTap,
    this.onRemove,
    this.showError = false,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
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
                height: 150.h,
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
                child: imageFile == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.file_upload_outlined,
                            size: 32.sp,
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            hintText ??
                                AppLocalizations.of(
                                  context,
                                )!.uploadIdText, // نص افتراضي
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      )
                    : null,
              ),
            ),

            // زر الحذف (يظهر فقط لو فيه صورة وفيه دالة حذف)
            if (imageFile != null && onRemove != null)
              Positioned(
                top: 8.h,
                right: 8.w,
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
