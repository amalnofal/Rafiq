import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/features/settings/presentation/Widgets/account_info_row.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class AccountInfoSection extends StatelessWidget {
  const AccountInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final user = userProvider.user;

        return Card(
          margin: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.account_information,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                AccountInfoRow(
                  label: AppLocalizations.of(context)!.name,
                  value: user.name,
                ),
                const Divider(),
                AccountInfoRow(
                  label: AppLocalizations.of(context)!.email,
                  value: user.email,
                ),
                const Divider(),
                AccountInfoRow(
                  label: AppLocalizations.of(context)!.phone_number,
                  value: user.phone,
                  direction: TextDirection.ltr,
                ),
                const Divider(),
                AccountInfoRow(
                  label: AppLocalizations.of(context)!.join_date,
                  value: DateHelper.formatYearMonth(DateTime(2024, 1), context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
