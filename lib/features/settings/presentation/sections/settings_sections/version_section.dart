import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/features/settings/presentation/Widgets/account_info_row.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class VersionSection extends StatelessWidget {
  const VersionSection({super.key});

  @override
  Widget build(BuildContext context) {
    // final lastUpdate = DateTime(2024, 10, 1);
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingL,
          vertical: AppDimensions.paddingM,
        ),
        child: Column(
          children: [
            AccountInfoRow(
              padding: AppDimensions.paddingS,
              label: AppLocalizations.of(context)!.version,
              value: "1.0.0",
            ),
            AccountInfoRow(
              padding: AppDimensions.paddingS,
              label: AppLocalizations.of(context)!.last_update,
              value: DateHelper.formatYearMonth(
                DateTime(2024, 10, 1), //Last update date
                context,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
