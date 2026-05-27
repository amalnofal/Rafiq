import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';

class LastSyncCard extends StatelessWidget {
  final Map<String, dynamic> collarData;
  const LastSyncCard({super.key, required this.collarData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.padding),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: SvgPicture.asset(
                "assets/icons/reload.svg",
                height: 20.h,
                width: 20.h,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              context.l10n.lastSync,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Spacer(),
            Text(
              collarData['lastSync'],
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
