import 'package:rafiq/features/pets/data/models/collar_model.dart';

class PetModel {
  final String id;
  final String name;
  final String type;
  final int age;
  final String imageUrl;
  final String healthStatus;
  final CollarModel? collar;

  
  // 👇 البيانات الجديدة للكروت السفلية
  final String lastVaccine;      // اسم آخر تطعيم
  final String lastVaccineDate;  // تاريخه
  final String nextAppointment;  // عنوان الموعد القادم
  final String nextAppointmentDate; // وقته
  final String reminderTitle;    // عنوان التذكير
  final String reminderDesc;     // وصف التذكير

  PetModel({
    required this.id,
    required this.name,
    required this.type,
    required this.age,
    required this.imageUrl,
    required this.healthStatus,
    this.collar,
   

    this.lastVaccine = "تطعيم غير مسجل",
    this.lastVaccineDate = "--/--/----",

    this.nextAppointment = "لا توجد مواعيد قادمة",
    this.nextAppointmentDate = "",

    this.reminderTitle = "لا توجد تذكيرات",
    this.reminderDesc = "أليفك بصحة جيدة!",
  });
}