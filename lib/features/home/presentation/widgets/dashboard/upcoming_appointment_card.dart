import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/upcoming_appointment_item.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class UpcomingAppointmentCard extends StatelessWidget {
  final List<dynamic> appointments;
  final bool showOnlyNext;

  const UpcomingAppointmentCard({
    super.key,
    required this.appointments,
    this.showOnlyNext = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CustomContainer(
      margin: EdgeInsets.all(AppDimensions.paddingS),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.upcomingAppointments,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(width: AppDimensions.paddingS),
              SvgPicture.asset("assets/icons/calendar.svg"),
            ],
          ),
          SizedBox(height: AppDimensions.paddingM),
          if (appointments.isEmpty)
            const UpcomingAppointmentItem(title: "", time: "")
          else if (showOnlyNext)
            UpcomingAppointmentItem(
              title: appointments.first['visitReason']?.toString() ?? "",
              time: DateHelper.formatRecordDateAndTime(
                appointments.first,
                context,
              ),
            )
          else
            ...appointments.map((app) {
              return UpcomingAppointmentItem(
                title: app['visitReason']?.toString() ?? "",
                time: DateHelper.formatRecordDateAndTime(app, context),
              );
            }),
        ],
      ),
    );
  }
}
