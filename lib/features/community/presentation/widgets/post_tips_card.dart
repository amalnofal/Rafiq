import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class PostTipsCard extends StatelessWidget {
  const PostTipsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "💡 ${AppLocalizations.of(context)!.postingTipsTitle}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 8.h),
          _buildTipItem(context, AppLocalizations.of(context)!.tipCategories),
          _buildTipItem(context, AppLocalizations.of(context)!.tipMoments),
          _buildTipItem(context, AppLocalizations.of(context)!.tipPhotos),
          _buildTipItem(context, AppLocalizations.of(context)!.tipRespect),
        ],
      ),
    );
  }

  Widget _buildTipItem(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "• ",
            style: Theme.of(
              context,
            ).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.labelSmall),
          ),
        ],
      ),
    );
  }
}
