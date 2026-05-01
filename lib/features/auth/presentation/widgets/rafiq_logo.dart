import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';

class RafiqLogo extends StatelessWidget {
  const RafiqLogo({super.key, required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.all(AppDimensions.padding),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          ),
          color: Theme.of(context).colorScheme.primary,
          child: Image.asset("assets/icons/rafiq_logo.png", height: 90.h),
        ),
        Text(title, style: Theme.of(context).textTheme.headlineLarge),
        SizedBox(height: 20.h),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.labelMedium,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
      ],
    );
  }
}
