import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.arrow_back,
          size: AppDimensions.iconM,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
    );
  }
}
