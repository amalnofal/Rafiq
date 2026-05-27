import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/features/clinics/data/models/appointment_model.dart';

class DateTimeCard extends StatelessWidget {
  final AppointmentModel appointment;

  const DateTimeCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String displayDate = appointment.date;
    final parsedDate = DateTime.tryParse(appointment.date);
    if (parsedDate != null) {
      displayDate = DateHelper.formatFullDate(parsedDate, context);
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.padding,
          vertical: AppDimensions.paddingM,
        ),
        child: Row(
          children: [
            // أيقونة وتاريخ الزيارة
            SvgPicture.asset(
              "assets/icons/calendar.svg",
              width: 18.r,
              height: 18.r,
              colorFilter: ColorFilter.mode(
                theme.colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 6.w),
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                displayDate,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(width: 24.w),

            // أيقونة ووقت الزيارة
            SvgPicture.asset(
              "assets/icons/time.svg",
              width: 18.r,
              height: 18.r,
              colorFilter: ColorFilter.mode(
                theme.colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 6.w),
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                DateHelper.formatTime(appointment.time, context),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
