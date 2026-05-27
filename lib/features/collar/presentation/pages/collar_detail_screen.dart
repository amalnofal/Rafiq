import 'package:flutter/material.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/collar/presentation/widgets/collar_detail_header.dart';
import 'package:rafiq/features/collar/presentation/widgets/collar_state_card.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/detailed_statistics/heart_rate_detailed_card.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/detailed_statistics/location_detailed_card.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/detailed_statistics/temperature_detailed_card.dart';

class CollarDetailScreen extends StatelessWidget {
  final Map<String, dynamic> collarData;

  const CollarDetailScreen({super.key, required this.collarData});

  @override
  Widget build(BuildContext context) {
    return RafiqScaffold(
      padding: EdgeInsets.zero,
      body: Column(
        children: [
          CollarDetailHeader(
            collarData: collarData,
            onBackTap: () {
              Navigator.pop(context);
            },
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.paddingS),
                child: Column(
                  children: [
                    CollarStateCard(collarData: collarData),
                    HeartRateDetailedCard(),
                    TemperatureDetailedCard(),
                    LocationDetailedCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
