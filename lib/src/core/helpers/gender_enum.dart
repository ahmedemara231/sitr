import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'cache_service.dart';
import '../shared/models/user_model.dart';

enum Gender{male, female, parent}

extension Check on Gender{
  bool get isMale => this == Gender.male;
  bool get isFemale => this == Gender.female;
  bool get isParent => this == Gender.parent;
}

class GenderHelper{
  static Gender get currentGender{
    // return (UserModel.fromJson(jsonDecode(CacheStorage.read('user')))).gender;
    return Gender.male;
  }

  static FutureOr<void> make({
    FutureOr<void> Function()? onMale,
    FutureOr<void> Function()? onFemale,
    FutureOr<void> Function()? onParent,
}){
    switch(currentGender){
      case Gender.male:
        return onMale?.call();

      case Gender.female:
        return onFemale?.call();

      case Gender.parent:
        return onParent?.call();
    }
  }


  static Widget drowWidget({
    required Widget Function(Gender currentGender) drow,
  }){
    return drow.call(currentGender);
  }
}