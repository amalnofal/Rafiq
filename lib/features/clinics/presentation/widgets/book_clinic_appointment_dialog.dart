import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/appointment_provider.dart';
import 'package:rafiq/core/controller/pet_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/helper/validation_helper.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';
import 'package:rafiq/features/clinics/data/models/clinic_model.dart';
import 'package:rafiq/features/profile/data/models/appointment_model.dart';
import 'package:rafiq/features/profile/presentation/widgets/appointments/appointment_form.dart';
import 'package:rafiq/features/profile/presentation/widgets/appointments/dialog_header.dart';
import 'package:rafiq/features/profile/presentation/widgets/pets/pet_image.dart';

class BookClinicAppointmentDialog extends StatefulWidget {
  final ClinicModel clinic;
  final AppointmentModel? appointment;

  const BookClinicAppointmentDialog({
    super.key,
    required this.clinic,
    this.appointment,
  });

  @override
  State<BookClinicAppointmentDialog> createState() =>
      _BookClinicAppointmentDialogState();
}

class _BookClinicAppointmentDialogState
    extends State<BookClinicAppointmentDialog> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _formData = {};
  bool _isLoading = false;

  String? _selectedPetId;
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.appointment != null) {
      _selectedPetId = widget.appointment!.petId.toString();
      _phoneController.text = widget.appointment!.phoneNumber ?? "";
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedPetId == null) {
      showSnackBar(context, context.l10n.selectPetLabel, isError: true);
      return;
    }

    final finalAppointmentData = {
      ..._formData,
      "ClinicId": widget.clinic.id,
      "PetId": int.tryParse(_selectedPetId!) ?? 0,
      "PhoneNumber": _phoneController.text.trim(),
    };

    setState(() => _isLoading = true);

    try {
      final provider = context.read<AppointmentProvider>();

      if (widget.appointment != null) {
        await provider.updateAppointment(
          widget.appointment!.id,
          finalAppointmentData,
        );
        if (mounted) {
          showSnackBar(context, context.l10n.appointmentUpdatedSuccess);
        }
      } else {
        await provider.bookClinicAppointment(finalAppointmentData);
        if (mounted) {
          showSnackBar(context, context.l10n.appointmentBookingSuccess);
        }
      }

      if (mounted) Navigator.pop(context);
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
        SizedBox(height: 8.h),
        SizedBox(
          height: 95.h,
          child: pets.isEmpty
              ? Center(child: Text(context.l10n.noPetsFoundTitle))
              : ListView.separated(
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
                            color: isSelected
                                ? primaryColor
                                : Colors.transparent,
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
                              style: Theme.of(context).textTheme.bodySmall!
                                  .copyWith(
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
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
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
                  ? context.l10n.bookAppointment
                  : context.l10n.editAppointment,
              subtitle: widget.clinic.name,
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppointmentForm(
                      formKey: _formKey,
                      appointment: widget.appointment,
                      selectedId: _selectedPetId,
                      selectorWidget: _buildPetSelector(),
                      idKey: "PetId",
                      onDataReady: (data) => _formData = data,
                      middleContent: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Text(
                              context.l10n.clinicConfirmationNotice,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            context.l10n.phone,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          CustomTextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            prefixIcon: "assets/icons/phone.svg",
                            validator: (v) =>
                                ValidationHelper.validatePhone(v, context),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // زر الحفظ / التأكيد
                    CustomButton(
                      title: widget.appointment == null
                          ? context.l10n.confirmBooking
                          : context.l10n.save,
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
