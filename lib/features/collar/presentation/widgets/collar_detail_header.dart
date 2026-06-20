import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/smart_image_display.dart';

class CollarDetailHeader extends StatelessWidget {
  final Map<String, dynamic> collarData;
  final VoidCallback onBackTap;

  const CollarDetailHeader({
    super.key,
    required this.collarData,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final String rawLastSync = collarData['lastSync']?.toString() ?? '';
    String displayLastSync = rawLastSync;
    if (rawLastSync.isNotEmpty) {
      final parsedDate = DateTime.tryParse(rawLastSync);
      if (parsedDate != null) {
        displayLastSync = DateHelper.timeAgo(parsedDate, context);
      }
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10.h,
        left: 8.w,
        right: 8.w,
        bottom: 25.h,
      ),
      decoration: BoxDecoration(
        boxShadow: isDarkMode
            ? []
            : [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 15),
                  spreadRadius: -4,
                ),
              ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary,
            Color.lerp(
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.surfaceContainer,
              0.2,
            )!,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 24.sp,
            ),
            onPressed: onBackTap,
          ),

          SizedBox(height: 10.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.r),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withValues(alpha: 0.5),
                      width: 2.w,
                    ),
                  ),
                  child: SmartImageDisplay(
                    path:
                        (collarData['petImage'] != null &&
                            collarData['petImage'].toString().trim().isNotEmpty)
                        ? collarData['petImage']
                        : "assets/images/pet_placeholder.png",
                    width: 64.r,
                    height: 64.r,
                    radius: 64.r,
                    iconSize: 24.r,
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      collarData['petName'],
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      collarData['id'],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimary.withValues(alpha: 0.9),
                      ),
                    ),

                    SizedBox(height: 4.h),
                    Text(
                      "${context.l10n.lastSync} $displayLastSync",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimary.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
