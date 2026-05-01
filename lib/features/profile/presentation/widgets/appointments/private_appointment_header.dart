import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/helper/menu_utils.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';

class PrivateAppointmentHeader extends StatelessWidget {
  final String status;
  final String statusText;
  final Color statusColor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PrivateAppointmentHeader({
    super.key,
    required this.status,
    required this.statusText,
    required this.statusColor,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    final bool isCompleted = status.toLowerCase() == 'completed';

    return Row(
      children: [
        CircleIconButton(
          "assets/icons/calendar.svg",
          color: isDarkMode ? const Color(0xFF51A2FF) : const Color(0xFF155DFC),
          bgColor: isDarkMode
              ? const Color(0xFF2B7FFF).withValues(alpha: 0.2)
              : const Color(0xFFDBEAFE),
        ),
        SizedBox(width: 12.w),
        Text(
          context.l10n.privateAppointment,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),

        if (isCompleted)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xFFE0FBE8),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              statusText,
              style: theme.textTheme.labelSmall?.copyWith(
                color: const Color(0xFF34C759),
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        else
          GestureDetector(
            onTapDown: (details) {
              MenuUtils.showContextMenu(
                context,
                details.globalPosition,
                onEdit: onEdit,
                onDelete: onDelete,
              );
            },
            child: Icon(Icons.more_vert, color: Colors.grey.shade600),
          ),
      ],
    );
  }
}
