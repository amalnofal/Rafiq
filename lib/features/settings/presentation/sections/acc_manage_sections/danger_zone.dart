import 'package:flutter/material.dart';
import 'package:rafiq/features/settings/presentation/Widgets/delete_acc_button.dart';
import 'package:rafiq/l10n/app_localizations.dart' show AppLocalizations;

class DangerZone extends StatelessWidget {
  const DangerZone({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.danger_zone,
          style: Theme.of(context).textTheme.labelMedium,
        ),

        DeleteAccButton(),
      ],
    );
  }
}
