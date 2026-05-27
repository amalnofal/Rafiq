import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';
import 'package:rafiq/core/widgets/custom_time_picker.dart';
import 'package:rafiq/core/widgets/selection_chip.dart';

class ClinicScheduleSection extends StatelessWidget {
  final Map<String, bool> selectedDays;
  final TimeOfDay? openingTime;
  final TimeOfDay? closingTime;

  final bool is24Hours;
  final Function(bool isSelected) on24HoursToggled;

  final Function(String dayKey, bool isSelected) onDayToggled;
  final Function(TimeOfDay newTime) onOpeningTimeChanged;
  final Function(TimeOfDay newTime) onClosingTimeChanged;

  const ClinicScheduleSection({
    super.key,
    required this.selectedDays,
    required this.openingTime,
    required this.closingTime,
    required this.is24Hours,
    required this.on24HoursToggled,
    required this.onDayToggled,
    required this.onOpeningTimeChanged,
    required this.onClosingTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> dayLabels = {
      'Saturday': context.l10n.saturday,
      'Sunday': context.l10n.sunday,
      'Monday': context.l10n.monday,
      'Tuesday': context.l10n.tuesday,
      'Wednesday': context.l10n.wednesday,
      'Thursday': context.l10n.thursday,
      'Friday': context.l10n.friday,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.clinicScheduleTitle,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 15.sp,
          ),
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 6.w,
          runSpacing: 8.h,
          children: selectedDays.keys.map((dayKey) {
            bool isSelected = selectedDays[dayKey]!;
            return SelectionChip(
              label: dayLabels[dayKey]!,
              isSelected: isSelected,
              onTap: () => onDayToggled(dayKey, !isSelected),
              unselectedColor: Theme.of(context).cardColor,
              hasUnselectedBorder: true,
              customPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 8.h,
              ),
            );
          }).toList(),
        ),

        SizedBox(height: 20.h),

        Row(
          children: [
            // "من"
            Text(
              context.l10n.fromTime,
              style: Theme.of(
                context,
              ).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 10.w),

            Expanded(
              child: _buildTimeBox(
                context,
                openingTime?.format(context),
                is24Hours
                    ? null
                    : () async {
                        final picked = await showCustomTimePickerDialog(
                          context: context,
                          title: context.l10n.startTime,
                          initialTime:
                              openingTime ??
                              const TimeOfDay(hour: 9, minute: 0),
                        );
                        if (picked != null) onOpeningTimeChanged(picked);
                      },
                is24Hours,
              ),
            ),

            SizedBox(width: 16.w),

            // "إلى"
            Text(
              context.l10n.toTime,
              style: Theme.of(
                context,
              ).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 10.w),

            Expanded(
              child: _buildTimeBox(
                context,
                closingTime?.format(context),
                is24Hours
                    ? null
                    : () async {
                        final picked = await showCustomTimePickerDialog(
                          context: context,
                          title: context.l10n.endTime,
                          initialTime:
                              closingTime ??
                              const TimeOfDay(hour: 18, minute: 0),
                        );
                        if (picked != null) onClosingTimeChanged(picked);
                      },
                is24Hours,
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        // Checkbox بتاع الـ 24 ساعة
        Row(
          children: [
            SizedBox(
              height: 24.h,
              width: 24.w,
              child: Checkbox(
                value: is24Hours,
                onChanged: (val) {
                  if (val != null) on24HoursToggled(val);
                },
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.5.w,
                ),

                activeColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(width: 4.w),

            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: GestureDetector(
                onTap: () => on24HoursToggled(!is24Hours),
                child: Text(
                  context.l10n.open24Hours,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 🚨 التعديل على شكل الحقل لما يكون مقفول
  Widget _buildTimeBox(
    BuildContext context,
    String? time,
    VoidCallback? onTap,
    bool isDisabled,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: AbsorbPointer(
          child: CustomTextField(
            controller: TextEditingController(text: time ?? ""),
            hintText: "00:00",
            contentpadding: EdgeInsets.all(AppDimensions.paddingM),
            padding: EdgeInsets.zero,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
