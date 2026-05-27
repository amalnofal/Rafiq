import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/clinic_provider.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/clinics/data/models/clinic_model.dart';
import 'package:rafiq/features/clinics/presentation/widgets/add_review_bottom_sheet.dart';

class ClinicRatingCard extends StatelessWidget {
  final ClinicModel clinic;
  final bool isMe;
  final bool isDoctor;

  const ClinicRatingCard({
    super.key,
    required this.clinic,
    this.isMe = false,
    this.isDoctor = false,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<UserProvider>().user;
    final bool hasReviewed = clinic.reviews.any(
      (r) => r.reviewerId == currentUser?.id,
    );

    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: CustomContainer(
        margin: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [5, 4, 3, 2, 1].map((star) {
                      int count = clinic.reviews
                          .where((r) => r.rating.round() == star)
                          .length;

                      double percent = clinic.totalReviews > 0
                          ? (count / clinic.totalReviews)
                          : 0.0;

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Row(
                          children: [
                            Text(
                              "$star",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            SizedBox(width: 4.w),
                            SvgPicture.asset(
                              "assets/icons/star.svg",
                              width: 14.r,
                              height: 14.r,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFFFDC700),
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: LinearProgressIndicator(
                                  value: percent,
                                  backgroundColor: Colors.grey[300],
                                  color: const Color(0xFFFDC700),
                                  minHeight: 8.h,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            SizedBox(
                              width: 20.w,
                              child: Text(
                                "$count",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(width: 32.w),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        clinic.averageRating == 0
                            ? "0.0"
                            : clinic.averageRating.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 36.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return SvgPicture.asset(
                            index < clinic.averageRating.round()
                                ? "assets/icons/star.svg"
                                : "assets/icons/unstar.svg",
                            width: 16.r,
                            height: 16.r,
                            colorFilter: ColorFilter.mode(
                              index < clinic.averageRating.round()
                                  ? const Color(0xFFFDC700)
                                  : Colors.grey[400]!,
                              BlendMode.srcIn,
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        context.l10n.reviewsCount(clinic.totalReviews),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (!isMe && !isDoctor && !hasReviewed) ...[
              SizedBox(height: 24.h),
              CustomButton(
                title: context.l10n.addReview,
                height: 48.h,
                fontWeight: FontWeight.w500,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return AddReviewBottomSheet(
                        onSubmit: (rating, comment) async {
                          Navigator.pop(context);

                          if (clinic.id != 0) {
                            await context.read<ClinicProvider>().submitReview(
                              clinic.id,
                              rating.toDouble(),
                              comment,
                            );
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
