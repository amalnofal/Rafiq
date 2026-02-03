import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/features/home/presentation/widgets/home_body/daily_tip_card.dart';
import 'package:rafiq/features/home/presentation/widgets/home_body/animal_details_buttons.dart';
import 'package:rafiq/features/home/presentation/widgets/home_body/pet_stats_row.dart';
import 'package:rafiq/features/pets/data/models/collar_model.dart';

class HasCollar extends StatelessWidget {
  final CollarModel collar;
  const HasCollar({super.key, required this.collar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
      child: Column(
        children: [
          PetStatsRow(collar: collar),
          DailyTipCard(message: collar.dailyTip),
          AnimalDetailsButtons(),
        ],
      ),
    );
  }
}
