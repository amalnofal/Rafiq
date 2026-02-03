import 'package:flutter/material.dart';
import 'package:rafiq/l10n/app_localizations.dart';

enum PostCategory {
  health,
  food,
  training,
  grooming,
  activities,
  travel,
  adoption,
  stories;

  static PostCategory fromId(int id) {
    return PostCategory.values.firstWhere(
      (e) => e.id == id,
      orElse: () => PostCategory.health,
    );
  }
}

extension PostCategoryExtension on PostCategory {
  int get id => index + 1;

  String getLabel(BuildContext context) {
    switch (this) {
      case PostCategory.health:
        return AppLocalizations.of(context)!.categoryHealth;
      case PostCategory.food:
        return AppLocalizations.of(context)!.categoryFood;
      case PostCategory.training:
        return AppLocalizations.of(context)!.categoryTraining;
      case PostCategory.grooming:
        return AppLocalizations.of(context)!.categoryGrooming;
      case PostCategory.activities:
        return AppLocalizations.of(context)!.categoryActivities;
      case PostCategory.travel:
        return AppLocalizations.of(context)!.categoryTravel;
      case PostCategory.adoption:
        return AppLocalizations.of(context)!.categoryAdoption;
      case PostCategory.stories:
        return AppLocalizations.of(context)!.categoryStories;
    }
  }

  String get icon {
    switch (this) {
      case PostCategory.health:
        return "🏥";
      case PostCategory.training:
        return "🦮";
      case PostCategory.food:
        return "🍖";
      case PostCategory.grooming:
        return "✂️";
      case PostCategory.activities:
        return "🎾";
      case PostCategory.adoption:
        return "❤️";
      case PostCategory.travel:
        return "✈️";
      case PostCategory.stories:
        return "📖";
    }
  }

  String getSubtitle(BuildContext context) {
    switch (this) {
      case PostCategory.health:
        return AppLocalizations.of(context)!.healthSubtitle;
      case PostCategory.training:
        return AppLocalizations.of(context)!.trainingSubtitle;
      case PostCategory.food:
        return AppLocalizations.of(context)!.foodSubtitle;
      case PostCategory.grooming:
        return AppLocalizations.of(context)!.groomingSubtitle;
      case PostCategory.activities:
        return AppLocalizations.of(context)!.activitiesSubtitle;
      case PostCategory.adoption:
        return AppLocalizations.of(context)!.adoptionSubtitle;
      case PostCategory.travel:
        return AppLocalizations.of(context)!.travelSubtitle;
      case PostCategory.stories:
        return AppLocalizations.of(context)!.storiesSubtitle;
    }
  }
}
