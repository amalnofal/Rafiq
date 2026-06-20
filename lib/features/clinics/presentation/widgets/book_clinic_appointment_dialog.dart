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
import 'package:rafiq/features/clinics/data/models/appointment_model.dart';
import 'package:rafiq/features/clinics/data/models/clinic_model.dart';
import 'package:rafiq/features/clinics/presentation/widgets/appointments/appointment_form.dart';
import 'package:rafiq/features/clinics/presentation/widgets/appointments/dialog_header.dart';
import 'package:rafiq/features/clinics/presentation/widgets/appointments/pet_selector_widget.dart';

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

    // ==========================================
    // فحص تعارض المواعيد
    // ==========================================
    final appointments = context.read<AppointmentProvider>().appointments;
    final hasConflict = appointments.any((app) {
      if (widget.appointment != null && app.id == widget.appointment!.id) {
        return false;
      }

      final appDate = app.date.split('T')[0];
      final formDate = _formData["Date"] ?? "";
      final isSameDate = appDate == formDate;

      if (!isSameDate) return false;

      final isFinished =
          app.status.toLowerCase() == 'completed' ||
          app.status.toLowerCase() == 'cancelled';

      if (isFinished) return false;

      final appTimeStr = app.time;
      final formTimeStr = _formData["StartTime"] ?? "";

      if (appTimeStr.isEmpty || formTimeStr.isEmpty) return false;

      int timeToMinutes(String t) {
        final parts = t.split(':');
        if (parts.length >= 2) {
          return (int.tryParse(parts[0]) ?? 0) * 60 +
              (int.tryParse(parts[1]) ?? 0);
        }
        return 0;
      }

      final appMinutes = timeToMinutes(appTimeStr);
      final formMinutes = timeToMinutes(formTimeStr);

      final isTimeConflict = (appMinutes - formMinutes).abs() < 30;

      return isTimeConflict;
    });

    if (hasConflict) {
      showSnackBar(
        context,
        context.l10n.appointmentConflictError,
        isError: true,
      );
      return;
    }
    // ==========================================

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
                      clinicId: widget.clinic.id,

                      selectorWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.selectPetLabel,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(height: 8.h),
                          Builder(
                            builder: (context) {
                              final pets = context.watch<PetProvider>().pets;

                              // هندلة حالة لو مفيش حيوانات
                              if (pets.isEmpty) {
                                return SizedBox(
                                  height: 90.h,
                                  child: Center(
                                    child: Text(context.l10n.noPetsFoundTitle),
                                  ),
                                );
                              }

                              return PetSelectorWidget(
                                pets: pets,
                                selectedPetId: _selectedPetId,
                                onPetSelected: (id) =>
                                    setState(() => _selectedPetId = id),
                              );
                            },
                          ),
                        ],
                      ),

                      // ====================================
                      idKey: "PetId",
                      onDataReady: (data) => _formData = data,
                      middleContent: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 12.h),
                          Text(
                            context.l10n.phone_number,
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
                      isClinicBooking: true,
                    ),

                    SizedBox(height: 16.h),

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
