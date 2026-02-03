import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class UpcomingAppointmentCard extends StatelessWidget {
  final String title;
  final String time;

  const UpcomingAppointmentCard({
    super.key,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color subCardColor = isDarkMode
        ? const Color(0xFF2B7FFF).withValues(alpha: 0.1)
        : const Color(0XFFEFF6FF);

    return CustomContainer(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.upcomingAppointments,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(width: AppDimensions.paddingS),
              SvgPicture.asset("assets/icons/calendar.svg"),
            ],
          ),

          SizedBox(height: AppDimensions.paddingM),

          Card(
            color: subCardColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radius),
            ),
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.paddingM),
              child: Row(
                children: [
                  CircleIconButton(
                    "assets/icons/time.svg",
                    color: isDarkMode
                        ? const Color(0xFF51A2FF)
                        : const Color(0xFF155DFC),
                    backgroundColor: isDarkMode
                        ? const Color(0xFF2B7FFF).withValues(alpha: 0.2)
                        : const Color(0xFFDBEAFE),
                  ),
                  SizedBox(width: AppDimensions.paddingM),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. عنوان الموعد المتغير
                      Text(title, style: Theme.of(context).textTheme.bodyLarge),
                      SizedBox(height: AppDimensions.paddingXS),
                      // 3. وقت الموعد المتغير
                      Text(
                        time,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
