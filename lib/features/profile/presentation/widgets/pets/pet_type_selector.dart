import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class PetTypeSelector extends StatelessWidget {
  final int? selectedType;
  final Function(int) onTypeSelected;
  final String? errorText;
  final bool readOnly;

  const PetTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
    this.errorText,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> types = [
      {'id': 1, 'label': l10n.dog},
      {'id': 2, 'label': l10n.cat},
      {'id': 3, 'label': l10n.bird},
      {'id': 4, 'label': l10n.rabbit},
      {'id': 5, 'label': l10n.turtle},
      {'id': 6, 'label': l10n.other},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: types.map((type) {
            bool isSelected = selectedType == type['id'];

            if (readOnly && !isSelected) return const SizedBox.shrink();

            return GestureDetector(
              onTap: readOnly ? null : () => onTypeSelected(type['id']),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(
                          context,
                        ).colorScheme.surfaceContainer.withValues(alpha: 0.2)
                      : (readOnly
                            ? Theme.of(context).cardTheme.color
                            : Theme.of(context).cardColor),

                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  type['label'],
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: isSelected ? FontWeight.w500 : null,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (errorText != null && !readOnly)
          Padding(
            padding: EdgeInsets.only(top: 8.h, right: 8.w),
            child: Text(
              errorText!,
              style: TextStyle(color: Colors.red, fontSize: 12.sp),
            ),
          ),
      ],
    );
  }
}
