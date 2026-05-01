import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';

class NotificationItemTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final String icon;
  final Color iconBgColor;
  final Color iconColor;
  final bool isUnread;

  const NotificationItemTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        color: isUnread
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.05)
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5.w,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleIconButton(icon, color: iconColor, bgColor: iconBgColor),
          // Container(
          //   width: 48.r,
          //   height: 48.r,
          //   decoration: BoxDecoration(
          //     color: iconBgColor,
          //     shape: BoxShape.circle,
          //   ),
          //   child: Icon(icon, color: iconColor, size: 24.sp),
          // ),
          SizedBox(width: isUnread ? 12.w : 20.w),

          // محتوى الإشعار
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4.h),
                Text(subtitle, style: Theme.of(context).textTheme.labelMedium),
                SizedBox(height: 8.h),
                Text(time, style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),

          // النقطة الخضراء للإشعارات غير المقروءة
          if (isUnread)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: CircleAvatar(
                radius: 4.r,
                backgroundColor: const Color(0xFF6B7243),
              ),
            ),
        ],
      ),
    );
  }
}
