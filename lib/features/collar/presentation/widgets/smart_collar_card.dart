import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/core/widgets/smart_image_display.dart';
import 'package:rafiq/features/collar/presentation/widgets/unlink_button.dart';

class SmartCollarCard extends StatelessWidget {
  final Map<String, dynamic> collarData;
  final VoidCallback onTap;
  final VoidCallback onUnlink;

  const SmartCollarCard({
    super.key,
    required this.collarData,
    required this.onTap,
    required this.onUnlink,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: CustomContainer(
        padding: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.symmetric(
          horizontal: AppDimensions.padding,
          vertical: AppDimensions.paddingS,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================
            // 1. الجزء العلوي (صورة الطوق والبادج)
            // =====================================
            Container(
              height: 150.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.08),

                image: const DecorationImage(
                  image: AssetImage('assets/images/smart_collar.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // بادج "متصل - Connected"
                  Positioned.directional(
                    textDirection: Directionality.of(context),
                    top: 12.h,
                    start: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8.r,
                            height: 8.r,
                            decoration: const BoxDecoration(
                              color: Color(0xFF00C950),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Padding(
                            padding: EdgeInsets.only(top: 2.h),
                            child: Text(
                              context.l10n.connected,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // =====================================
            // 2. الجزء السفلي (البيانات وزرار الفك)
            // =====================================
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      // --------- بيانات الـ ID (شمال) ---------
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.collarIdLabel,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            collarData['id'] ?? '',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Spacer(),
                      // --------- بيانات الحيوان (يمين) ---------
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.linkedToLabel,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Text(
                                collarData['petName'],
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(width: 8.h),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.2),
                            width: 1.w,
                          ),
                        ),
                        child: SmartImageDisplay(
                          path:
                              (collarData['petImage'] != null &&
                                  collarData['petImage']
                                      .toString()
                                      .trim()
                                      .isNotEmpty)
                              ? collarData['petImage']
                              : "assets/images/pet_placeholder.png",
                          width: 44.r,
                          height: 44.r,
                          radius: 44.r,
                          iconSize: 16.r,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // --------- زرار الفك ---------
                  UnlinkButton(
                    btnHeight: 45.h,
                    iconSize: 18.sp,
                    fontSize: 14.sp,
                    onPressed: onUnlink,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
