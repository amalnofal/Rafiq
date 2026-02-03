import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class MenuUtils {
  static void showContextMenu(
    BuildContext context,
    Offset globalPosition, {
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    showMenu(
      context: context,
      elevation: 1,
      position: RelativeRect.fromLTRB(
        globalPosition.dx,
        globalPosition.dy,
        globalPosition.dx + 1,
        globalPosition.dy + 1,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      color: Theme.of(context).cardColor,
      items: <PopupMenuEntry<dynamic>>[
        // 1. خيار التعديل
        PopupMenuItem<dynamic>(
          onTap: onEdit,
          height: 40.h,
          child: Row(
            children: [
              SvgPicture.asset("assets/icons/edit.svg"),
              SizedBox(width: 10.w),
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Text(
                  AppLocalizations.of(context)!.editAction,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),

        // 2. فاصل خطي
        const PopupMenuDivider(height: 1),

        // 3. خيار الحذف
        PopupMenuItem<dynamic>(
          onTap: onDelete,
          height: 40.h,
          child: Row(
            children: [
              SvgPicture.asset("assets/icons/trash.svg"),
              SizedBox(width: 10.w),
              Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Text(
                  AppLocalizations.of(context)!.deleteAction,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
