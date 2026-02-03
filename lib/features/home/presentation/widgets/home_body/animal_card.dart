import 'package:flutter/material.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/home/presentation/widgets/home_body/no_collar_card.dart';
import 'package:rafiq/features/home/presentation/widgets/home_body/has_collar.dart';
import 'package:rafiq/features/home/presentation/widgets/home_body/pet_profile_card.dart';
import 'package:rafiq/features/pets/data/models/pet_model.dart';

class AnimalCard extends StatelessWidget {
  const AnimalCard({
    super.key,
    required this.pet,
    required this.index,
    required this.totalCount,
  });

  final PetModel pet;
  final int index;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PetProfileCard(
              pet: pet,
              currentIndex: index,
              totalPets: totalCount,
            ),

            if (pet.collar != null)
              HasCollar(collar: pet.collar!)
            else
              const NoCollarCard(),
          ],
        ),
      ),
    );
  }
}
