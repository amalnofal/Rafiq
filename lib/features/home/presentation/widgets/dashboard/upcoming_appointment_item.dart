import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class UpcomingAppointmentItem extends StatelessWidget {
  final String title;
  final String time;

  const UpcomingAppointmentItem({
    super.key,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color subCardColor = isDarkMode
        ? const Color(0xFF2B7FFF).withValues(alpha: 0.1)
        : const Color(0XFFEFF6FF);
    final displayTitle = title.isEmpty ? l10n.noUpcomingAppointments : title;

    return Card(
      color: subCardColor,
      elevation: 0,
      margin: EdgeInsets.only(bottom: 8.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingM),
        child: Row(
          children: [
            CircleIconButton(
              "assets/icons/time.svg",
              color: isDarkMode ? const Color(0xFF51A2FF) : const Color(0xFF155DFC),
              bgColor: isDarkMode ? const Color(0xFF2B7FFF).withValues(alpha: 0.2) : const Color(0xFFDBEAFE),
            ),
            SizedBox(width: AppDimensions.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(displayTitle, style: Theme.of(context).textTheme.bodyLarge),
                  if (time.isNotEmpty) ...[
                    SizedBox(height: AppDimensions.paddingXS),
                    Text(time, style: Theme.of(context).textTheme.labelMedium),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}