import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/features/auth/presentation/widgets/next_button.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class Step5AccountType extends StatefulWidget {
  final Function(String) onTypeSelected;

  const Step5AccountType({super.key, required this.onTypeSelected});

  @override
  State<Step5AccountType> createState() => _Step5AccountTypeState();
}

class _Step5AccountTypeState extends State<Step5AccountType> {
  String _selectedType = "";

  bool _showError = false;

  void _onNextPressed() {
    if (_selectedType.isEmpty) {
      setState(() {
        _showError = true;
      });
      return;
    }
    widget.onTypeSelected(_selectedType);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context)!.chooseAccountType,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 8.h),
          Text(
            AppLocalizations.of(context)!.chooseAccountTypeSubtitle,
            style: Theme.of(context).textTheme.labelMedium,
          ),

          SizedBox(height: 24.h),

          // pet owner card
          _buildTypeCard(
            title: AppLocalizations.of(context)!.petOwnerTitle,
            subtitle: AppLocalizations.of(context)!.petOwnerSubtitle,
            svgPath: "assets/icons/pet_owner.svg",
            value: "owner",
          ),

          SizedBox(height: 16.h),

          // vet card
          _buildTypeCard(
            title: AppLocalizations.of(context)!.vetTitle,
            subtitle: AppLocalizations.of(context)!.vetSubtitle,
            svgPath: "assets/icons/vet.svg",
            value: "vet",
          ),

          NextButton(onNext: _onNextPressed),
        ],
      ),
    );
  }

  Widget _buildTypeCard({
    required String title,
    required String subtitle,
    required String svgPath,
    required String value,
  }) {
    bool isSelected = _selectedType == value;

    Color borderColor;
    if (isSelected) {
      borderColor = Theme.of(context).colorScheme.primary;
    } else if (_showError) {
      borderColor = Colors.red;
    } else {
      borderColor = Theme.of(context).colorScheme.outline;
    }

    return InkWell(
      onTap: () {
        setState(() {
          _selectedType = value;
          _showError = false;
        });
      },
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          border: Border.all(
            color: isSelected
                ? borderColor
                : Theme.of(context).colorScheme.outline,
            width: 1.5.w,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.paddingM),
                child: SvgPicture.asset(svgPath),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyLarge),
                  SizedBox(height: 6.h),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
