import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rafiq/core/helper/validation_helper.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';
import 'package:rafiq/features/auth/presentation/widgets/next_button.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class Step3PersonalInfo extends StatefulWidget {
  final TextEditingController dobController;
  final Function(String) onGenderChanged;
  final VoidCallback onNext;
  final String? selectedGender;

  const Step3PersonalInfo({
    super.key,
    required this.dobController,
    required this.onGenderChanged,
    required this.onNext, this.selectedGender,
  });

  @override
  State<Step3PersonalInfo> createState() => _Step3PersonalInfoState();
}

class _Step3PersonalInfoState extends State<Step3PersonalInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  String _selectedGender = "";
  bool _showGenderError = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedGender != null) {
      _selectedGender = widget.selectedGender!;
    }
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return child!;
      },
    );
    if (picked != null) {
      setState(() {
        widget.dobController.text =
            "${picked.month}/${picked.day}/${picked.year}";
      });
      _formKey.currentState?.validate();
    }
  }

  void _validateAndProceed() {
    setState(() {
      _showGenderError = _selectedGender.isEmpty;
    });

    bool isDateValid = _formKey.currentState!.validate();

    if (isDateValid && !_showGenderError) {
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gender Section
            Text(
              AppLocalizations.of(context)!.genderLabel,
              style: Theme.of(context).textTheme.labelMedium,
            ),

            SizedBox(height: 8.h),
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildGenderCard(AppLocalizations.of(context)!.male, "male"),
                    SizedBox(width: 12.w),
                    _buildGenderCard(AppLocalizations.of(context)!.female, "female"),
                  ],
                ),

                if (_showGenderError)
                  Padding(
                    padding: EdgeInsets.only(top: 8.h, right: 8.w),
                    child: Text(
                      AppLocalizations.of(context)!.fieldRequired,
                      style: TextStyle(color: Colors.red, fontSize: 12.sp),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 24.h),

            // Date of Birth Section
            Text(
              AppLocalizations.of(context)!.dateOfBirthLabel,
              style: Theme.of(context).textTheme.labelMedium,
            ),

            GestureDetector(
              onTap: _selectDate,
              child: AbsorbPointer(
                child: CustomTextField(
                  controller: widget.dobController,
                  hintText: AppLocalizations.of(context)!.dobHint,
                  hintStyle: Theme.of(context).textTheme.bodyLarge,
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: SvgPicture.asset(
                      "assets/icons/calendar.svg",
                      colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                    ),
                  ),
                  validator: (val) => ValidationHelper.validateRequired(val, context),
                ),
              ),
            ),
            
            NextButton(onNext: _validateAndProceed),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderCard(String label, String value) {
    bool isSelected = _selectedGender == value;
    Color activeColor = Theme.of(context).colorScheme.primary;
    
    Color borderColor;
    if (_showGenderError && !isSelected) {
      borderColor = Colors.red;
    } else if (isSelected) {
      borderColor = activeColor;
    } else {
      borderColor = Theme.of(context).colorScheme.outline;
    }

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedGender = value;
            _showGenderError = false;
          });
          widget.onGenderChanged(value);
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(color: borderColor, width: 1.5.w),
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