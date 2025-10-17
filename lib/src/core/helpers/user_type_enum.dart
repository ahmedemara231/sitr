import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'cache_service.dart';
import '../shared/models/user_models/user_model.dart';

enum UserType{male, female, parent, unauthenticated}

extension Check on UserType{
  bool get isMale => this == UserType.male;
  bool get isFemale => this == UserType.female;
  bool get isIndividual => this == UserType.male || this == UserType.female;
  bool get isParent => this == UserType.parent;
  bool get isAuthenticated => this != UserType.unauthenticated;
}

class UserTypeHelper{

  static UserType? get currentType => UserModel.currentUser.gender?.userType;

  static bool get isAuthenticated{
    return currentType?.isAuthenticated ?? false;
  }

  static FutureOr<void> make({
    FutureOr<void> Function()? onMale,
    FutureOr<void> Function()? onFemale,
    FutureOr<void> Function()? onParent,
    FutureOr<void> Function()? onGuest,
}){
    switch(currentType){
      case UserType.male:
        return onMale?.call();

      case UserType.female:
        return onFemale?.call();

      case UserType.parent:
        return onParent?.call();

      default:
        return onGuest?.call();
    }
  }


  static Widget drowWidget({
    required Widget Function(UserType? current) drow,
  }){
    return drow.call(currentType);
  }
}