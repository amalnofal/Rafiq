import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class DeleteAccButton extends StatelessWidget {
  const DeleteAccButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppColors.kStatusError.withValues(alpha: 0.1),
            width: 2,
          ),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleIconButton(
            "assets/icons/trash.svg",
            color: AppColors.kStatusError,
            backgroundColor: AppColors.kStatusError.withValues(alpha: 0.1),
          ),
          title: Text(
            AppLocalizations.of(context)!.delete_account,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.kStatusError,
            ),
          ),
          subtitle: Text(
            AppLocalizations.of(context)!.warning_delete_account,
            style: TextStyle(color: AppColors.kStatusError),
          ),
        ),
      ),
      onTap: () {
        // Handle delete account action
      },
    );
  }
}
