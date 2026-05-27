import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PetImage extends StatelessWidget {
  final String? imageUrl;
  final double? size;

  const PetImage({super.key, required this.imageUrl, this.size});

  @override
  Widget build(BuildContext context) {
    final double finalSize = size ?? 55.r;

    ImageProvider imageProvider;

    // تحديد نوع الصورة (رابط، ملف محلي، أو Asset)
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      if (imageUrl!.startsWith('http') || imageUrl!.startsWith('https')) {
        imageProvider = CachedNetworkImageProvider(
          imageUrl!,
          cacheKey: imageUrl!.contains('?')
              ? imageUrl!.split('?').first
              : imageUrl!,
        );
      } else if (imageUrl!.startsWith('assets')) {
        imageProvider = AssetImage(imageUrl!);
      } else {
        imageProvider = FileImage(File(imageUrl!));
      }
    } else {
      // الـ Placeholder الافتراضي لو مفيش صورة خالص
      imageProvider = const AssetImage('assets/images/pet_placeholder.png');
    }

    return Container(
      width: finalSize,
      height: finalSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200], 
        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
      ),
    );
  }
}
