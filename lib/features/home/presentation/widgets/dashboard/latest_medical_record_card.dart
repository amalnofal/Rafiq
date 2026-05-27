import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/medical_record_item.dart';

class LatestMedicalRecordCard extends StatelessWidget {
  final List<dynamic> records;
  final bool showOnlyLatest;

  const LatestMedicalRecordCard({
    super.key,
    required this.records,
    this.showOnlyLatest = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: EdgeInsets.all(AppDimensions.paddingS),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.latestHealthRecord,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SvgPicture.asset("assets/icons/vaccine.svg"),
            ],
          ),
          SizedBox(height: 12.h),
          if (records.isEmpty)
            const MedicalRecordItem(vaccineName: "", date: "")
          else if (showOnlyLatest)
            MedicalRecordItem(
              vaccineName: records.first['visitReason']?.toString() ?? "",
              date: DateHelper.formatRecordDateAndTime(records.first, context),
            )
          else
            ...records.map((rec) {
              return MedicalRecordItem(
                vaccineName: rec['visitReason']?.toString() ?? "",
                date: DateHelper.formatRecordDateAndTime(rec, context),
              );
            }),
        ],
      ),
    );
  }
}
