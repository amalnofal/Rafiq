import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/pet_provider.dart';
import 'package:rafiq/core/controller/collar_provider.dart';
import 'package:rafiq/core/models/pet_model.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/detailed_statistics/location_detailed_card.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/latest_medical_record_card.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/upcoming_appointment_card.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/pets_carousel_section.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/pet_stats_row.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/no_collar_card.dart';
import 'package:rafiq/features/collar/presentation/widgets/ai_diagnosis_card.dart';

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
  late CollarProvider _collarProvider;

  @override
  void initState() {
    super.initState();
    _collarProvider = context.read<CollarProvider>();
    _startPolling(widget.currentPet);
  }

  void _startPolling(PetModel pet) {
    if (pet.collarId == null || pet.collarId!.isNotEmpty == false) return;

    final petId = int.tryParse(pet.id.toString()) ?? 0;
    if (petId != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _collarProvider.startPolling(petId);
        _collarProvider.fetchAiDiagnosis(petId);
      });
    }
  }

  @override
  void didUpdateWidget(covariant HomeDashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldHasCollar =
        oldWidget.currentPet.collarId != null &&
        oldWidget.currentPet.collarId!.isNotEmpty;
    final newHasCollar =
        widget.currentPet.collarId != null &&
        widget.currentPet.collarId!.isNotEmpty;

    if (!oldHasCollar && newHasCollar) {
      _startPolling(widget.currentPet);
    } else if (oldHasCollar && !newHasCollar) {
      _collarProvider.stopPolling();
    }
  }

  @override
  void dispose() {
    _collarProvider.stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petProvider = context.watch<PetProvider>();
    final collarProvider = context.watch<CollarProvider>();

    final bool hasCollar =
        widget.currentPet.collarId != null &&
        widget.currentPet.collarId!.isNotEmpty;

    return Column(
      children: [
        SizedBox(height: 12.h),

        // 1. الكاروسيل
        PetsCarouselSection(
          pets: widget.pets,
          onPageChanged: (index) {
            widget.onPetChanged(index);
            context.read<CollarProvider>().stopPolling();
            _startPolling(widget.pets[index]);
          },
        ),
        SizedBox(height: 8.h),

        // 2. كروت الطوق
        if (hasCollar) ...[
          const PetStatsRow(),

          LocationDetailedCard(
            latitude: collarProvider.latestReading?.latitude ?? 0.0,
            longitude: collarProvider.latestReading?.longitude ?? 0.0,
          ),

          if (collarProvider.isAiLoading)
            Padding(
              padding: EdgeInsets.all(30.r),
              child: const CircularProgressIndicator(),
            )
          else if (collarProvider.aiDiagnosis != null)
            AiDiagnosisCard(diagnosis: collarProvider.aiDiagnosis!)
          else if (collarProvider.aiErrorMessage != null)
            Padding(
              padding: EdgeInsets.all(20.r),
              child: Text(
                collarProvider.aiErrorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
        ] else ...[
          const NoCollarCard(),
        ],

        // 3. السجلات والمواعيد
        LatestMedicalRecordCard(records: petProvider.medicalRecords),
        UpcomingAppointmentCard(appointments: petProvider.upcomingAppointments),
      ],
    );
  }
}
