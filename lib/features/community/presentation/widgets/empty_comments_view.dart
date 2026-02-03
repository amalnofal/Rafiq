import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class EmptyCommentsView extends StatelessWidget {
  const EmptyCommentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/icons/comment.svg",
            height: 30.h,
            colorFilter: ColorFilter.mode(
              Theme.of(context).textTheme.labelMedium!.color!,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            AppLocalizations.of(context)!.firstCommentPlaceholder,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}