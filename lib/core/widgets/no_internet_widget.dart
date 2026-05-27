import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoInternetWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    // شيلنا الـ Scaffold عشان نعرضه جوه الـ Body بتاع أي صفحة
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة الواي فاي المقطوع
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.wifi_off_rounded, size: 80.w, color: Colors.grey[400]),
            ),
            SizedBox(height: 32.h),
            Text(
              'لا يوجد اتصال بالإنترنت',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            Text(
              'تأكد من اتصالك بالشبكة ثم قم بتحديث الصفحة.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: 150.w,
              height: 45.h,
              child: ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
                ),
                child: Text('تحديث', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}