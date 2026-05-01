import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/appointment_provider.dart';
import 'package:rafiq/core/controller/clinic_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/features/profile/data/models/appointment_model.dart';
import 'package:rafiq/features/profile/presentation/widgets/appointments/appointment_form.dart';

class AddClinicApppointmentDialog extends StatefulWidget {
  final AppointmentModel? appointment;
  const AddClinicApppointmentDialog({super.key, this.appointment});

  @override
  State<AddClinicApppointmentDialog> createState() =>
      _AddClinicApppointmentDialogState();
}

class _AddClinicApppointmentDialogState
    extends State<AddClinicApppointmentDialog> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _formData = {};
  bool _isLoading = false;

  String? _selectedClinicId;

  @override
  void initState() {
    super.initState();
    if (widget.appointment != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final clinics = context.read<ClinicProvider>().clinics;
        if (clinics.isNotEmpty) {
          final clinic = clinics.firstWhere(
            (c) => c.name == widget.appointment!.clinicName,
            orElse: () => clinics.first,
          );
          setState(() {
            _selectedClinicId = clinic.id;
          });
        }
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedClinicId == null) {
      showSnackBar(context, context.l10n.selectClinicLabel, isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final finalData = Map<String, dynamic>.from(_formData);

      if (widget.appointment == null) {
        await context.read<AppointmentProvider>().createDoctorClinicAppointment(
          finalData,
        );
      } else {
        await context.read<AppointmentProvider>().updateAppointment(
          widget.appointment!.id,
          finalData,
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

  Widget _buildClinicSelector() {
    final clinics = context.watch<ClinicProvider>().clinics;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.selectClinicLabel,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 12.h),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: clinics.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final clinic = clinics[index];
            final isSelected = _selectedClinicId == clinic.id;

            return GestureDetector(
              onTap: () => setState(() => _selectedClinicId = clinic.id),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clinic.name,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/location.svg",
                            height: 16.h,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 4.h),
                              child: Text(
                                clinic.address,
                                style: Theme.of(context).textTheme.labelSmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
            _buildHeader(context),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  children: [
                    AppointmentForm(
                      formKey: _formKey,
                      appointment: widget.appointment,
                      selectedId: _selectedClinicId,
                      selectorWidget: _buildClinicSelector(),
                      idKey: "ClinicId",
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Text(
            widget.appointment == null
                ? context.l10n.addAppointment
                : context.l10n.editAppointment,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
