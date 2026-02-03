import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/core/widgets/stat_card.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class LatestMedicalRecordCard extends StatelessWidget {
  final String vaccineName;
  final String date;

  const LatestMedicalRecordCard({
    super.key,
    required this.vaccineName,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        children: [
          // العنوان (ثابت)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.latestHealthRecord,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SvgPicture.asset("assets/icons/vaccine.svg"),
            ],
          ),

          SizedBox(height: 12.h),

          // البطاقة الداخلية (التفاصيل المتغيرة)
          Card(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.paddingL),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 3. اسم التطعيم
                      Text(
                        vaccineName,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(height: 4.h),
                      // 4.  التاريخ
                      Text(
                        DateHelper.formatYearMonth(
                          DateTime(2025, 1, 15), //Last update date
                          context,
                        ),
                        // date,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                  // الحالة خليناها ثابتة "مكتمل" دلوقتي، وممكن نخليها متغيرة بعدين
                  StatCard(
                    title: AppLocalizations.of(context)!.recordCompleted,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
