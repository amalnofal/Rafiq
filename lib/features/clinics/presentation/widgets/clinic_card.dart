import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/core/widgets/smart_image_display.dart';
import 'package:rafiq/features/clinics/data/models/clinic_model.dart';
import 'package:rafiq/features/clinics/presentation/widgets/clinic_action_buttons.dart';
import 'package:rafiq/features/profile/presentation/widgets/icon_text_row.dart';

class ClinicCard extends StatelessWidget {
  final ClinicModel clinic;
  final VoidCallback onTap;

  const ClinicCard({super.key, required this.clinic, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: CustomContainer(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            //  1. صورة العيادة فوق
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppDimensions.radius),
              ),
              child: SizedBox(
                height: 150.h,
                width: double.infinity,
                child: (clinic.imageUrl != null && clinic.imageUrl!.isNotEmpty)
                    ? SmartImageDisplay(
                        path: clinic.imageUrl!,
                        height: 150.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        radius: 0,
                      )
                    : Container(color: const Color(0xffDEDFE1)),
              ),
            ),

            // 2. تفاصيل العيادة
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clinic.name,
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),

                  // التقييم
                  Row(
                    children: [
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: SvgPicture.asset(
                          "assets/icons/star.svg",
                          width: 14.r,
                          height: 14.r,
                          colorFilter: ColorFilter.mode(
                            Color(0xFFFDC700),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        clinic.averageRating == 0
                            ? "0.0"
                            : clinic.averageRating.toStringAsFixed(1),
                        style: theme.textTheme.labelMedium,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "(${context.l10n.reviewsCount(clinic.totalReviews)})",
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  // العنوان والمواعيد والتخصص
                  IconTextRow(
                    iconPath: "assets/icons/location.svg",
                    text: clinic.address,
                  ),
                  SizedBox(height: 6.h),
                  IconTextRow(
                    iconPath: "assets/icons/clock.svg",
                    text: clinic.workingHours,
                  ),
                  SizedBox(height: 6.h),
                  IconTextRow(
                    iconPath: "assets/icons/clinics.svg",
                    text: clinic.specialization,
                  ),

                  SizedBox(height: 16.h),

                  // 3. زراير الأكشن
                  ClinicActionButtons(clinic: clinic),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
