import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/models/pet_model.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/animal_details_buttons.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/pet_stats_row.dart';
import 'package:rafiq/features/collar/data/models/collar_model.dart';

class HasCollar extends StatelessWidget {
  final CollarModel collar;
  final PetModel pet;
  const HasCollar({super.key, required this.collar, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
      child: Column(
        children: [
          PetStatsRow(collar: collar),
          AnimalDetailsButtons(pet: pet),
        ],
      ),
    );
  }
}
