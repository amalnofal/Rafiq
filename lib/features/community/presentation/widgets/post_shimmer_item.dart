import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class PostShimmerItem extends StatelessWidget {
  const PostShimmerItem({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      margin: EdgeInsets.only(bottom: 8.h),
      color: Theme.of(context).cardColor,
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الهيدر (صورة اليوزر واسمه)
            Row(
              children: [
                CircleAvatar(radius: 20.r, backgroundColor: Colors.white),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 120.w, height: 12.h, color: Colors.white),
                    SizedBox(height: 6.h),
                    Container(width: 80.w, height: 10.h, color: Colors.white),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // النص
            Container(width: double.infinity, height: 12.h, color: Colors.white),
            SizedBox(height: 6.h),
            Container(width: 200.w, height: 12.h, color: Colors.white),
            SizedBox(height: 16.h),
            // صورة البوست
            Container(width: double.infinity, height: 200.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r))),
          ],
        ),
      ),
    );
  }
}