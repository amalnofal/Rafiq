import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/constants/text_styles.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class DailyTipCard extends StatelessWidget {
  final String message;

  const DailyTipCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingM),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("💡", style: AppTextStyles.headlineMedium()),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingS,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.dailyTip,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode
                            ? AppColors.kContentGreenDark
                            : AppColors.kContentAccentGreen,
                      ),
                    ),
                    SizedBox(height: AppDimensions.paddingXS),

                    Text(
                      message,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDarkMode
                            ? const Color(0xFF66CD8D)
                            : const Color(0xFF4E7D56),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
