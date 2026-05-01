import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/features/profile/data/models/appointment_model.dart';

class DateTimeCard extends StatelessWidget {
  final AppointmentModel appointment;

  const DateTimeCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.padding,
          vertical: AppDimensions.paddingM,
        ),
        child: Row(
          children: [
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
                appointment.date,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 24.w),
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
