import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/medical_record_item.dart';

class LatestMedicalRecordCard extends StatelessWidget {
  final List<dynamic> records; 

  const LatestMedicalRecordCard({
    super.key,
    required this.records,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: EdgeInsets.all(AppDimensions.paddingS),
      child: Column(
        children: [
          // 1. العنوان (ثابت)
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

          // 2. البطاقات الداخلية (تترص تحت بعضها)
          if (records.isEmpty)
            const MedicalRecordItem(vaccineName: "", date: "")
          else
            ...records.map((rec) {
              final dateStr = "${rec['date'] ?? ''} ${rec['time'] ?? ''}".trim();
              return MedicalRecordItem(
                vaccineName: rec['visitReason']?.toString() ?? "",
                date: dateStr,
              );
            }),
        ],
      ),
    );
  }
}