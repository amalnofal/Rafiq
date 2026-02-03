import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/features/community/presentation/widgets/selection_chip.dart';
import 'package:rafiq/l10n/app_localizations.dart'; 

class ChoosePetCard extends StatelessWidget {
  // 1. استقبال البيانات من الصفحة الأب (التي ستجلبها من الـ API)
  final List<Map<String, dynamic>> pets;
  final String? selectedPetName;
  final Function(String?) onPetSelected;

  const ChoosePetCard({
    super.key,
    required this.pets,
    required this.selectedPetName,
    required this.onPetSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.tagPetTitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 12.h),

          // 2. استخدام Wrap لعرض الحيوانات بشكل ديناميكي
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12.w,
            runSpacing: 10.h,
            children: pets.map((pet) {
              final String name = pet['name'] ?? "";
              final String emoji = pet['emoji'] ?? "🐾";
              final bool isSelected = selectedPetName == name;

              return SelectionChip(
                label: name,
                icon: emoji,
                isSelected: isSelected,
                onTap: () {
                  onPetSelected(isSelected ? null : name);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
