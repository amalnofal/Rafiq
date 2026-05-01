import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostPreviewItem extends StatelessWidget {
  final int index;
  // مستقبلاً سنمرر موديل البوست الحقيقي هنا
  // final PostModel post; 

  const PostPreviewItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    // داتا وهمية للتيست حالياً
    final bool hasImage = index % 2 == 0; 

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        image: hasImage
            ? const DecorationImage(
                image: NetworkImage("https://picsum.photos/200"),
                fit: BoxFit.cover,
              )
            : null,
        color: hasImage ? null : const Color(0xFFF5F5F5),
      ),
      child: hasImage
          ? _buildImageOverlay()
          : _buildTextContent(),
    );
  }

  Widget _buildImageOverlay() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            const Icon(Icons.favorite_border, color: Colors.white, size: 14),
            Text(
              " 12",
              style: TextStyle(color: Colors.white, fontSize: 10.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Center(
        child: Text(
          "نصيحة اليوم: اهتم بتطعيمات...",
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 10.sp, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}