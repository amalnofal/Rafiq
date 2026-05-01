import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/pet_provider.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/dialog_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/features/clinics/data/models/clinic_model.dart';
import 'package:rafiq/features/clinics/presentation/widgets/book_clinic_appointment_dialog.dart';

class ClinicActionButtons extends StatelessWidget {
  final ClinicModel clinic;

  const ClinicActionButtons({super.key, required this.clinic});

  Future<void> _callClinic(String? phoneNumber, BuildContext context) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      showSnackBar(
        context,
        context.l10n.phoneNumberNotAvailable,
        isError: true,
      );
      return;
    }

    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      debugPrint("لا يمكن الاتصال بالرقم: $phoneNumber");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        GestureDetector(
          onTap: () => _callClinic(clinic.phone, context),
          child: Container(
            height: 48.h,
            width: 50.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(12.h),
              child: SvgPicture.asset(
                "assets/icons/phone.svg",
                width: 16.w,
                height: 16.h,
                colorFilter: ColorFilter.mode(
                  theme.colorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),

        Expanded(
          child: CustomButton(
            title: context.l10n.bookAppointment,
            height: 48.h,
            fontWeight: FontWeight.w500,
            onPressed: () {
              final petProvider = context.read<PetProvider>();

              void showEmptyAlert({
                required String title,
                required String description,
                required String buttonText,
                required VoidCallback onAction,
              }) {
                showDialog(
                  context: context,
                  builder: (alertContext) => CustomInfoDialog(
                    title: title,
                    description: description,
                    confirmBtnText: buttonText,
                    mainColor: theme.colorScheme.primary,
                    onConfirm: () {
                      Navigator.pop(alertContext);
                      onAction();
                    },
                  ),
                );
              }

              if (petProvider.pets.isEmpty) {
                // لو مفيش حيوانات، نظهر الديالوج
                showEmptyAlert(
                  title: context.l10n.noPetsFoundTitle,
                  description: context.l10n.noPetsFoundDescription,
                  buttonText: context.l10n.addPetBtn,
                  onAction: () {
                    Navigator.pushNamed(context, '/add_pet_screen');
                  },
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) =>
                      BookClinicAppointmentDialog(clinic: clinic),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
