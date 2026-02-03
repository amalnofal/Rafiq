import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<void> _pickImage(
    ImageSource source,
    Function(File) onImagePicked,
  ) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        onImagePicked(File(image.path));
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  static void showOptionSheet(
    BuildContext context,
    Function(File) onImagePicked,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(AppLocalizations.of(context)!.gallery),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery, onImagePicked);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(AppLocalizations.of(context)!.camera),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera, onImagePicked);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
