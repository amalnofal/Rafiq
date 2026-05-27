import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/collar/presentation/widgets/battary_info.dart';
import 'package:rafiq/features/collar/presentation/widgets/last_sync_card.dart';

class CollarStateCard extends StatelessWidget {
  final Map<String, dynamic> collarData;
  const CollarStateCard({super.key, required this.collarData});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: EdgeInsets.all(AppDimensions.paddingS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.deviceStatus,
            style: Theme.of(context).textTheme.bodyLarge!,
          ),
          SizedBox(height: 16.h),
          BattaryInfo(collarData: collarData, useLightBg: true),
          SizedBox(height: 8.h),
          Text(
            "يتبقى حوالي 4 أيام",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          SizedBox(height: 12.h),
          LastSyncCard(collarData: collarData),
        ],
      ),
    );
  }
}
