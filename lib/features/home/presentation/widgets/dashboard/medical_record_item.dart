import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class MedicalRecordItem extends StatelessWidget {
  final String vaccineName;
  final String date;

  const MedicalRecordItem({
    super.key,
    required this.vaccineName,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEmptyRecord = date.trim().isEmpty || date == "--/--/----";
    final l10n = AppLocalizations.of(context)!;
    final displayVaccineName = vaccineName.isEmpty ? l10n.noHealthRecord : vaccineName;

    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingL),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayVaccineName,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (!isEmptyRecord) ...[
                  SizedBox(height: 4.h),
                  Text(
                    date,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}