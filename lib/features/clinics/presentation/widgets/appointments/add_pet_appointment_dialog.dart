import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/appointment_provider.dart';
import 'package:rafiq/core/controller/pet_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/features/clinics/data/models/appointment_model.dart';
import 'package:rafiq/features/clinics/presentation/widgets/appointments/appointment_form.dart';
import 'package:rafiq/features/clinics/presentation/widgets/appointments/dialog_header.dart';
import 'package:rafiq/features/clinics/presentation/widgets/appointments/pet_selector_widget.dart';

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

    // ==========================================
    // 🚨 فحص تعارض المواعيد (مع حساب مدة الجلسة 30 دقيقة) 🚨
    // ==========================================
    final appointments = context.read<AppointmentProvider>().appointments;
    final hasConflict = appointments.any((app) {
      // تجاهل الموعد الحالي لو في وضع التعديل
      if (widget.appointment != null && app.id == widget.appointment!.id) {
        return false;
      }

      final appDate = app.date.split('T')[0];
      final formDate = _formData["Date"] ?? "";
      final isSameDate = appDate == formDate;

      // لو مش نفس اليوم، يبقى مفيش تعارض
      if (!isSameDate) return false;

      final isFinished =
          app.status.toLowerCase() == 'completed' ||
          app.status.toLowerCase() == 'cancelled';

      // لو الموعد القديم خلصان أو ملغي، يبقى مفيش تعارض
      if (isFinished) return false;

      final appTimeStr = app.time;
      final formTimeStr = _formData["StartTime"] ?? "";

      if (appTimeStr.isEmpty || formTimeStr.isEmpty) return false;

      // دالة داخلية لتحويل الوقت (ساعات ودقائق) إلى إجمالي الدقائق
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

      // الجلسة مدتها 30 دقيقة، لو الفرق الزمني أقل من 30، إذن هناك تداخل (Conflict)!
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
    setState(() => _isLoading = true);

    try {
      if (widget.appointment == null) {
        await context.read<AppointmentProvider>().addPrivateAppointment(
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
                  ? context.l10n.addPrivateAppointment
                  : context.l10n.editAppointment,
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  children: [
                    AppointmentForm(
                      isClinicBooking: false,
                      formKey: _formKey,
                      appointment: widget.appointment,
                      selectedId: _selectedPetId,
                      selectorWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.selectPetLabel,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(height: 4.h),
                          PetSelectorWidget(
                            pets: context.watch<PetProvider>().pets,
                            selectedPetId: _selectedPetId,
                            onPetSelected: (id) {
                              setState(() => _selectedPetId = id);
                            },
                          ),
                        ],
                      ),
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
