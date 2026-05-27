import 'package:flutter/material.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';

class OnboardingModel {
  final String image;
  final String title;
  final String description;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.description,
  });

  static List<OnboardingModel> onboardingList(BuildContext context) => [
    OnboardingModel(
      image: 'assets/images/onboarding1.png',
      title: context.l10n.onboarding_title_1,
      description: context.l10n.onboarding_desc_1,
    ),
    OnboardingModel(
      image: 'assets/images/onboarding2.png',
      title: context.l10n.onboarding_title_2,
      description: context.l10n.onboarding_desc_2,
    ),
    OnboardingModel(
      image: 'assets/images/onboarding3.png',
      title: context.l10n.onboarding_title_3,
      description: context.l10n.onboarding_desc_3,
    ),
  ];
}
