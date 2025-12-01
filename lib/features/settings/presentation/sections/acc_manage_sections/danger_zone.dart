import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/features/settings/presentation/Widgets/delete_acc_button.dart';
import 'package:rafiq/l10n/app_localizations.dart' show AppLocalizations;

class DangerZone extends StatelessWidget {
  const DangerZone({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.danger_zone,
            // style: TextStyle(color: AppColors.textSecondary),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: DeleteAccButton(),
          ),
        ],
      ),
    );
  }
}
