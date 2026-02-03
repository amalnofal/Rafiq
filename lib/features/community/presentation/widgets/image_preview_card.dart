import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/widgets/smart_image_display.dart';

class ImagePreviewCard extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onRemove;

  const ImagePreviewCard({
    super.key,
    required this.imageUrl,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Stack(
        children: [
          SmartImageDisplay(
            path: imageUrl,
            height: 200.h,
            radius: 12,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 8,
            right: 8,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              radius: 16.r,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.close, color: Colors.white, size: 20.sp),
                onPressed: onRemove,
              ),
            ),
          ),
        ],
      ),
    );
  }
}