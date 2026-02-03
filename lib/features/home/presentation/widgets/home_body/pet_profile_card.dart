import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/widgets/stat_card.dart';
import 'package:rafiq/features/pets/data/models/pet_model.dart';

class PetProfileCard extends StatelessWidget {
  const PetProfileCard({
    super.key,
    required this.pet,
    required this.currentIndex,
    required this.totalPets,
  });

  final PetModel pet;
  final int currentIndex;
  final int totalPets;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final surfaceOverlay85 = colorScheme.surface.withAlpha(0xD9);
    final surfaceOverlay80 = colorScheme.surface.withAlpha(0xEF);

    return Stack(
      children: [
        // 1. الصورة
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppDimensions.radius),
            topRight: Radius.circular(AppDimensions.radius),
          ),
          child: Image.asset(
            pet.imageUrl,
            height: 192.h,
            width: 360.w,
            fit: BoxFit.cover,
          ),
        ),

        // 2. العداد (زي 2/1)
        Positioned(
          top: AppDimensions.paddingM,
          right: AppDimensions.paddingM,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
              vertical: 2.h,
            ),
            decoration: BoxDecoration(
              color: surfaceOverlay85,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            child: Text(
              "${currentIndex + 1} / $totalPets",
              style: textTheme.bodyLarge,
            ),
          ),
        ),

        // 3. بيانات الاسم والنوع
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            margin: EdgeInsets.all(AppDimensions.padding),
            padding: EdgeInsets.all(AppDimensions.padding),
            decoration: BoxDecoration(
              color: surfaceOverlay80,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pet.name, style: textTheme.bodyLarge),
                    Text(
                      "${pet.type} • ${pet.age} سنوات",
                      style: textTheme.labelMedium,
                    ),
                  ],
                ),
                StatCard(title: pet.healthStatus),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
