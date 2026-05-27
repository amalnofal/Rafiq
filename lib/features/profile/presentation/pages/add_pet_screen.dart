import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/pet_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/validation_helper.dart';
import 'package:rafiq/core/models/pet_model.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/loading_overlay.dart';
import 'package:rafiq/features/auth/presentation/widgets/custom_date_picker.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/auth/presentation/widgets/custom_gender_selector.dart';
import 'package:rafiq/features/profile/presentation/widgets/pets/pet_specs_row.dart';
import 'package:rafiq/features/profile/presentation/widgets/pets/pet_type_selector.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class AddPetScreen extends StatefulWidget {
  final PetModel? petToEdit;
  const AddPetScreen({super.key, this.petToEdit});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? _petImage;
  int? _selectedType;
  int? _selectedGender;
  DateTime? _selectedDate;
  double _weight = 0.0;

  String? _typeError;
  String? _genderError;
  String? _weightError;
  bool _isFetchingDetails = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _weightController = TextEditingController(
    text: "0.0",
  );

  void _updateWeight(double delta) {
    setState(() {
      _weight = (_weight + delta).clamp(0.0, 100.0);
      _weightController.text = _weight.toStringAsFixed(1);
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.petToEdit != null) {
      _isFetchingDetails = true;

      _fillFields(widget.petToEdit!);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadPetFullDetails();
      });
    }
  }

  Future<void> _loadPetFullDetails() async {
    try {
      final fullPetData = await context.read<PetProvider>().fetchPetForEdit(
        widget.petToEdit!.id,
      );

      if (mounted) {
        setState(() {
          _fillFields(fullPetData);
          _isFetchingDetails = false;
        });
        log("[AddPetScreen]: Data synced with Edit-View successfully.");
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isFetchingDetails = false);
        log("[AddPetScreen]: Failed to sync with Edit-View: $e");
      }
    }
  }

  void _fillFields(PetModel pet) {
    _nameController.text = pet.name;
    _breedController.text = pet.breed;
    _colorController.text = pet.color;

    _selectedType = pet.type;
    _selectedGender = pet.gender;
    _selectedDate = pet.dob;

    _dobController.text =
        "${pet.dob.day.toString().padLeft(2, '0')}/${pet.dob.month.toString().padLeft(2, '0')}/${pet.dob.year}";

    _weight = pet.weight;
    _weightController.text = _weight.toStringAsFixed(1);

    if (pet.imageUrl != null && !pet.imageUrl!.startsWith('http')) {
      _petImage = File(pet.imageUrl!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _dobController.dispose();
    _colorController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final isAdding = context.watch<PetProvider>().isAddingPet;

    return RafiqScaffold(
      appBar: AppBar(
        title: Text(
          widget.petToEdit == null ? l10n.addNewPetTitle : l10n.editPetTitle,
        ),
      ),
      body: Stack(
        children: [
          _isFetchingDetails
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    vertical: AppDimensions.padding,
                    horizontal: AppDimensions.paddingS,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          labelText: l10n.name,
                          prefixIcon: "assets/icons/pet.svg",
                          controller: _nameController,
                          validator: (val) =>
                              ValidationHelper.validateName(val, context),
                          rejectNumbers: true,
                        ),
                        SizedBox(height: 16.h),

                        Text(
                          l10n.petTypeLabel,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 8.h),
                        IgnorePointer(
                          ignoring: widget.petToEdit != null,
                          child: Opacity(
                            opacity: widget.petToEdit != null ? 0.6 : 1.0,
                            child: PetTypeSelector(
                              selectedType: _selectedType,
                              onTypeSelected: (type) =>
                                  setState(() => _selectedType = type),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        CustomTextField(
                          labelText: l10n.breedLabel,
                          prefixIcon: "assets/icons/pet.svg",
                          controller: _breedController,
                          validator: (val) =>
                              ValidationHelper.validatePetAttribute(
                                val,
                                context,
                              ),
                          rejectNumbers: true,
                        ),
                        SizedBox(height: 16.h),

                        Text(
                          l10n.genderLabel,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 8.h),
                        CustomGenderSelector(
                          selectedGender: _selectedGender,
                          maleLabel: l10n.male,
                          femaleLabel: l10n.female,
                          errorText: _genderError,
                          onGenderChanged: (value) => setState(() {
                            _selectedGender = value;
                            _genderError = null;
                          }),
                        ),
                        SizedBox(height: 16.h),

                        Text(
                          l10n.dateOfBirthLabel,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),

                        IgnorePointer(
                          ignoring: widget.petToEdit != null,
                          child: CustomDatePickerField(
                            controller: _dobController,
                            hintText: l10n.dobHint,
                            initialDate: _selectedDate,
                            readOnly: widget.petToEdit != null,
                            onDateSelected: (date) {
                              setState(() => _selectedDate = date);
                            },
                            firstDate: DateTime(1995),
                            lastDate: DateTime.now().subtract(
                              const Duration(days: 1),
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return l10n.fieldRequired;
                              }
                              if (_selectedDate != null) {
                                final now = DateTime.now();
                                final yesterday = DateTime(
                                  now.year,
                                  now.month,
                                  now.day - 1,
                                );
                                final selected = DateTime(
                                  _selectedDate!.year,
                                  _selectedDate!.month,
                                  _selectedDate!.day,
                                );
                                if (selected.isAfter(yesterday)) {
                                  return l10n.invalidDate;
                                }
                              }
                              return null;
                            },
                          ),
                        ),

                        SizedBox(height: 16.h),

                        PetSpecsRow(
                          weightController: _weightController,
                          colorController: _colorController,
                          onAddWeight: () => _updateWeight(0.5),
                          onRemoveWeight: () => _updateWeight(-0.5),
                          weightError: _weightError,
                          isColorReadOnly: widget.petToEdit != null,
                        ),

                        SizedBox(height: 24.h),

                        // زرار الحفظ
                        CustomButton(
                          title: widget.petToEdit == null
                              ? l10n.addPetBtn
                              : l10n.save_changes,
                          onPressed: isAdding ? () {} : _submitForm,
                        ),
                      ],
                    ),
                  ),
                ),

          if (isAdding) LoadingOverlay(),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    final l10n = AppLocalizations.of(context)!;
    double currentWeight = double.tryParse(_weightController.text) ?? 0.0;

    setState(() {
      _typeError = _selectedType == null ? l10n.petTypeRequiredError : null;
      _genderError = _selectedGender == null ? l10n.genderRequiredError : null;
    });

    if (_formKey.currentState!.validate() &&
        _typeError == null &&
        _genderError == null &&
        _weightError == null &&
        _selectedDate != null) {
      final petData = {
        "name": _nameController.text.trim(),
        "type": _selectedType,
        "breed": _breedController.text.trim(),
        "dob": _selectedDate,
        "gender": _selectedGender,
        "weight": currentWeight,
        "color": _colorController.text.trim(),
      };

      if (widget.petToEdit == null) {
        await context.read<PetProvider>().addPet(context, petData, _petImage);

        if (mounted) {
          showSnackBar(context, l10n.addPetSuccess, isError: false);
          Navigator.pop(context, true);
        }
      } else {
        await context.read<PetProvider>().updatePetInfo(
          context,
          widget.petToEdit!.id,
          petData,
        );

        if (mounted) {
          showSnackBar(context, l10n.save_changes, isError: false);
          Navigator.pop(context, true);
        }
      }
    }
  }
}
