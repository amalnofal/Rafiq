import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  // دالة خاصة بالصور فقط
  static Future<void> _pickImage(
    BuildContext context,
    ImageSource source,
    Function(File) onFilePicked,
  ) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);

      if (!context.mounted) return;

      if (image != null) {
        _checkFileSizeAndReturn(context, File(image.path), onFilePicked);
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  // دالة اختيار الميديا (صور + فيديوهات) للبوستات
  static Future<void> _pickMedia(
    BuildContext context,
    Function(File) onFilePicked,
  ) async {
    try {
      final XFile? media = await _picker.pickMedia();

      if (!context.mounted) return;
      if (media != null) {
        _checkFileSizeAndReturn(context, File(media.path), onFilePicked);
      }
    } catch (e) {
      debugPrint("Error picking media: $e");
    }
  }

  // ==========================================
  // دالة فحص حجم الملف
  // ==========================================
  static void _checkFileSizeAndReturn(
    BuildContext context,
    File file,
    Function(File) onFilePicked,
  ) {
    // حساب الحجم بالميجابايت
    final double fileSizeInMB = file.lengthSync() / (1024 * 1024);

    if (fileSizeInMB > 30) {
      // لو أكبر من 30 ميجا، نرفض الملف ونطلع رسالة للمستخدم
      showSnackBar(context, context.l10n.fileTooLarge, isError: true);
    } else {
      // لو الحجم تمام، نكمل الإجراء ونرجعه للشاشة
      onFilePicked(file);
    }
  }

  static void showOptionSheet(
    BuildContext context,
    Function(File) onFilePicked, {
    bool allowVideo = false,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(context.l10n.gallery),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  if (allowVideo) {
                    _pickMedia(context, onFilePicked);
                  } else {
                    _pickImage(context, ImageSource.gallery, onFilePicked);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(context.l10n.camera),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _pickImage(context, ImageSource.camera, onFilePicked);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
