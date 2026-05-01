import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/clinic_provider.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/core/helper/dialog_helper.dart';
import 'package:rafiq/core/helper/menu_utils.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/clinics/data/models/clinic_model.dart';
import 'package:rafiq/features/clinics/presentation/widgets/add_review_bottom_sheet.dart';

class ClinicReviewsList extends StatefulWidget {
  final ClinicModel clinic;

  const ClinicReviewsList({super.key, required this.clinic});

  @override
  State<ClinicReviewsList> createState() => _ClinicReviewsListState();
}

class _ClinicReviewsListState extends State<ClinicReviewsList> {
  Offset _tapPosition = Offset.zero;

  void _getTapPosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.clinic.reviews.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      itemCount: widget.clinic.reviews.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final review = widget.clinic.reviews[index];
        final bool isMyReview = review.isOwner;

        // تنسيق الوقت (منذ أسبوع مثلاً)
        String formattedTime = review.timeAgo;
        DateTime? parsedDate = DateTime.tryParse(review.timeAgo);
        if (parsedDate != null) {
          formattedTime = DateHelper.timeAgo(parsedDate, context);
        }

        return CustomContainer(
          margin: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. الصورة الشخصية
                  CircleAvatar(
                    radius: 26.r,
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                        (review.userImageUrl != null &&
                            review.userImageUrl!.isNotEmpty)
                        ? CachedNetworkImageProvider(
                                review.userImageUrl!,
                                cacheKey: review.userImageUrl!.split('?').first,
                              )
                              as ImageProvider
                        : const AssetImage(
                            'assets/images/user_placeholder.jpg',
                          ),
                  ),
                  SizedBox(width: 12.w),

                  // 2. الاسم والنجوم
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            review.userName,
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "• $formattedTime",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: List.generate(5, (starIndex) {
                          return SvgPicture.asset(
                            starIndex < review.rating.round()
                                ? "assets/icons/star.svg"
                                : "assets/icons/unstar.svg",
                            width: 15.r,
                            height: 15.r,
                            colorFilter: ColorFilter.mode(
                              starIndex < review.rating.round()
                                  ? Color(0xFFFDC700)
                                  : Colors.grey[300]!,
                              BlendMode.srcIn,
                            ),
                          );

                          //  Icon(
                          //   starIndex < review.rating.round()
                          //       ? Icons.star
                          //       : Icons.star_border,
                          //   color: starIndex < review.rating.round()
                          //       ? Colors.amber
                          //       : Colors.grey[300],
                          //   size: 16.r,
                          // );
                        }),
                      ),
                    ],
                  ),

                  Spacer(),

                  // 3. المنيو والوقت (أقصى الشمال)
                  if (isMyReview) ...[
                    SizedBox(width: 4.w),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: _getTapPosition,
                      onTap: () {
                        MenuUtils.showContextMenu(
                          context,
                          _tapPosition,
                          onEdit: () {
                            _showEditReviewSheet(context, review);
                          },
                          onDelete: () => _confirmDelete(context, review.id),
                        );
                      },
                      child: Icon(Icons.more_vert, size: 20.r),
                    ),
                  ],
                ],
              ),

              // 4. التعليق
              if (review.comment.isNotEmpty)
                Padding(
                  padding: EdgeInsetsDirectional.only(top: 4.h, start: 64.w),
                  child: Text(
                    review.comment,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // دالة تعديل التقييم
  void _showEditReviewSheet(BuildContext context, ReviewModel review) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddReviewBottomSheet(
        initialRating: review.rating.toInt(),
        initialComment: review.comment,
        isEdit: true,
        onSubmit: (rating, comment) async {
          Navigator.pop(ctx);
          await context.read<ClinicProvider>().updateReview(
            review.id,
            int.parse(widget.clinic.id),
            rating.toDouble(),
            comment,
          );
        },
      ),
    );
  }

  // دالة حذف التقييم
  void _confirmDelete(BuildContext context, int reviewId) {
    showDialog(
      context: context,
      builder: (ctx) => CustomInfoDialog(
        title: "حذف التقييم",
        description: "هل أنت متأكد من حذف هذا التقييم؟ لا يمكن التراجع عن ذلك.",
        confirmBtnText: "حذف",
        onConfirm: () async {
          Navigator.pop(ctx);
          if (!mounted) return;
          await context.read<ClinicProvider>().deleteReview(
            reviewId,
            int.parse(widget.clinic.id),
          );
        },
      ),
    );
  }
}
