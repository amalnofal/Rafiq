import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';
import 'package:rafiq/features/profile/presentation/widgets/appointments/dialog_header.dart';

class AddReviewBottomSheet extends StatefulWidget {
  final Function(int rating, String comment) onSubmit;
  final int initialRating;
  final String initialComment;
  final bool isEdit;

  const AddReviewBottomSheet({
    super.key,
    required this.onSubmit,
    this.initialRating = 0,
    this.initialComment = '',
    this.isEdit = false,
  });

  @override
  State<AddReviewBottomSheet> createState() => _AddReviewBottomSheetState();
}

class _AddReviewBottomSheetState extends State<AddReviewBottomSheet> {
  late int _rating;
  late final TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
    _commentController = TextEditingController(text: widget.initialComment);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DialogHeader(
              title: widget.isEdit
                  ? context.l10n.editYourReview
                  : context.l10n.yourClinicReview,
            ),

            Padding(
              padding: EdgeInsets.all(24.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.selectRating,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _rating = index + 1;
                          });
                        },

                        child: SvgPicture.asset(
                          index < _rating
                              ? "assets/icons/star.svg"
                              : "assets/icons/unstar.svg",
                          width: 45.r,
                          height: 45.r,
                          colorFilter: ColorFilter.mode(
                            index < _rating
                                ? const Color(0xFFFDC700)
                                : Colors.grey[400]!,
                            BlendMode.srcIn,
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 24.h),

                  Text(
                    context.l10n.writeCommentOptional,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CustomTextField(
                    controller: _commentController,
                    maxLines: 4,
                    hintText: context.l10n.shareYourExperience,
                  ),
                  SizedBox(height: 16.h),

                  CustomButton(
                    title: widget.isEdit
                        ? context.l10n.save_changes
                        : context.l10n.submitReview,
                    height: 56.h,
                    fontWeight: FontWeight.w500,
                    onPressed: () {
                      if (_rating == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.l10n.pleaseSelectRatingFirst),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      widget.onSubmit(_rating, _commentController.text.trim());
                    },
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
