import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/pet_provider.dart';
import 'package:rafiq/core/models/pet_model.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/detailed_statistics/heart_rate_detailed_card.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/detailed_statistics/location_detailed_card.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/detailed_statistics/temperature_detailed_card.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/latest_medical_record_card.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/upcoming_appointment_card.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/remind_card.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/pets_carousel_section.dart';

class HomeDashboard extends StatefulWidget {
  final List<PetModel> pets;
  final PetModel currentPet;
  final Function(int) onPetChanged;

  const HomeDashboard({
    super.key,
    required this.pets,
    required this.currentPet,
    required this.onPetChanged,
  });

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final ValueNotifier<bool> isStatsExpanded = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final petProvider = context.watch<PetProvider>();

    return ChangeNotifierProvider<ValueNotifier<bool>>.value(
      value: isStatsExpanded,
      child: Column(
        children: [
          SizedBox(height: 4.h),
          PetsCarouselSection(
            pets: widget.pets,
            onPageChanged: (index) {
              isStatsExpanded.value = false;

              widget.onPetChanged(index);
            },
          ),

          // الاحصائيات المفصلة
          ValueListenableBuilder<bool>(
            valueListenable: isStatsExpanded,
            builder: (context, isExpanded, child) {
              return AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: isExpanded
                    ? _buildDetailedStatsContent()
                    : const SizedBox.shrink(),
              );
            },
          ),
          SizedBox(height: 4.h),
          LatestMedicalRecordCard(records: petProvider.medicalRecords),

          UpcomingAppointmentCard(
            appointments: petProvider.upcomingAppointments,
          ),

          if (widget.currentPet.reminderTitle.trim().isNotEmpty)
            RemindCard(
              title: widget.currentPet.reminderTitle,
              description: widget.currentPet.reminderDesc,
            ),
        ],
      ),
    );
  }

  Widget _buildDetailedStatsContent() {
    return Column(
      children: [
        const HeartRateDetailedCard(),
        TemperatureDetailedCard(),
        LocationDetailedCard(),
      ],
    );
  }
}
