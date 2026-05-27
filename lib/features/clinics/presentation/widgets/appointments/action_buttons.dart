import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_button.dart';

class AppointmentActionButtons extends StatelessWidget {
  final String primaryText;
  final VoidCallback onPrimaryPressed;
  final bool showSecondary;
  final String? secondaryText;
  final VoidCallback? onSecondaryPressed;

  const AppointmentActionButtons({
    super.key,
    required this.primaryText,
    required this.onPrimaryPressed,
    this.showSecondary = false,
    this.secondaryText,
    this.onSecondaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Divider(height: 32.h, thickness: 1),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                title: primaryText,
                color: isDarkMode
                    ? const Color(0XFF00a840)
                    : const Color(0xff00C950),
                onPressed: onPrimaryPressed,
                height: 45.h,
                fontWeight: FontWeight.w500,
                elevation: 0,
              ),
            ),

            if (showSecondary) ...[
              SizedBox(width: 8.w),
              Expanded(
                child: InkWell(
                  onTap: onSecondaryPressed,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color(0xFF3F1D1D)
                          : const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      secondaryText ?? context.l10n.cancel,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFFE7000B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
