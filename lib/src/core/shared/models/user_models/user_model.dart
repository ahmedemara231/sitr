import 'dart:convert';

import '../../../../config/language/locale_keys.g.dart';
import '../../../helpers/cache_service.dart';
import '../../../helpers/user_type_enum.dart';
import 'female_model.dart';
import 'male_model.dart';

class UserModel {
  UserModel({
    this.id,
    this.name,
    this.type,
    this.gender,
    this.countryCode,
    this.identityNumber,
    this.age,
    this.isActive,
    this.isBlocked,
    this.adminApprovalStatus,
    this.completeRegistration,
    this.token,
    this.nickName,
    this.maritalStatus,
    this.height,
    this.weight,
    this.currentJob,
    this.bio,
    this.hasChildren,
    this.numOfChildren,
    this.childCustody,
    this.wantChildren,
    this.prohibitedThings,
    this.weddingType,
    this.cityId,
    this.educationLevel,
    this.isPrayer,
    this.healthConditions,
    this.chatLang,
    this.isSmoker,
    this.tribeAffiliation,
    this.skinColor,
    this.views
  });

  static UserModel get currentUser{
    return (UserModel.fromJson(
        jsonDecode(CacheStorage.read('user'))));
  }

  static bool get isMale{
    return currentUser is MaleModel;
  }

  static bool get isFemale{
    return currentUser is FemaleModel;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final isParent = json['type']['title'] == LocaleKeys.parent;
    final user = json['gender']['title'].toString().toUserType();

    if(isParent){
     return _manageGenderWhenParent(user: user, json: json);

    }else{
      return _manageGender(user: user, json: json);
    }

  }

  static UserModel _manageGenderWhenParent({required UserType user, required Map<String, dynamic> json}){
    if(user.isMale){
      return ParentWithMaleChildModel.fromJson(json);

    }else if(user.isFemale){
      return ParentWithFemaleChildModel.fromJson(json);

    }else{
      return UserModel.initial();
    }
  }

  static UserModel _manageGender({required UserType user, required Map<String, dynamic> json}){
    if(user.isMale){
      return MaleModel.fromJson(json);

    }else if(user.isFemale){
      return FemaleModel.fromJson(json);

    }else{
      return UserModel.initial();
    }
  }

  int? id;
  String? name;
  String? phone;
  String? avatar;
  Type? type;
  Gender? gender;
  String? countryCode;
  String? identityNumber;
  int? age;
  bool? isActive;
  bool? isBlocked;
  AdminApprovalStatus? adminApprovalStatus;
  String? completeRegistration;
  String? token;
  String? nickName;
  MaritalStatus? maritalStatus;
  double? height;
  double? weight;
  String? currentJob;
  String? bio;
  bool? hasChildren;
  int? numOfChildren;
  ChildCustody? childCustody;
  bool? wantChildren;
  String? prohibitedThings;
  WeddingType? weddingType;
  CityId? cityId;
  String? educationLevel;
  bool? isPrayer;
  String? healthConditions;
  String? chatLang;
  bool? isSmoker;
  bool? tribeAffiliation;
  SkinColor? skinColor;
  ReligiousCommitment? religiousCommitment;
  int? views;

  factory UserModel.initial() => UserModel();

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    if (type != null) {
      map['type'] = type?.toJson();
    }
    if (gender != null) {
      map['gender'] = gender?.toJson();
    }
    map['country_code'] = countryCode;
    map['identity_number'] = identityNumber;
    map['age'] = age;
    map['is_active'] = isActive;
    map['is_blocked'] = isBlocked;
    if (adminApprovalStatus != null) {
      map['admin_approval_status'] = adminApprovalStatus?.toJson();
    }
    map['complete_registration'] = completeRegistration;
    map['token'] = token;
    map['nick_name'] = nickName;
    if (maritalStatus != null) {
      map['marital_status'] = maritalStatus?.toJson();
    }
    map['height'] = height;
    map['weight'] = weight;
    map['current_job'] = currentJob;
    map['bio'] = bio;
    map['has_children'] = hasChildren;
    map['num_of_children'] = numOfChildren;
    if (childCustody != null) {
      map['child_custody'] = childCustody?.toJson();
    }
    map['want_children'] = wantChildren;
    map['prohibited_things'] = prohibitedThings;
    if (weddingType != null) {
      map['wedding_type'] = weddingType?.toJson();
    }
    if (cityId != null) {
      map['city_id'] = cityId?.toJson();
    }
    map['education_level'] = educationLevel;
    map['is_prayer'] = isPrayer;
    map['health_conditions'] = healthConditions;
    map['chat_lang'] = chatLang;
    map['is_smoker'] = isSmoker;
    map['tribe_affiliation'] = tribeAffiliation;
    if (skinColor != null) {
      map['skin_color'] = skinColor?.toJson();
    }
    if (religiousCommitment != null) {
      map['religious_commitment'] = religiousCommitment?.toJson();
    }
    map['views'] = views;
    return map;
  }
}

