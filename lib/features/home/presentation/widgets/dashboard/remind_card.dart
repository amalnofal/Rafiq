import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/widgets/custom_container.dart';

class RemindCard extends StatelessWidget {
  final String title;
  final String description;

  const RemindCard({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return CustomContainer(
      margin: EdgeInsets.all(AppDimensions.paddingS),
      color: isDarkMode ? const Color(0x1AF0B100) : const Color(0xFFFEFCE8),
      borderColor: isDarkMode
          ? const Color(0x33F0B100)
          : const Color(0XFFFFF085),
      borderWidth: 1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/icons/alert.svg",
            width: AppDimensions.iconM,
            colorFilter: ColorFilter.mode(
              isDarkMode ? const Color(0xFFFDC700) : const Color(0XffD08700),
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: AppDimensions.paddingM),

          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: description.trim().isEmpty
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isDarkMode
                        ? const Color(0xFFFFDF20)
                        : const Color(0XFF733E0A),
                  ),
                ),

                if (description.trim().isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDarkMode
                          ? const Color(0xFFFFF085)
                          : const Color(0XFF894B00),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
