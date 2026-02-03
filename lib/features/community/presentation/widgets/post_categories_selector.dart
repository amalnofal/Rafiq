import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/enums/post_category.dart';
import 'package:rafiq/features/community/presentation/widgets/selection_chip.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class PostCategoriesSelector extends StatelessWidget {
  final List<int> selectedIds;
  final Function(int) onToggle;

  const PostCategoriesSelector({
    super.key,
    required this.selectedIds,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: AppLocalizations.of(context)!.selectPostCategoriesTitle,
              style: Theme.of(context).textTheme.bodyMedium,
              children: const [
                TextSpan(
                  text: " *",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: PostCategory.values.map((category) {
              return SelectionChip(
                label: category.getLabel(context),

                icon: category.icon,

                isSelected: selectedIds.contains(category.id),

                onTap: () => onToggle(category.id),
              );
            }).toList(),
          ),

          SizedBox(height: 12.h),
          Text(
            AppLocalizations.of(context)!.selectCategoryError,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
