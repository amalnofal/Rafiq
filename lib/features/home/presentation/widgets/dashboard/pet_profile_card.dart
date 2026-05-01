import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/features/profile/data/models/pet_model.dart';
import 'package:rafiq/features/profile/presentation/widgets/pets/pet_info_card.dart';

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

  ImageProvider _getPetImage(String? path) {
    if (path == null || path.isEmpty) {
      return const AssetImage("assets/images/pet_placeholder.png");
    }
    if (path.startsWith('http') || path.startsWith('https')) {
      return CachedNetworkImageProvider(
        path,
        cacheKey: path.contains('?') ? path.split('?').first : path,
      );
    }
    if (path.startsWith('assets')) {
      return AssetImage(path);
    }
    return FileImage(File(path));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final surfaceOverlay85 = colorScheme.surface.withAlpha(0xD9);
    final surfaceOverlay80 = colorScheme.surface.withAlpha(0xEF);

    return Stack(
      children: [
        Container(
          height: 192.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppDimensions.radius),
              topRight: Radius.circular(AppDimensions.radius),
            ),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: _getPetImage(pet.imageUrl),
            ),
          ),
        ),

        // عداد الحيوانات (2/1)
        if (totalPets > 1)
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
              children: [Expanded(child: PetInfoCard(pet: pet))],
            ),
          ),
        ),
      ],
    );
  }
}
