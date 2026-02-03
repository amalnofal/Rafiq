import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class CreatePostTrigger extends StatelessWidget {
  const CreatePostTrigger({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      width: double.infinity,
      padding: EdgeInsets.only(
        right: AppDimensions.padding,
        left: AppDimensions.padding,
        top: 35.h,
        bottom: AppDimensions.padding,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(AppDimensions.padding),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            children: [
              Text(
                AppLocalizations.of(context)!.postContentHint,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
