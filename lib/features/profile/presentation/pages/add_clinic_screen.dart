import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/clinic_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/helper/validation_helper.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/clinics/data/models/clinic_model.dart';
import 'package:rafiq/features/profile/presentation/widgets/clinics/clinic_schedule_section.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class AddClinicScreen extends StatefulWidget {
  final ClinicModel? clinicToEdit;
  const AddClinicScreen({super.key, this.clinicToEdit});

  @override
  State<AddClinicScreen> createState() => _AddClinicScreenState();
}

class _AddClinicScreenState extends State<AddClinicScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  TimeOfDay? _openingTime;
  TimeOfDay? _closingTime;

  // 🚨 المتغير بتاعنا
  bool _is24Hours = false;

  final Map<String, bool> _days = {
    'Saturday': false,
    'Sunday': false,
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
  };

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.clinicToEdit != null) {
      _isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchFullClinicData();
      });
    }
  }

  Future<void> _fetchFullClinicData() async {
    try {
      final clinicProvider = context.read<ClinicProvider>();
      final fullClinic = await clinicProvider.fetchClinicForEdit(
        widget.clinicToEdit!.id,
      );

      if (mounted) {
        setState(() {
          _nameController.text = fullClinic.name;
          _specializationController.text = fullClinic.specialization;
          _descController.text = fullClinic.description ?? "";
          _addressController.text = fullClinic.address;
          _phoneController.text = fullClinic.phone;

          _days['Saturday'] = fullClinic.workingDays['Saturday'] ?? false;
          _days['Sunday'] = fullClinic.workingDays['Sunday'] ?? false;
          _days['Monday'] = fullClinic.workingDays['Monday'] ?? false;
          _days['Tuesday'] = fullClinic.workingDays['Tuesday'] ?? false;
          _days['Wednesday'] = fullClinic.workingDays['Wednesday'] ?? false;
          _days['Thursday'] = fullClinic.workingDays['Thursday'] ?? false;
          _days['Friday'] = fullClinic.workingDays['Friday'] ?? false;

          if (fullClinic.openingTime.isNotEmpty) {
            final parts = fullClinic.openingTime.split(':');
            _openingTime = TimeOfDay(
              hour: int.parse(parts[0]),
              minute: int.parse(parts[1]),
            );
          }

          if (fullClinic.closingTime.isNotEmpty) {
            final parts = fullClinic.closingTime.split(':');
            _closingTime = TimeOfDay(
              hour: int.parse(parts[0]),
              minute: int.parse(parts[1]),
            );
          }

          // 🚨 لو هو بيعدل عيادة، بنكتشف هل هي 24 ساعة ولا لأ عشان نفعل الـ Checkbox
          if (_openingTime != null && _closingTime != null) {
            if (_openingTime!.hour == 0 &&
                _openingTime!.minute == 0 &&
                _closingTime!.hour == 23 &&
                _closingTime!.minute == 59) {
              _is24Hours = true;
            }
          }

          _isLoading = false;
        });
      }
    } catch (e) {
      log("فشل جلب بيانات العيادة للتعديل: $e");
      if (mounted) {
        Navigator.pop(context);
        showSnackBar(context, context.l10n.unexpectedError, isError: true);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specializationController.dispose();
    _descController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEdit = widget.clinicToEdit != null;

    return RafiqScaffold(
      appBar: AppBar(
        title: Text(isEdit ? l10n.editClinicTitle : l10n.addNewClinicTitle),
      ),
      padding: EdgeInsets.all(AppDimensions.paddingXL),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                clipBehavior: Clip.none,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      prefixIcon: "assets/icons/clinics.svg",
                      labelText: l10n.clinicNameLabel,
                      controller: _nameController,
                      validator: (val) =>
                          ValidationHelper.validateName(val, context),
                    ),
                    SizedBox(height: 12.h),

                    CustomTextField(
                      prefixIcon: "assets/icons/work.svg",
                      labelText: l10n.specializationLabel,
                      controller: _specializationController,
                      validator: (val) =>
                          ValidationHelper.validateSpecialization(val, context),
                    ),
                    SizedBox(height: 12.h),

                    CustomTextField(
                      prefixIcon: "assets/icons/location.svg",
                      labelText: l10n.clinicAddressLabel,
                      controller: _addressController,
                      validator: (val) =>
                          ValidationHelper.validateAddress(val, context),
                    ),
                    SizedBox(height: 12.h),

                    CustomTextField(
                      prefixIcon: "assets/icons/phone.svg",
                      labelText: l10n.phone_number,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (val) =>
                          ValidationHelper.validatePhone(val, context),
                    ),
                    SizedBox(height: 20.h),

                    // مواعيد العمل
                    ClinicScheduleSection(
                      selectedDays: _days,
                      openingTime: _openingTime,
                      closingTime: _closingTime,
                      is24Hours: _is24Hours,
                      onDayToggled: (key, isSelected) {
                        setState(() => _days[key] = isSelected);
                      },
                      onOpeningTimeChanged: (newTime) {
                        setState(() => _openingTime = newTime);
                      },
                      onClosingTimeChanged: (newTime) {
                        setState(() => _closingTime = newTime);
                      },
                      //  اللوجيك بتاع تشغيل الـ 24 ساعة
                      on24HoursToggled: (val) {
                        setState(() {
                          _is24Hours = val;
                          if (_is24Hours) {
                            _openingTime = const TimeOfDay(hour: 0, minute: 0);
                            _closingTime = const TimeOfDay(
                              hour: 23,
                              minute: 59,
                            );
                          }
                        });
                      },
                    ),
                    SizedBox(height: 20.h),

                    CustomTextField(
                      hintText: context.l10n.clinicDescriptionHint,
                      controller: _descController,
                      maxLines: 4,
                      validator: (val) =>
                          ValidationHelper.validateDescription(val, context),
                    ),
                    SizedBox(height: 20.h),

                    CustomButton(
                      title: isEdit
                          ? context.l10n.save_changes
                          : context.l10n.addClinicBtn,
                      onPressed: _submitForm,
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),
    );
  }

  void _submitForm() {
    if (!_days.values.contains(true)) {
      showSnackBar(context, context.l10n.selectAtLeastOneDay, isError: true);
      return;
    }

    if (_openingTime == null || _closingTime == null) {
      showSnackBar(context, context.l10n.selectTimeError, isError: true);
      return;
    }

    if (_formKey.currentState!.validate()) {
      final desc = _descController.text.trim();

      // دالة الإرسال زي ما هي (الباك إند هيستقبلها صح 00:00 و 23:59)
      final clinicData = {
        "id": widget.clinicToEdit?.id,
        "name": _nameController.text.trim(),
        "specialization": _specializationController.text.trim(),
        "description": desc.isEmpty ? null : desc,
        "address": _addressController.text.trim(),
        "phone": _phoneController.text.trim(),
        "OpeningTime":
            "${_openingTime!.hour.toString().padLeft(2, '0')}:${_openingTime!.minute.toString().padLeft(2, '0')}",
        "ClosingTime":
            "${_closingTime!.hour.toString().padLeft(2, '0')}:${_closingTime!.minute.toString().padLeft(2, '0')}",
        "Saturday": _days['Saturday'],
        "Sunday": _days['Sunday'],
        "Monday": _days['Monday'],
        "Tuesday": _days['Tuesday'],
        "Wednesday": _days['Wednesday'],
        "Thursday": _days['Thursday'],
        "Friday": _days['Friday'],
      };

      Navigator.pop(context, clinicData);
    }
  }
}
