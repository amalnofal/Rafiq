import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class AnimalDetailsButtons extends StatelessWidget {
  const AnimalDetailsButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: CustomButton(
              title: AppLocalizations.of(context)!.viewDetailedStatistics,
              elevation: 0,
              height: AppDimensions.buttonHeightS,
              onpressed: () {},
            ),
          ),
          SizedBox(width: AppDimensions.paddingS),
          Expanded(
            flex: 1,
            child: CustomButton(
              title: AppLocalizations.of(context)!.details,
              color: Theme.of(context).colorScheme.primaryContainer,
              txtColor: Theme.of(context).colorScheme.primary,
              elevation: 0,
              height: AppDimensions.buttonHeightS,
              onpressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
