import 'dart:io';

/// Everything the register request needs.
class RegisterParams {
  const RegisterParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    required this.password,
    required this.confirmPassword,
    required this.gender,
    required this.role,
    required this.dateOfBirth,
    this.isHealthAndCare = false,
    this.isNutritionAndFood = false,
    this.isTrainingAndBehavior = false,
    this.isGroomingAndAppearances = false,
    this.isStoriesAndExperiences = false,
    this.isTravelAndTransport = false,
    this.isAdoptionAndRescue = false,
    this.isUpbringingAndParenting = false,
    this.specialization,
    this.subSpecialization,
    this.frontId,
    this.backId,
    this.unionCard,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String password;
  final String confirmPassword;
  final int gender;
  final String role;
  final DateTime dateOfBirth;

  final bool isHealthAndCare;
  final bool isNutritionAndFood;
  final bool isTrainingAndBehavior;
  final bool isGroomingAndAppearances;
  final bool isStoriesAndExperiences;
  final bool isTravelAndTransport;
  final bool isAdoptionAndRescue;
  final bool isUpbringingAndParenting;

  // Doctor only.
  final String? specialization;
  final String? subSpecialization;
  final File? frontId;
  final File? backId;
  final File? unionCard;
}