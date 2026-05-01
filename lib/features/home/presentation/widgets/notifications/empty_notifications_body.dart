import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class EmptyNotificationsBody extends StatelessWidget {
  const EmptyNotificationsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleIconButton(
              "assets/icons/notifications.svg",
              size: 90.w,
              iconSize: 45.h,
            ),
            SizedBox(height: 24.h),
            Text(
              l10n.noNotificationsYet,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 12.h),
            Text(
              l10n.notificationsSubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}
