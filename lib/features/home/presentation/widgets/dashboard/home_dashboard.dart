import 'package:flutter/material.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/latest_medical_record_card.dart'; // تأكدي من المسارات
import 'package:rafiq/features/home/presentation/widgets/dashboard/upcoming_appointment_card.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/remind_card.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/pets_carousel_section.dart';
import 'package:rafiq/features/profile/data/models/pet_model.dart';

class HomeDashboard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        PetsCarouselSection(pets: pets, onPageChanged: onPetChanged),

        LatestMedicalRecordCard(records: []),

        UpcomingAppointmentCard(appointments: []),

        if (currentPet.reminderTitle.trim().isNotEmpty)
          RemindCard(
            title: currentPet.reminderTitle,
            description: currentPet.reminderDesc,
          ),
      ],
    );
  }
}
