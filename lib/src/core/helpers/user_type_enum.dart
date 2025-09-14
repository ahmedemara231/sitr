import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../config/language/locale_keys.g.dart';
import 'cache_service.dart';
import '../shared/models/user_models/user_model.dart';

enum UserType{male, female, parent, unauthenticated}

extension Check on UserType{
  bool get isMale => this == UserType.male;
  bool get isFemale => this == UserType.female;
  bool get isParent => this == UserType.parent;
  bool get isAuthenticated => this != UserType.unauthenticated;
}

extension Parse on String{
  UserType toUserType(){
    log(this);
    if(this == LocaleKeys.male){
      return UserType.male;

    }else if(this == LocaleKeys.female){
      return UserType.female;

    }else if(this == LocaleKeys.parent){
      return UserType.parent;

    }else{
      return UserType.unauthenticated;
    }
  }
}

class UserTypeHelper{

  static UserType? get currentType{
    final UserModel user = (UserModel.fromJson(
        jsonDecode(CacheStorage.read('user'))));

    log('user.gender ${user.gender?.toJson()}');
    log('user.gender ${user.runtimeType}');

    return user.gender!.title!.toUserType();
  }

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