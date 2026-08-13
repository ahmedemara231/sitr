part of '../../../imports.dart';

enum _ProfileFormStep {
  gender,
  mainInformation,
  personalDetails,
  familyAndMarriage,
  lifestyleAndHealth,
  faithAndPreferences,
}

extension _ProfileFormStepX on _ProfileFormStep {
  String get title {
    switch (this) {
      case _ProfileFormStep.gender:
        return LocaleKeys.gender;
      case _ProfileFormStep.mainInformation:
        return LocaleKeys.mainInformation;
      case _ProfileFormStep.personalDetails:
        return LocaleKeys.personalDetails;
      case _ProfileFormStep.familyAndMarriage:
        return LocaleKeys.familyAndMarriage;
      case _ProfileFormStep.lifestyleAndHealth:
        return LocaleKeys.lifestyleAndHealth;
      case _ProfileFormStep.faithAndPreferences:
        return LocaleKeys.faithAndPreferences;
    }
  }

  String get iconPath {
    switch (this) {
      case _ProfileFormStep.gender:
        return Assets.assets.svg.parentIcon.path;
      case _ProfileFormStep.mainInformation:
        return Assets.assets.svg.user.path;
      case _ProfileFormStep.personalDetails:
        return Assets.assets.svg.tallIcon.path;
      case _ProfileFormStep.familyAndMarriage:
        return Assets.assets.svg.parentChildren.path;
      case _ProfileFormStep.lifestyleAndHealth:
        return Assets.assets.svg.hospital.path;
      case _ProfileFormStep.faithAndPreferences:
        return Assets.assets.svg.prey.path;
    }
  }
}
