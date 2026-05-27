import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/clinic_provider.dart';
import 'package:rafiq/core/controller/pet_provider.dart';
import 'package:rafiq/core/helper/dialog_helper.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/clinics/data/models/appointment_model.dart';
import 'package:rafiq/features/clinics/data/models/clinic_model.dart';
import 'package:rafiq/features/clinics/presentation/widgets/appointments/action_buttons.dart';
import 'package:rafiq/features/clinics/presentation/widgets/appointments/add_clinic_apppointment_dialog.dart';
import 'package:rafiq/features/clinics/presentation/widgets/appointments/add_pet_appointment_dialog.dart';
import 'package:rafiq/features/clinics/presentation/widgets/appointments/date_time_card.dart';
import 'package:rafiq/features/clinics/presentation/widgets/appointments/private_appointment_header.dart';
import 'package:rafiq/features/clinics/presentation/widgets/book_clinic_appointment_dialog.dart';
import 'package:rafiq/features/profile/presentation/widgets/icon_text_row.dart';
import 'package:rafiq/features/profile/presentation/widgets/pets/pet_image.dart';
import 'package:rafiq/features/profile/presentation/widgets/pets/pet_info_card.dart';
import 'package:rafiq/features/clinics/presentation/widgets/clinic_appointment_header.dart';
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
          (c) => c.id == widget.appointment.clinicId,
        );
      } catch (_) {
        targetClinic = ClinicModel(
          id: widget.appointment.clinicId ?? 0,
          name: widget.appointment.clinicName ?? "عيادة بيطرية",
          address: widget.appointment.clinicAddress ?? "",
          openingTime: "00:00",
          closingTime: "00:00",
          workingDays: {
            'Saturday': false,
            'Sunday': false,
            'Monday': false,
            'Tuesday': false,
            'Wednesday': false,
            'Thursday': false,
            'Friday': false,
          },
          specialization: "",
          phone: "",
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
    final petProvider = context.watch<PetProvider>();
    final bool isDoctor = userProvider.user?.role == UserType.vet;

    // هل الحيوان المحجوز ليه ده من ضمن حيوانات اليوزر الحالي؟
    final bool isMyPet = petProvider.pets.any(
      (p) => p.id.toString() == widget.appointment.petId.toString(),
    );

    // إنت بتتعامل كدكتور (وتقدر تقبل وترفض) فقط لو إنت دكتور + الحيوان ده مش بتاعك!
    final bool actingAsDoctor = isDoctor && !isMyPet;

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
                  onEdit: null,
                  onDelete: null,
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
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
                side: BorderSide(
                  color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.paddingM),
                child: Column(
                  children: [
                    // 1. بيانات الحيوان الأليف (الجزء العلوي)
                    Row(
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

                    if (actingAsDoctor && !isVisuallyPrivate) ...[
                      SizedBox(height: 12.h),

                      // 2. بيانات المالك
                      Card(
                        color: Theme.of(context).cardColor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18.r,
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.1),
                                child: SvgPicture.asset(
                                  "assets/icons/user_icon.svg",
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.onSecondary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),

                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.appointment.ownerName ??
                                          "اسم المالك غير متوفر",
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      widget.appointment.phoneNumber ??
                                          "رقم الهاتف غير متوفر",
                                      style: theme.textTheme.labelMedium,

                                      textDirection: TextDirection.ltr,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
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
          if (status != 'completed' && status != 'cancelled') ...[
            if (isVisuallyPrivate) ...[
              // 1. الموعد الخاص: بيظهر له دايماً زرار "مكتمل"
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
              // 2. مواعيد العيادة
              if (isPending) ...[
                if (actingAsDoctor) ...[
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
                ] else ...[
                  // ب- الموعد معلق والمالك بيشوفه: تعديل / إلغاء
                  AppointmentActionButtons(
                    primaryText: context.l10n.editAction,
                    onPrimaryPressed: _onEdit,
                    showSecondary: true,
                    secondaryText: context.l10n.cancel,
                    onSecondaryPressed: _onDelete,
                  ),
                ],
              ] else if (status == 'confirmed') ...[
                // ج- الموعد مؤكد (للاتنين دكتور أو مالك): مكتمل / إلغاء
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
                  onSecondaryPressed: _onDelete,
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
