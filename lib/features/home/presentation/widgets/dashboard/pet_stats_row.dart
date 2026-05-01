import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/collar_data_card.dart';
import 'package:rafiq/features/collar/data/models/collar_model.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class PetStatsRow extends StatelessWidget {
  final CollarModel collar;

  const PetStatsRow({super.key, required this.collar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 1. كارت النبض
          CollarDataCard(
            title: AppLocalizations.of(context)!.pulse,
            value: "${collar.heartRate}",
            icon: "assets/icons/heart.svg",
            color: const Color(0xFFFB2C36),
          ),

          SizedBox(width: AppDimensions.paddingS),

          // 2. كارت النشاط
          CollarDataCard(
            title: AppLocalizations.of(context)!.activity,
            value: "${collar.steps}",
            icon: "assets/icons/activity.svg",
            color: const Color(0xFF2B7FFF),
          ),

          SizedBox(width: AppDimensions.paddingS),

          // 3. كارت الحرارة
          CollarDataCard(
            title: AppLocalizations.of(context)!.temperature,
            value: "${collar.temp}°",
            icon: "assets/icons/temp.svg",
            color: const Color(0xFFFF6900),
          ),
        ],
      ),
    );
  }
}
