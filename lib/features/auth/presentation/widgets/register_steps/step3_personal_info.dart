import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rafiq/core/helper/validation_helper.dart';
import 'package:rafiq/features/auth/presentation/widgets/custom_date_picker.dart';
import 'package:rafiq/features/auth/presentation/widgets/custom_gender_selector.dart';
import 'package:rafiq/features/auth/presentation/widgets/next_button.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class Step3PersonalInfo extends StatefulWidget {
  final TextEditingController dobController;
  final Function(int) onGenderChanged;
  final VoidCallback onNext;
  final int? selectedGender;

  const Step3PersonalInfo({
    super.key,
    required this.dobController,
    required this.onGenderChanged,
    required this.onNext,
    this.selectedGender,
  });

  @override
  State<Step3PersonalInfo> createState() => _Step3PersonalInfoState();
}

class _Step3PersonalInfoState extends State<Step3PersonalInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int? _selectedGender;
  bool _showGenderError = false;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    // 1. استرجاع النوع (مباشرة كـ int)
    _selectedGender = widget.selectedGender;

    // 2. استرجاع التاريخ من الـ Controller
    if (widget.dobController.text.isNotEmpty) {
      try {
        _selectedDate = DateFormat(
          'dd/MM/yyyy',
        ).parse(widget.dobController.text);
      } catch (e) {
        _selectedDate = null;
      }
    }
  }

  void _validateAndProceed() {
    setState(() {
      // 👈 التحقق صار بالمقارنة مع null لأنها أرقام
      _showGenderError = _selectedGender == null;
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

            CustomGenderSelector(
              selectedGender: _selectedGender,
              maleLabel: AppLocalizations.of(context)!.male,
              femaleLabel: AppLocalizations.of(context)!.female,
              errorText: _showGenderError
                  ? AppLocalizations.of(context)!.genderRequiredError
                  : null,
              onGenderChanged: (value) {
                setState(() {
                  _selectedGender = value; // الـ value هنا int (0 أو 1)
                  _showGenderError = false;
                });
                widget.onGenderChanged(value);
              },
            ),

            SizedBox(height: 24.h),

            // Date of Birth Section
            Text(
              AppLocalizations.of(context)!.dateOfBirthLabel,
              style: Theme.of(context).textTheme.labelMedium,
            ),

            CustomDatePickerField(
              controller: widget.dobController,
              hintText: AppLocalizations.of(context)!.dobHint,
              initialDate: _selectedDate,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              validator: (val) =>
                  ValidationHelper.validateAge(_selectedDate, context),
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
                _formKey.currentState?.validate();
              },
            ),

            NextButton(onNext: _validateAndProceed),
          ],
        ),
      ),
    );
  }
}
