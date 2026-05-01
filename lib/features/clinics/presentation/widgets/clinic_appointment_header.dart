import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/helper/menu_utils.dart';

class ClinicAppointmentHeader extends StatelessWidget {
  final String clinicName;
  final String clinicAddress;
  final String status;
  final String statusText;
  final Color statusColor;
  final Color statusBgColor;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ClinicAppointmentHeader({
    super.key,
    required this.clinicName,
    required this.clinicAddress,
    required this.status,
    required this.statusText,
    required this.statusColor,
    required this.statusBgColor,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isPending =
        status.toLowerCase() == 'pending' ||
        status.toLowerCase() == 'pendingapproval';

    // تحديد الأيقونة حسب الحالة
    IconData? statusIcon;
    if (status.toLowerCase() == 'confirmed') {
      statusIcon = Icons.check_circle_outline;
    } else if (isPending) {
      statusIcon = Icons.access_time;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. الاسم والعنوان
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                clinicName,
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(clinicAddress, style: theme.textTheme.labelMedium),
            ],
          ),
        ),

        // 2. بادج الحالة
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: statusBgColor,
            border: Border.all(
              color: statusColor.withValues(alpha: 0.5),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (statusIcon != null) ...[
                Icon(statusIcon, size: 14.r, color: statusColor),
                SizedBox(width: 4.w),
              ],
              Padding(
                padding: EdgeInsets.only(top: 3.h),
                child: Text(
                  statusText,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        // 3. منيو التعديل والحذف
        if (isPending && onEdit != null && onDelete != null)
          Padding(
            padding: EdgeInsetsDirectional.only(start: 8.w),
            child: GestureDetector(
              onTapDown: (details) {
                MenuUtils.showContextMenu(
                  context,
                  details.globalPosition,
                  onEdit: onEdit!,
                  onDelete: onDelete!,
                );
              },
              child: Icon(
                Icons.more_vert,
                color: Colors.grey.shade600,
                size: 22.r,
              ),
            ),
          ),
      ],
    );
  }
}