class ReligiousCommitment {
  ReligiousCommitment({
    this.value,
    this.title,});

  ReligiousCommitment.fromJson(dynamic json) {
    value = json['value'];
    title = json['title'];
  }
  String? value;
  String? title;
  ReligiousCommitment copyWith({  String? value,
    String? title,
  }) => ReligiousCommitment(  value: value ?? this.value,
    title: title ?? this.title,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['value'] = value;
    map['title'] = title;
    return map;
  }

}

class SkinColor {
  SkinColor({
    this.value,
    this.title,});

  SkinColor.fromJson(dynamic json) {
    value = json['value'];
    title = json['title'];
  }
  String? value;
  String? title;
  SkinColor copyWith({  String? value,
    String? title,
  }) => SkinColor(  value: value ?? this.value,
    title: title ?? this.title,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['value'] = value;
    map['title'] = title;
    return map;
  }

}

class CityId {
  CityId({
    this.id,
    this.name,
    this.country,
    this.countryId,});

  CityId.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    country = json['country'];
    countryId = json['country_id'];
  }
  int? id;
  String? name;
  String? country;
  int? countryId;
  CityId copyWith({  int? id,
    String? name,
    String? country,
    int? countryId,
  }) => CityId(  id: id ?? this.id,
    name: name ?? this.name,
    country: country ?? this.country,
    countryId: countryId ?? this.countryId,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['country'] = country;
    map['country_id'] = countryId;
    return map;
  }

}

class WeddingType {
  WeddingType({
    this.value,
    this.title,});

  WeddingType.fromJson(dynamic json) {
    value = json['value'];
    title = json['title'];
  }
  String? value;
  String? title;
  WeddingType copyWith({  String? value,
    String? title,
  }) => WeddingType(  value: value ?? this.value,
    title: title ?? this.title,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['value'] = value;
    map['title'] = title;
    return map;
  }

}

class ChildCustody {
  ChildCustody({
    this.value,
    this.title,});

  ChildCustody.fromJson(dynamic json) {
    value = json['value'];
    title = json['title'];
  }
  String? value;
  String? title;
  ChildCustody copyWith({  String? value,
    String? title,
  }) => ChildCustody(  value: value ?? this.value,
    title: title ?? this.title,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['value'] = value;
    map['title'] = title;
    return map;
  }

}

class MaritalStatus {
  MaritalStatus({
    this.value,
    this.title,});

  MaritalStatus.fromJson(dynamic json) {
    value = json['value'];
    title = json['title'];
  }
  String? value;
  String? title;
  MaritalStatus copyWith({  String? value,
    String? title,
  }) => MaritalStatus(  value: value ?? this.value,
    title: title ?? this.title,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['value'] = value;
    map['title'] = title;
    return map;
  }

}

class AdminApprovalStatus {
  AdminApprovalStatus({
    this.value,
    this.title,});

  AdminApprovalStatus.fromJson(dynamic json) {
    value = json['value']?? '';
    title = json['title']?? '';
  }
  String? value;
  String? title;
  AdminApprovalStatus copyWith({  String? value,
    String? title,
  }) => AdminApprovalStatus(  value: value ?? this.value,
    title: title ?? this.title,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['value'] = value;
    map['title'] = title;
    return map;
  }

}

class Gender {
  Gender({
    this.value,
    this.title,
  });


  Gender.fromJson(dynamic json) {
    value = json['value']; // en
    title = json['title']; // ar
  }
  String? value;
  String? title;
  Gender copyWith({  String? value,
    String? title,
  }) => Gender(  value: value ?? this.value,
    title: title ?? this.title,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['value'] = value;
    map['title'] = title;
    return map;
  }

}

class Type {
  Type({
    this.value,
    this.title,});

  Type.fromJson(dynamic json) {
    value = json['value'];
    title = json['title'];
  }
  String? value;
  String? title;
  Type copyWith({  String? value,
    String? title,
  }) => Type(  value: value ?? this.value,
    title: title ?? this.title,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['value'] = value;
    map['title'] = title;
    return map;
  }

}