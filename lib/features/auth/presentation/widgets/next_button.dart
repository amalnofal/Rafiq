import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class NextButton extends StatelessWidget {
  final VoidCallback onNext;

  const NextButton({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24.h),
      child: CustomButton(
        title: AppLocalizations.of(context)!.next,
        onPressed: onNext,
      ),
    );
  }
}
