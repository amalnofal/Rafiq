import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class SignupRules extends StatelessWidget {
  const SignupRules({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: AppDimensions.padding),
      padding: EdgeInsets.all(AppDimensions.padding),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(
          color: AppColors.kBrandPrimary.withAlpha(30),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.termsAgreementStart,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: AppLocalizations.of(context)!.termsAndConditions,

                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Navigator.pushNamed(context, '/rules');
                    },
                ),

                TextSpan(text: AppLocalizations.of(context)!.and),

                TextSpan(
                  text: AppLocalizations.of(context)!.privacyPolicy,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Navigator.pushNamed(context, '/privacy');
                    },
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
