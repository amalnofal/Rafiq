import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/helper/validation_helper.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class PetSpecsRow extends StatelessWidget {
  final TextEditingController weightController;
  final TextEditingController colorController;
  final VoidCallback onAddWeight;
  final VoidCallback onRemoveWeight;
  final String? weightError;
  final bool isColorReadOnly;

  const PetSpecsRow({
    super.key,
    required this.weightController,
    required this.colorController,
    required this.onAddWeight,
    required this.onRemoveWeight,
    this.weightError,
    this.isColorReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Weight
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.weightLabel,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 4.h),
              Stack(
                alignment: Alignment.center,
                children: [
                  CustomTextField(
                    controller: weightController,
                    textAlign: TextAlign.center,
                    errorText: weightError,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (val) =>
                        ValidationHelper.validatePetAttribute(val, context),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 65.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStepButton(Icons.add, onAddWeight, context),
                        _buildStepButton(Icons.remove, onRemoveWeight, context),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(width: 12.w),

        // Color
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.colorLabel,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 4.h),
              CustomTextField(
                hintText: l10n.colorHint,
                controller: colorController,
                readOnly: isColorReadOnly,
                validator: (val) =>
                    ValidationHelper.validatePetAttribute(val, context),
                rejectNumbers: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepButton(
    IconData icon,
    VoidCallback onPressed,
    BuildContext context,
  ) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 18.sp,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
