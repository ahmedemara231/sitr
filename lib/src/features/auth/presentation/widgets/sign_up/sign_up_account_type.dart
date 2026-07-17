part of '../../../imports.dart';

enum _SignUpAccountType {
  male(gender: UserGender.male, type: UserType.individual),
  female(gender: UserGender.female, type: UserType.individual),
  parent(gender: UserGender.unknown, type: UserType.parent);

  const _SignUpAccountType({
    required this.gender,
    required this.type,
  });

  final UserGender gender;
  final UserType type;

  String get title {
    switch (this) {
      case _SignUpAccountType.male:
        return LocaleKeys.male;
      case _SignUpAccountType.female:
        return LocaleKeys.female;
      case _SignUpAccountType.parent:
        return LocaleKeys.parent;
    }
  }

  String get formKey => '${type.name}_${gender.name}';
}
