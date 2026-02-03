import 'package:flutter/material.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/home/presentation/widgets/home_appbar/home_appbar.dart';
import 'package:rafiq/features/home/presentation/widgets/home_body/latest_medical_record_card.dart';
import 'package:rafiq/features/home/presentation/widgets/home_body/upcoming_appointment_card.dart';
import 'package:rafiq/features/home/presentation/widgets/home_body/remind_card.dart';
import 'package:rafiq/features/home/presentation/widgets/home_body/pets_carousel_section.dart';
import 'package:rafiq/features/pets/data/models/pet_model.dart';
import 'package:rafiq/features/pets/data/models/collar_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPetIndex = 0;

  // 👇 الداتا بتتحط هنا (في المستقبل هتيجي من الـ Controller/Cubit)
  final List<PetModel> myPets = [
    // 1. ماكس (عنده طوق وبياناته كاملة)
    PetModel(
      id: '1',
      name: 'ماكس',
      type: 'كلب جولدن',
      age: 3,
      imageUrl: 'assets/images/dog_max.png',
      healthStatus: 'ممتاز',
      collar: CollarModel(
        id: 'c1',
        serialNumber: '123',
        batteryLevel: 85,
        heartRate: 82,
        steps: 8547,
        temp: 38.2,
        dailyTip: "ماكس يحتاج إلى مزيد من التمارين اليوم...",
      ),

      // داتا الكروت لماكس
      lastVaccine: "تطعيم الكلب الثلاثي",
      lastVaccineDate: "15 يناير 2024",
      nextAppointment: "موعد في عيادة الرحمة",
      nextAppointmentDate: "غداً 3:00 مساءً",
      reminderTitle: "تذكير بالتطعيم",
      reminderDesc: "موعد التطعيم السنوي لماكس بعد 3 أيام",
    ),

    // 2. لونا (معندهاش طوق وبياناتها مختلفة)
    PetModel(
      id: '2',
      name: 'لونا',
      type: 'قطة شيرازي',
      age: 2,
      imageUrl: 'assets/images/cat_luna.png',
      healthStatus: 'جيد',
      collar: null,

      // داتا الكروت للونا
      lastVaccine: "فحص دوري شامل",
      lastVaccineDate: "10 يناير 2024",
      nextAppointment: "موعد في عيادة الحيوانات المتقدمة",
      nextAppointmentDate: "الأربعاء 5:00 مساءً",
      reminderTitle: "موعد العناية بالفراء",
      reminderDesc: "لونا تحتاج إلى جلسة تنظيف وتمشيط الفراء",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    
    final currentPet = myPets[_selectedPetIndex];

    return RafiqScaffold(
      appBar: homeAppBar(),
      body: SingleChildScrollView(
        clipBehavior: Clip.none,
        child: Column(
          children: [
            // 1. قسم الكاروسيل (بياخد الليستة ويغير الاندكس)
            PetsCarouselSection(
              pets: myPets,
              onPageChanged: (index) {
                setState(() {
                  _selectedPetIndex = index;
                });
              },
            ),

            // 2. الكروت السفلية (بتاخد داتا currentPet)
            LatestMedicalRecordCard(
              vaccineName: currentPet.lastVaccine,
              date: currentPet.lastVaccineDate,
            ),

            UpcomingAppointmentCard(
              title: currentPet.nextAppointment,
              time: currentPet.nextAppointmentDate,
            ),

            RemindCard(
              title: currentPet.reminderTitle,
              description: currentPet.reminderDesc,
            ),
          ],
        ),
      ),
      hasMainBottomNav: true,
    );
  }
}
