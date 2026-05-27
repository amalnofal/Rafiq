import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CommentShimmerItem extends StatelessWidget {
  const CommentShimmerItem({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 20.r, backgroundColor: Colors.white),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 120.w, height: 14.h, color: Colors.white),
                  SizedBox(height: 8.h),
                  Container(
                    width: double.infinity,
                    height: 12.h,
                    color: Colors.white,
                  ),
                  SizedBox(height: 4.h),
                  Container(width: 180.w, height: 12.h, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
