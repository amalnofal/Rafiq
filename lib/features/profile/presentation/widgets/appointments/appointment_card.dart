import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/clinic_provider.dart';
import 'package:rafiq/core/helper/dialog_helper.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/clinics/data/models/clinic_model.dart';
import 'package:rafiq/features/clinics/presentation/widgets/book_clinic_appointment_dialog.dart';
import 'package:rafiq/features/profile/data/models/appointment_model.dart';
import 'package:rafiq/features/profile/presentation/widgets/appointments/add_clinic_apppointment_dialog.dart';
import 'package:rafiq/features/profile/presentation/widgets/appointments/add_pet_appointment_dialog.dart';
import 'package:rafiq/features/profile/presentation/widgets/icon_text_row.dart';
import 'package:rafiq/features/profile/presentation/widgets/pets/pet_image.dart';
import 'package:rafiq/features/profile/presentation/widgets/pets/pet_info_card.dart';
import 'package:rafiq/features/profile/presentation/widgets/appointments/date_time_card.dart';
import 'package:rafiq/features/clinics/presentation/widgets/clinic_appointment_header.dart';
import 'package:rafiq/features/profile/presentation/widgets/appointments/private_appointment_header.dart';
import 'package:rafiq/features/profile/presentation/widgets/appointments/action_buttons.dart';
import 'package:rafiq/core/controller/appointment_provider.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/models/user_model.dart';

class AppointmentCard extends StatefulWidget {
  final AppointmentModel appointment;

  const AppointmentCard({super.key, required this.appointment});

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  String? _errorMessage;

