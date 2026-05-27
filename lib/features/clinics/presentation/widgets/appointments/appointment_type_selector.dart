import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/features/clinics/presentation/widgets/appointments/dialog_header.dart';

class AppointmentTypeSelector extends StatelessWidget {
  final VoidCallback onPetAppointmentTap;
  final VoidCallback onClinicAppointmentTap;

  const AppointmentTypeSelector({
    super.key,
    required this.onPetAppointmentTap,
    required this.onClinicAppointmentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DialogHeader(title: context.l10n.appointmentFor),

            Padding(
              padding: EdgeInsets.all(24.w),
              child: Row(
                children: [
                  // 1. كارت العيادة
                  Expanded(
                    child: _SelectionCard(
                      title: context.l10n.clinicLabel,
                      icon: "assets/icons/vet.svg",
                      onTap: onClinicAppointmentTap,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  // 2. كارت الحيوان
                  Expanded(
                    child: _SelectionCard(
                      title: context.l10n.petLabel,
                      icon: "assets/icons/pet_owner.svg",
                      onTap: onPetAppointmentTap,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onTap;

  const _SelectionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: theme.colorScheme.primary, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(12.h),
                child: SvgPicture.asset(icon, height: 32.h),
              ),
            ),
            SizedBox(height: 16.h),
            Text(title, style: theme.textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
