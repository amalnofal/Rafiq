import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomGenderSelector extends StatelessWidget {
  final int? selectedGender;
  final Function(int) onGenderChanged;
  final String? errorText;
  final String maleLabel;
  final String femaleLabel;

  const CustomGenderSelector({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.maleLabel,
    required this.femaleLabel,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildGenderCard(context, maleLabel, 1),
            SizedBox(width: 12.w),
            _buildGenderCard(context, femaleLabel, 0),
          ],
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 8.h, right: 8.w),
            child: Text(
              errorText!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12.sp,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGenderCard(BuildContext context, String label, int value) {
    bool isSelected = selectedGender == value;
    Color activeColor = Theme.of(context).colorScheme.primary;

    Color borderColor = isSelected
        ? activeColor
        : (errorText != null
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.outline);

    return Expanded(
      child: InkWell(
        onTap: () => onGenderChanged(value),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(color: borderColor, width: 1.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected
                    ? activeColor
                    : Theme.of(context).colorScheme.outline,
                size: 20.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
