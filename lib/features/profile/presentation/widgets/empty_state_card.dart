import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyStateCard extends StatelessWidget {
  final String message;

  const EmptyStateCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32.h),
        child: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
