import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/widgets/custom_button.dart';

class NoInternetWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: 80.w,
                color: Theme.of(context).colorScheme.onTertiary,
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              'لا يوجد اتصال بالإنترنت',
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 12.h),
            Text(
              'تأكد من اتصالك بالشبكة ثم قم بتحديث الصفحة.',
              style: Theme.of(
                context,
              ).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 32.h),
            CustomButton(title: 'تحديث'),
          ],
        ),
      ),
    );
  }
}
