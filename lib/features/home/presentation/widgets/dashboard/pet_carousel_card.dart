import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/models/pet_model.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/profile/presentation/widgets/pets/pet_info_card.dart';

class PetCarouselCard extends StatelessWidget {
  const PetCarouselCard({
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
    final surfaceOverlay85 = colorScheme.surface.withValues(alpha: 0.85);
    final surfaceOverlay80 = colorScheme.surface.withValues(alpha: 0.80);

    return CustomContainer(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image: _getPetImage(pet.imageUrl),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  "assets/images/pet_placeholder.png",
                  fit: BoxFit.cover,
                );
              },
            ),
          ),

          // عداد الحيوانات
          if (totalPets > 1)
            Positioned(
              top: AppDimensions.paddingM,
              left: Directionality.of(context) == TextDirection.ltr
                  ? AppDimensions.paddingM
                  : null,
              right: Directionality.of(context) == TextDirection.rtl
                  ? AppDimensions.paddingM
                  : null,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: surfaceOverlay85,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
                child: Text(
                  "${currentIndex + 1} / $totalPets",
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

          Positioned(
            bottom: 12.h,
            left: 12.w,
            right: 12.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: surfaceOverlay80,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Expanded(child: PetInfoCard(pet: pet, isInline: true)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
