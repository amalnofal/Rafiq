import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/clinics/data/models/clinic_model.dart';
import 'package:rafiq/features/clinics/presentation/widgets/clinic_action_buttons.dart';
import 'package:rafiq/features/profile/presentation/widgets/icon_text_row.dart';

class ClinicInfoCard extends StatelessWidget {
  final ClinicModel currentClinic;
  final dynamic currentUser;
  final bool isMe;

  const ClinicInfoCard({
    super.key,
    required this.currentClinic,
    required this.currentUser,
    this.isMe = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(top: 90.h),
      child: CustomContainer(
        margin: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentClinic.name,
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 12.h),
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
                  currentClinic.averageRating == 0
                      ? "0.0"
                      : currentClinic.averageRating.toStringAsFixed(1),
                  style: theme.textTheme.labelMedium,
                ),
                SizedBox(width: 8.w),
                Text(
                  "(${context.l10n.reviewsCount(currentClinic.totalReviews)})",
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
            SizedBox(height: 12.h),

            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(3.r),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      width: 1.5,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 28.r,
                    backgroundColor: Colors.grey[100],
                    backgroundImage:
                        currentClinic.doctorProfilePhotoUrl != null &&
                            currentClinic.doctorProfilePhotoUrl!.isNotEmpty
                        ? CachedNetworkImageProvider(
                            currentClinic.doctorProfilePhotoUrl!,
                            cacheKey:
                                currentClinic.doctorProfilePhotoUrl!.contains(
                                  '?',
                                )
                                ? currentClinic.doctorProfilePhotoUrl!
                                      .split('?')
                                      .first
                                : currentClinic.doctorProfilePhotoUrl!,
                          )
                        : const AssetImage('assets/images/user_placeholder.jpg')
                              as ImageProvider,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentClinic.doctorName ?? "Rafiq Vet",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${currentClinic.doctorSpecialization ?? ""} . ${currentClinic.doctorSubSpecialization ?? ""}',
                        style: theme.textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Divider(),
            ),

            if (currentClinic.description != null &&
                currentClinic.description!.isNotEmpty) ...[
              Text(
                currentClinic.description!,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
              ),
              SizedBox(height: 16.h),
            ],

            IconTextRow(
              iconPath: "assets/icons/location.svg",
              text: currentClinic.address,
            ),
            SizedBox(height: 12.h),
            IconTextRow(
              iconPath: "assets/icons/clock.svg",
              text: currentClinic.workingHours,
            ),
            SizedBox(height: 12.h),
            IconTextRow(
              iconPath: "assets/icons/clinics.svg",
              text: currentClinic.specialization,
            ),
            SizedBox(height: 16.h),

            // أزرار الاتصال والحجز
            ClinicActionButtons(clinic: currentClinic),
          ],
        ),
      ),
    );
  }
}
