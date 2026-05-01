import 'package:flutter/material.dart';
import 'package:rafiq/features/home/presentation/widgets/empty_home/empty_state_layout.dart';
import 'package:rafiq/features/profile/data/models/pet_model.dart';
import 'package:rafiq/features/profile/presentation/pages/add_pet_screen.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class HomeEmptyState extends StatelessWidget {
  final Function(PetModel)? onPetAdded;

  const HomeEmptyState({super.key, this.onPetAdded});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return EmptyStateLayout(
      buttonText: l10n.addPetBtn,
      onMainAction: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddPetScreen()),
        );
      },
      gridItems: _getSharedItems(l10n),
      tipContent: l10n.ownerTipContent,
    );
  }

  List<DashboardItemData> _getSharedItems(AppLocalizations l10n) {
    return [
      DashboardItemData(
        title: l10n.communityTitle,
        subtitle: l10n.communitySubtitle,
        iconPath: "assets/icons/community.svg",
        color: Colors.green,
      ),
      DashboardItemData(
        title: l10n.healthTrackingTitle,
        subtitle: l10n.healthTrackingSubtitle,
        iconPath: "assets/icons/activity.svg",
        color: Colors.blue,
      ),
      DashboardItemData(
        title: l10n.storeTitle,
        subtitle: l10n.storeSubtitle,
        iconPath: "assets/icons/store.svg",
        color: Colors.orange,
      ),
      DashboardItemData(
        title: l10n.vetClinicsTitle,
        subtitle: l10n.vetClinicsSubtitle,
        iconPath: "assets/icons/clinics.svg",
        color: Colors.purple,
      ),
    ];
  }
}
