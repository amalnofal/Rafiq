import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/collar/presentation/widgets/battary_info.dart';

class SmartCollarCard extends StatelessWidget {
  final Map<String, dynamic> collarData;
  final VoidCallback onTap;

  const SmartCollarCard({
    super.key,
    required this.collarData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.padding,
        vertical: AppDimensions.paddingS,
      ),
      child: Column(
        children: [
          // 1. الجزء العلوي (الصورة، الاسم، الموديل، حالة الاتصال)
          Row(
            children: [
              // صورة الحيوان
              CircleAvatar(
                radius: 26.r,
                backgroundColor: Colors.grey[200],
                backgroundImage: AssetImage(collarData['petImage']),
              ),
              SizedBox(width: 12.w),

              // الاسم والموديل
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 2.h),
                          child: Text(
                            collarData['petName'],
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        // نقطة الاتصال الخضراء
                        if (collarData['isConnected'])
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFF00C950),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    Text(
                      collarData['model'],
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // 2. مؤشر البطارية
          Card(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.paddingM),
              child: BattaryInfo(collarData: collarData),
            ),
          ),

          SizedBox(height: 16.h),

          // 3. آخر مزامنة ورقم الطوق
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${context.l10n.lastSync} ${collarData['lastSync']}",
                style: Theme.of(context).textTheme.labelSmall,
              ),
              Text(
                collarData['id'],
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),

          SizedBox(height: 16.h),

          CustomButton(
            title: context.l10n.viewDetailedStatistics,
            onPressed: onTap,
            height: 48.h,
            elevation: 0,
          ),
        ],
      ),
    );
  }
}
