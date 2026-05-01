import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/appointment_provider.dart';
import 'package:rafiq/core/controller/pet_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/features/profile/data/models/appointment_model.dart';
import 'package:rafiq/features/profile/presentation/widgets/appointments/appointment_form.dart';
import 'package:rafiq/features/profile/presentation/widgets/appointments/dialog_header.dart';
import 'package:rafiq/features/profile/presentation/widgets/pets/pet_image.dart';

class AddPetAppointmentDialog extends StatefulWidget {
  final AppointmentModel? appointment;
  const AddPetAppointmentDialog({super.key, this.appointment});

  @override
  State<AddPetAppointmentDialog> createState() =>
      _AddPetAppointmentDialogState();
}

class _AddPetAppointmentDialogState extends State<AddPetAppointmentDialog> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _formData = {};
  bool _isLoading = false;

  String? _selectedPetId;

  @override
  void initState() {
    super.initState();
    if (widget.appointment != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final pets = context.read<PetProvider>().pets;
        if (pets.isNotEmpty) {
          final pet = pets.firstWhere(
            (p) => p.name == widget.appointment!.petName,
            orElse: () => pets.first,
          );
          setState(() {
            _selectedPetId = pet.id;
          });
        }
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedPetId == null) {
      showSnackBar(context, context.l10n.selectPetLabel, isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.appointment == null) {
        await context.read<AppointmentProvider>().createPrivateAppointment(
          _formData,
        );
      } else {
        await context.read<AppointmentProvider>().updateAppointment(
          widget.appointment!.id,
          _formData,
        );
      }

      if (mounted) {
        Navigator.pop(context);
        showSnackBar(
          context,
          widget.appointment == null
              ? context.l10n.appointmentAddedSuccess
              : context.l10n.appointmentUpdatedSuccess,
        );
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, context.l10n.unexpectedError, isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildPetSelector() {
    final pets = context.watch<PetProvider>().pets;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final fieldBgColor = Theme.of(context).cardTheme.color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.selectPetLabel,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 4.h),
        SizedBox(
          height: 90.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: pets.length,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final pet = pets[index];
              final isSelected = _selectedPetId == pet.id;
              return GestureDetector(
                onTap: () => setState(() => _selectedPetId = pet.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 95.w,
                  decoration: BoxDecoration(
                    color: fieldBgColor,
                    border: Border.all(
                      color: isSelected ? primaryColor : Colors.transparent,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PetImage(imageUrl: pet.imageUrl, size: 45.r),
                      SizedBox(height: 8.h),
                      Text(
                        pet.name,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: isSelected ? primaryColor : null,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DialogHeader(
              title: widget.appointment == null
                  ? context.l10n.addAppointment
                  : context.l10n.editAppointment,
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  children: [
                    AppointmentForm(
                      formKey: _formKey,
                      appointment: widget.appointment,
                      selectedId: _selectedPetId,
                      selectorWidget: _buildPetSelector(),
                      idKey: "PetId",
                      onDataReady: (data) => _formData = data,
                    ),
                    SizedBox(height: 16.h),
                    // زر الحفظ
                    CustomButton(
                      title: context.l10n.save,
                      elevation: 0,
                      fontWeight: FontWeight.w500,
                      onPressed: _isLoading ? null : _submit,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
