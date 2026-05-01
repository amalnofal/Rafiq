import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/clinic_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/validation_helper.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/clinics/data/models/clinic_model.dart';
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
  final TextEditingController _hoursController = TextEditingController();

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
          _hoursController.text = fullClinic.workingHours;

          _isLoading = false;
        });
      }
    } catch (e) {
      log("فشل جلب بيانات العيادة للتعديل: $e");
      if (mounted) {
        Navigator.pop(context);
        showSnackBar(
          context,
          AppLocalizations.of(context)!.unexpectedError,
          isError: true,
        );
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
    _hoursController.dispose();
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
                    SizedBox(height: 12.h),

                    CustomTextField(
                      prefixIcon: "assets/icons/clock.svg",
                      labelText: l10n.clinicWorkingHoursLabel,
                      controller: _hoursController,
                      validator: (val) =>
                          ValidationHelper.validateWorkingHours(val, context),
                    ),
                    SizedBox(height: 12.h),

                    CustomTextField(
                      hintText: l10n.clinicDescriptionHint,
                      controller: _descController,
                      maxLines: 4,
                      validator: (val) =>
                          ValidationHelper.validateDescription(val, context),
                    ),
                    SizedBox(height: 20.h),

                    CustomButton(
                      title: isEdit ? l10n.save_changes : l10n.addClinicBtn,
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
    if (_formKey.currentState!.validate()) {
      final desc = _descController.text.trim();
      final clinicData = {
        "id": widget.clinicToEdit?.id,
        "name": _nameController.text.trim(),
        "specialization": _specializationController.text.trim(),
        "description": desc.isEmpty ? null : desc,
        "address": _addressController.text.trim(),
        "phone": _phoneController.text.trim(),
        "workingHours": _hoursController.text.trim(),
      };

      Navigator.pop(context, clinicData);
    }
  }
}
