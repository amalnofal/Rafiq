import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/core/widgets/custom_card.dart';
import 'package:rafiq/features/settings/presentation/Widgets/account_info_row.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class VersionSection extends StatelessWidget {
  const VersionSection({super.key});

  @override
  Widget build(BuildContext context) {
    // final lastUpdate = DateTime(2024, 10, 1);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
      child: CustomCard(
        child: Column(
          children: [
            AccountInfoRow(
              label: AppLocalizations.of(context)!.version,
              value: "1.0.0",
            ),
            AccountInfoRow(
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
