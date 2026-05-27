import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';

class BattaryInfo extends StatelessWidget {
  final Map<String, dynamic> collarData;
  final bool useLightBg;

  const BattaryInfo({
    super.key,
    required this.collarData,
    this.useLightBg = false,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = useLightBg
        ? Theme.of(context).textTheme.bodyLarge
        : Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500);

    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset(
              "assets/icons/battery.svg",
              height: useLightBg ? 24.h : 20.h,
              width: useLightBg ? 24.h : 20.h,
            ),
            SizedBox(width: 8.w),
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(context.l10n.battery, style: textStyle),
            ),
            const Spacer(),
            Text("${collarData['battery']}%", style: textStyle),
          ],
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: LinearProgressIndicator(
            value: (collarData['battery'] ?? 0) / 100,
            minHeight: useLightBg ? 10.h : 8.h,
            backgroundColor: useLightBg
                ? const Color(0xFFF5F3ED)
                : Theme.of(context).colorScheme.onPrimary,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
