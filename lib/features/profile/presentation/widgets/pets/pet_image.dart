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
    final String safeUrl = imageUrl?.trim() ?? '';

    Widget buildImage() {
      if (safeUrl.isEmpty) {
        return Image.asset(
          'assets/images/pet_placeholder.png',
          fit: BoxFit.cover,
        );
      }

      if (safeUrl.startsWith('http') || safeUrl.startsWith('https')) {
        return CachedNetworkImage(
          imageUrl: safeUrl,
          cacheKey: safeUrl.contains('?') ? safeUrl.split('?').first : safeUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: Colors.grey[200]),
          errorWidget: (context, url, error) => Image.asset(
            'assets/images/pet_placeholder.png',
            fit: BoxFit.cover,
          ),
        );
      }

      if (safeUrl.startsWith('assets')) {
        return Image.asset(safeUrl, fit: BoxFit.cover);
      }

      final file = File(safeUrl);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Image.asset(
            'assets/images/pet_placeholder.png',
            fit: BoxFit.cover,
          ),
        );
      }

      return Image.asset(
        'assets/images/pet_placeholder.png',
        fit: BoxFit.cover,
      );
    }

    return Container(
      width: finalSize,
      height: finalSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
      ),
      child: ClipOval(child: buildImage()),
    );
  }
}
