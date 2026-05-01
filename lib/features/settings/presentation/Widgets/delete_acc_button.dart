import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/settings/presentation/Widgets/confirm_delete_dialog.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class DeleteAccButton extends StatelessWidget {
  const DeleteAccButton({super.key});

  @override
  Widget build(BuildContext context) {
    final Color alertcolor = AppColors.kStatusError;
    return InkWell(
      borderRadius: BorderRadius.circular(AppDimensions.radius),
      child: CustomContainer(
        padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingXS),
        borderColor: alertcolor.withAlpha(50),
        child: ListTile(
          leading: CircleIconButton(
            "assets/icons/trash.svg",
            color: alertcolor,
            bgColor: alertcolor.withValues(alpha: 0.1),
          ),
          title: Text(
            AppLocalizations.of(context)!.delete_account,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.kContentWarning),
          ),
          subtitle: Text(
            AppLocalizations.of(context)!.warning_delete_account,
            style: TextStyle(color: alertcolor),
          ),
        ),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => DeleteAccountDialog(
            onConfirm: (String password) {
              // Handle delete account action
              log("تم الحذف بكلمة مرور: $password");
            },
          ),
        );
      },
    );
  }
}
