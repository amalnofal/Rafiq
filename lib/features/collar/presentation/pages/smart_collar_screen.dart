import 'package:flutter/material.dart';
import 'package:rafiq/core/widgets/main_header.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class SmartCollarScreen extends StatelessWidget {
  const SmartCollarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RafiqScaffold(
      padding: EdgeInsets.all(0),
      hasMainBottomNav: true,

      body: Column(
        children: [
          MainHeader(
            title: AppLocalizations.of(context)!.smartCollar,
            icon: 'assets/icons/circle_add.svg',
          ),

          Spacer(),
          Text(
            "Coming Soon ",
            style: Theme.of(context).textTheme.displayMedium,
          ),
          Spacer(),
        ],
      ),
    );
  }
}
