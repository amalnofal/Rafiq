import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/helper/dialog_helper.dart';
import 'package:rafiq/core/helper/menu_utils.dart';
import 'package:rafiq/features/clinics/data/models/clinic_model.dart';
import 'package:rafiq/features/clinics/presentation/pages/clinic_profile_screen.dart';
import 'package:rafiq/features/profile/presentation/widgets/icon_text_row.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class VetClinicCard extends StatelessWidget {
  final ClinicModel clinic;
  final bool isMe;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const VetClinicCard({
    super.key,
    required this.clinic,
    this.isMe = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 6.h),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ClinicProfileScreen(clinic: clinic, isMe: isMe),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم العيادة
                    Text(
                      clinic.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),

                    // العنوان
                    IconTextRow(
                      iconPath: "assets/icons/location.svg",
                      text: clinic.address,
                    ),
                    SizedBox(height: 8.h),

                    // رقم الموبايل
                    IconTextRow(
                      iconPath: "assets/icons/phone.svg",
                      text: clinic.phone,
                    ),
                    SizedBox(height: 8.h),

                    // ساعات العمل
                    IconTextRow(
                      iconPath: "assets/icons/clock.svg",
                      text: clinic.workingHours,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),

              if (isMe)
                GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    MenuUtils.showContextMenu(
                      context,
                      details.globalPosition,
                      onEdit: () {
                        if (onEdit != null) onEdit!();
                      },
                      onDelete: () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) {
                            final l10n = AppLocalizations.of(context)!;
                            return CustomInfoDialog(
                              title: l10n.deletePetTitle(clinic.name),
                              description: l10n.deletePetWarning,
                              confirmBtnText: l10n.deleteAction,
                              onConfirm: () async {
                                Navigator.pop(context);
                                if (onDelete != null) onDelete!();
                              },
                            );
                          },
                        );
                      },
                      actiontxt: AppLocalizations.of(context)!.deleteAction,
                    );
                  },
                  child: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 20.r,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
