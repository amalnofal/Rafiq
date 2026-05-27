import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/features/clinics/data/models/clinic_model.dart';
import 'package:rafiq/features/profile/presentation/widgets/icon_text_row.dart';

class ClinicInfo extends StatelessWidget {
  final ClinicModel clinic;
  const ClinicInfo({super.key, required this.clinic});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // العنوان والمواعيد والتخصص
        IconTextRow(
          iconPath: "assets/icons/location.svg",
          text: clinic.address,
        ),
        SizedBox(height: 6.h),

        IconTextRow(
          iconPath: "assets/icons/clock.svg",
          text:
              "${DateHelper.formatWorkingDays(clinic.workingDays, context)} "
              "(${DateHelper.formatWorkingHours(clinic.openingTime, clinic.closingTime, context)})",
        ),

        SizedBox(height: 6.h),
        IconTextRow(
          iconPath: "assets/icons/clinics.svg",
          text: clinic.specialization,
        ),
      ],
    );
  }
}
