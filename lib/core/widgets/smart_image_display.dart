import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SmartImageDisplay extends StatelessWidget {
  final String path;
  final double? height;
  final double radius;
  final BoxFit fit;

  const SmartImageDisplay({
    super.key,
    required this.path,
    this.height,
    this.radius = 16,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    bool isNetwork = path.startsWith('http') || path.startsWith('https');

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius.r),
      child: SizedBox(
        height: 250.h,
        width: double.infinity,
        child: isNetwork
            ? Image.network(
                path,
                fit: fit,
                errorBuilder: (context, error, stackTrace) =>
                    _buildErrorState(),
              )
            : Image.file(
                File(path),
                fit: fit,
                errorBuilder: (context, error, stackTrace) =>
                    _buildErrorState(),
              ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      color: Colors.grey[200],
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }
}