  void _onDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => CustomInfoDialog(
        title: context.l10n.deleteAppointmentTitle,
        description: context.l10n.deleteConfirmationMessage,
        confirmBtnText: context.l10n.deleteAction,
        onConfirm: () => Navigator.pop(context, true),
      ),
    );

    if (confirm != true || !mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final success = await context.read<AppointmentProvider>().deleteAppointment(
      widget.appointment.id,
    );

    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();

    if (!success) {
      setState(() => _errorMessage = context.l10n.unexpectedError);
    }
  }

  void _onEdit() {
    final userProvider = context.read<UserProvider>();
    final bool isDoctor = userProvider.user?.role == UserType.vet;

    // بنعرف إذا كان الموعد لحيوان ولا لعيادة
    final bool hasPet =
        widget.appointment.petName.isNotEmpty &&
        widget.appointment.petName.trim() != '-';

    final bool isDoctorClinicBlock = isDoctor && !hasPet;

    if (isDoctorClinicBlock) {
      //  1. لو الموعد قفل عيادة للدكتور -> نفتح ديالوج العيادات
      showDialog(
        context: context,
        builder: (context) =>
            AddClinicApppointmentDialog(appointment: widget.appointment),
      );
    } else if (widget.appointment.isPrivate) {
      // 2. لو الموعد برايفت بس يخص حيوان (للدكتور لحيوانه الخاص أو للمالك) -> نفتح ديالوج الحيوانات
      showDialog(
        context: context,
        builder: (context) =>
            AddPetAppointmentDialog(appointment: widget.appointment),
      );
    } else {
      //  3. لو موعد عيادة عادي محجوز من مالك -> نفتح ديالوج الحجز
      final clinicProvider = context.read<ClinicProvider>();

      ClinicModel targetClinic;

      try {
        targetClinic = clinicProvider.clinics.firstWhere(
          (c) => c.id == widget.appointment.clinicId?.toString(),
        );
      } catch (_) {
        targetClinic = ClinicModel(
          id: widget.appointment.clinicId?.toString() ?? "0",
          name: widget.appointment.clinicName ?? "عيادة بيطرية",
          address: widget.appointment.clinicAddress ?? "",
          specialization: "",
          phone: "",
          workingHours: "",
          doctorName: "",
          doctorSpecialization: "",
          doctorSubSpecialization: "",
        );
      }

      showDialog(
        context: context,
        builder: (context) => BookClinicAppointmentDialog(
          clinic: targetClinic,
          appointment: widget.appointment,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    final userProvider = context.watch<UserProvider>();
    final bool isDoctor = userProvider.user?.role == UserType.vet;

    final bool hasPet =
        widget.appointment.petName.isNotEmpty &&
        widget.appointment.petName.trim() != '-';

    final bool isDoctorClinicBlock = isDoctor && !hasPet;

    final bool isVisuallyPrivate =
        widget.appointment.isPrivate || isDoctorClinicBlock;

    final String status = widget.appointment.status.toLowerCase();
    final bool isPending = status == 'pending' || status == 'pendingapproval';

    DateTime? dob;
    if (widget.appointment.dateOfBirth != null &&
        widget.appointment.dateOfBirth!.isNotEmpty) {
      dob = DateTime.tryParse(widget.appointment.dateOfBirth!);
    }

    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الهيدر
          isVisuallyPrivate
              ? PrivateAppointmentHeader(
                  status: widget.appointment.status,
                  statusText: _getStatusText(
                    context,
                    widget.appointment.status,
                  ),
                  statusColor: _getStatusColor(widget.appointment.status),
                  onEdit: _onEdit,
                  onDelete: _onDelete,
                )
              : ClinicAppointmentHeader(
                  clinicName: widget.appointment.clinicName ?? "عيادة بيطرية",
                  clinicAddress:
                      widget.appointment.clinicAddress ?? "عنوان غير متوفر",
                  status: widget.appointment.status,
                  statusText: _getStatusText(
                    context,
                    widget.appointment.status,
                  ),
                  statusColor: _getStatusColor(widget.appointment.status),
                  statusBgColor: _getStatusColor(
                    widget.appointment.status,
                  ).withValues(alpha: 0.09),
                  onEdit: (!isDoctor && isPending) ? _onEdit : null,
                  onDelete: (!isDoctor && isPending) ? _onDelete : null,
                ),

          Divider(
            height: 32.h,
            thickness: 1,
            color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
          ),

          // المحتوى المتغير (كارت العيادة أو كارت الحيوان)
          if (isDoctorClinicBlock)
            Card(
              child: Padding(
                padding: EdgeInsets.all(12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.appointment.clinicName ?? "عيادة بيطرية",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    IconTextRow(
                      iconPath: "assets/icons/location.svg",
                      text:
                          widget.appointment.clinicAddress ?? "عنوان غير متوفر",
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.padding,
                vertical: 12.h,
              ),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : const Color(0xFFF9F6F0),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PetImage(
                    imageUrl: widget.appointment.petImage ?? '',
                    size: 48.r,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: PetInfoCard(
                      customName: widget.appointment.petName,
                      customGender: widget.appointment.gender,
                      customTypeName: widget.appointment.petType,
                      customBreed: widget.appointment.breed,
                      customDob: dob,
                    ),
                  ),
                ],
              ),
            ),

          SizedBox(height: 12.h),

          // كارت التاريخ والوقت
          DateTimeCard(appointment: widget.appointment),
          SizedBox(height: 6.h),

          // سبب الزيارة والملاحظات
          _buildInfoBox(
            label: context.l10n.visitReasonLabel,
            value: widget.appointment.visitReason,
            bgColor: isDarkMode
                ? const Color(0xFF2B7FFF).withValues(alpha: 0.1)
                : const Color(0XFFEFF6FF),
            labelColor: const Color(0xFF3B82F6),
            theme: theme,
          ),

          if (widget.appointment.notes != null &&
              widget.appointment.notes!.isNotEmpty)
            _buildInfoBox(
              label: context.l10n.additionalNotesLabel,
              value: widget.appointment.notes!,
              bgColor: isDarkMode
                  ? const Color(0x1AF0B100)
                  : const Color(0xFFFEFCE8),
              labelColor: const Color(0xFFB45309),
              theme: theme,
            ),

          if (_errorMessage != null)
            Padding(
              padding: EdgeInsets.only(bottom: 12.h, right: 8.w),
              child: Text(
                _errorMessage!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          SizedBox(height: 8.h),

          // منطقة الأزرار (Action Buttons)
          //  الشرط الأول: الزراير تختفي فقط لو الموعد "مكتمل"
          if (status != 'completed') ...[
            if (isVisuallyPrivate) ...[
              // 1. الموعد الخاص: بيظهر له دايماً زرار "مكتمل" لحد ما يخلص
              AppointmentActionButtons(
                primaryText: context.l10n.markAsCompleted,
                onPrimaryPressed: () async {
                  setState(() => _errorMessage = null);
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) =>
                        const Center(child: CircularProgressIndicator()),
                  );
                  final success = await context
                      .read<AppointmentProvider>()
                      .completeAppointment(widget.appointment.id);
                  if (!context.mounted) return;
                  Navigator.of(context, rootNavigator: true).pop();
                  if (!success) {
                    setState(
                      () => _errorMessage = context.l10n.unexpectedError,
                    );
                  }
                },
              ),
            ] else ...[
              // 2. مواعيد العيادة (اللي بتتحجز من المالك)
              if (isDoctor && isPending) ...[
                // أ- لو الموعد لسه "معلق": يظهر للدكتور (قبول / رفض)
                AppointmentActionButtons(
                  primaryText: context.l10n.accept,
                  onPrimaryPressed: () async {
                    setState(() => _errorMessage = null);
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                    );
                    final success = await context
                        .read<AppointmentProvider>()
                        .approveClinicAppointment(widget.appointment.id);
                    if (!context.mounted) return;
                    Navigator.of(context, rootNavigator: true).pop();
                    if (!success) {
                      setState(
                        () => _errorMessage = context.l10n.unexpectedError,
                      );
                    }
                  },
                  showSecondary: true,
                  secondaryText: context.l10n.decline,
                  onSecondaryPressed: () async {
                    setState(() => _errorMessage = null);
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                    );
                    final success = await context
                        .read<AppointmentProvider>()
                        .rejectClinicAppointment(widget.appointment.id);
                    if (!context.mounted) return;
                    Navigator.of(context, rootNavigator: true).pop();
                    if (!success) {
                      setState(
                        () => _errorMessage = context.l10n.unexpectedError,
                      );
                    }
                  },
                ),
              ] else if (status == 'confirmed') ...[
                // ب- لو الموعد بقى "مؤكد": يظهر (مكتمل / إلغاء) زي الديزاين بتاعك بالظبط
                AppointmentActionButtons(
                  primaryText: context.l10n.markAsCompleted,
                  onPrimaryPressed: () async {
                    setState(() => _errorMessage = null);
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                    );
                    final success = await context
                        .read<AppointmentProvider>()
                        .completeAppointment(widget.appointment.id);
                    if (!context.mounted) return;
                    Navigator.of(context, rootNavigator: true).pop();
                    if (!success) {
                      setState(
                        () => _errorMessage = context.l10n.unexpectedError,
                      );
                    }
                  },
                  showSecondary: true,
                  secondaryText: context.l10n.cancel,
                  onSecondaryPressed: () {
                    _onDelete();
                  },
                ),
              ],
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildInfoBox({
    required String label,
    required String value,
    required Color bgColor,
    required Color labelColor,
    required ThemeData theme,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: labelColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF34C759);
      case 'pending':
      case 'pendingapproval':
        return const Color(0xFFE87E41);
      case 'confirmed':
        return const Color(0xFF155DFC);
      default:
        return Colors.grey[600]!;
    }
  }

  String _getStatusText(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'complete':
        return context.l10n.completed;
      case 'pending':
      case 'pendingapproval':
        return context.l10n.pending;
      case 'confirmed':
        return context.l10n.confirmed;
      default:
        return status;
    }
  }
}
