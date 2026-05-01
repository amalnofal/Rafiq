import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class IconTextRow extends StatelessWidget {
  final String iconPath;
  final String text;

  const IconTextRow({super.key, required this.iconPath, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: SvgPicture.asset(
            iconPath,
            width: 16.w,
            height: 16.h,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
        ),
        SizedBox(width: 6.w),

        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
