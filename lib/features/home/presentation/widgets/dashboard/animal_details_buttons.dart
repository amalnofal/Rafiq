import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/models/pet_model.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/features/profile/presentation/pages/pet_profile_screen.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class AnimalDetailsButtons extends StatelessWidget {
  final PetModel pet;

  const AnimalDetailsButtons({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final isStatsExpandedNotifier = context.watch<ValueNotifier<bool>>();
    final isExpanded = isStatsExpandedNotifier.value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: CustomButton(
            title: isExpanded
                ? context.l10n.hideStatistics
                : context.l10n.viewDetailedStatistics,

            color: Theme.of(context).colorScheme.primary,

            txtColor: Colors.white,
            elevation: 0,
            height: AppDimensions.buttonHeightS,
            onPressed: () {
              isStatsExpandedNotifier.value = !isExpanded;
            },
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PetProfileScreen(pet: pet),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
