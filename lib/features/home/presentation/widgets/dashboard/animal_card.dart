import 'package:flutter/material.dart';
import 'package:rafiq/core/models/pet_model.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/collar/data/models/collar_model.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/has_collar.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/no_collar_card.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/pet_profile_card.dart';

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

            if (index == 0)
              HasCollar(
                collar: pet.collar ?? CollarModel(id: 'fake_collar'),
                pet: pet,
              )
            else
              const NoCollarCard(),
          ],
        ),
      ),
    );
  }
}
