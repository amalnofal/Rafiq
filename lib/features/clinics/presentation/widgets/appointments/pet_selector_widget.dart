import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/models/pet_model.dart';
import 'package:rafiq/features/profile/presentation/widgets/pets/pet_image.dart';

class PetSelectorWidget extends StatelessWidget {
  final List<PetModel> pets;
  final String? selectedPetId;
  final ValueChanged<String> onPetSelected;

  const PetSelectorWidget({
    super.key,
    required this.pets,
    required this.selectedPetId,
    required this.onPetSelected,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final fieldBgColor =
        Theme.of(context).cardTheme.color ??
        Theme.of(context).colorScheme.surface;

    return SizedBox(
      height: 90.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: pets.length,
        separatorBuilder: (context, index) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final pet = pets[index];
          final isSelected = selectedPetId == pet.id;

          return GestureDetector(
            onTap: () => onPetSelected(pet.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 95.w,
              decoration: BoxDecoration(
                color: fieldBgColor,
                border: Border.all(
                  color: isSelected ? primaryColor : Colors.transparent,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PetImage(imageUrl: pet.imageUrl, size: 45.r),
                  SizedBox(height: 8.h),
                  Text(
                    pet.name,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: isSelected ? primaryColor : null,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
