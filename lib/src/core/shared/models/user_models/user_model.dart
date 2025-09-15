import 'dart:convert';
import '../../../helpers/cache_service.dart';
import '../../../helpers/user_type_enum.dart';
import 'individual/female_model.dart';
import 'individual/male_model.dart';
import 'parent/parent_model.dart';

class UserModel {
  final int? id;
  final String? name;
  final int? parentId;
  final Type? type;
  final Gender? gender;
  final String? avatar;
  final String? phone;
  final String? countryCode;
  final String? fullPhone;
  final String? identityNumber;
  final int? age;
  final bool? isActive;
  final bool? isBlocked;
  final AdminApprovalStatus? adminApprovalStatus;
  final String? completeRegistration;
  final String? token;

  const UserModel({
    this.id,
    this.name,
    this.parentId,
    this.type,
    this.gender,
    this.avatar,
    this.phone,
    this.countryCode,
    this.fullPhone,
    this.identityNumber,
    this.age,
    this.isActive,
    this.isBlocked,
    this.adminApprovalStatus,
    this.completeRegistration,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final UserType user = json['gender']['title'].toString().toUserType();
    final bool isParent = json['type']['title'].toString().toUserType().isParent;

    if(isParent){
      return ParentModel.fromJson(json);

    }else if(user.isMale){
      return MaleModel.fromJson(json);

    }else if(user.isFemale){
      return FemaleModel.fromJson(json);

    }else{
      return UserModel.initial();
    }

    // return UserModel(
    //   id: json['id'],
    //   name: json['name'],
    //   parentId: json['parent_id'],
    //   type: json['type'],
    //   gender: json['gender'],
    //   avatar: json['avatar'],
    //   phone: json['phone'],
    //   countryCode: json['country_code'],
    //   fullPhone: json['full_phone'],
    //   identityNumber: json['identity_number'],
    //   age: json['age'],
    //   isActive: json['is_active'],
    //   isBlocked: json['is_blocked'],
    //   adminApprovalStatus: json['admin_approval_status'],
    //   completeRegistration: json['complete_registration'],
    //   token: json['token'],
    // );
  }

  static bool get isMale{
    return currentUser is MaleModel;
  }

  static bool get isFemale{
    return currentUser is FemaleModel;
  }

  static bool get isParent{
    return currentUser is ParentModel;
  }

  static bool get isIndividual{
    return currentUser is! ParentModel;
  }

  static UserModel get currentUser{
    return UserModel.fromJson(
        CacheStorage.read('user', isDecoded: true)
    );
  }


  factory UserModel.initial() => const UserModel(
    id: 0,
    name: '',
    parentId: null,
    type: null,
    gender: null,
    avatar: '',
    phone: '',
    countryCode: '',
    fullPhone: '',
    identityNumber: '',
    age: 0,
    isActive: false,
    isBlocked: false,
    adminApprovalStatus: null,
    completeRegistration: '',
    token: '',
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'parent_id': parentId,
      'type': type,
      'gender': gender,
      'avatar': avatar,
      'phone': phone,
      'country_code': countryCode,
      'full_phone': fullPhone,
      'identity_number': identityNumber,
      'age': age,
      'is_active': isActive,
      'is_blocked': isBlocked,
      'admin_approval_status': adminApprovalStatus,
      'complete_registration': completeRegistration,
      'token': token,
    };
  }

  UserModel copyWith({
    int? id,
    String? name,
    int? parentId,
    Type? type,
    Gender? gender,
    String? avatar,
    String? phone,
    String? countryCode,
    String? fullPhone,
    String? identityNumber,
    int? age,
    bool? isActive,
    bool? isBlocked,
    AdminApprovalStatus? adminApprovalStatus,
    String? completeRegistration,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      type: type ?? this.type,
      gender: gender ?? this.gender,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
      fullPhone: fullPhone ?? this.fullPhone,
      identityNumber: identityNumber ?? this.identityNumber,
      age: age ?? this.age,
      isActive: isActive ?? this.isActive,
      isBlocked: isBlocked ?? this.isBlocked,
      adminApprovalStatus: adminApprovalStatus ?? this.adminApprovalStatus,
      completeRegistration: completeRegistration ?? this.completeRegistration,
      token: token ?? this.token,
    );
  }

  /// Utility: parse from raw JSON string
  static UserModel fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  /// Utility: convert to raw JSON string
  String toRawJson() => json.encode(toJson());
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

class CityModel {
  CityModel({
    this.id,
    this.name,
    this.country,
    this.countryId,
  });

  CityModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    country = json['country'];
    countryId = json['country_id'];
  }
  int? id;
  String? name;
  String? country;
  int? countryId;
  CityModel copyWith({  int? id,
    String? name,
    String? country,
    int? countryId,
  }) => CityModel(  id: id ?? this.id,
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

class MaritalStatusModel {
  MaritalStatusModel({
    this.value,
    this.title,});

  MaritalStatusModel.fromJson(dynamic json) {
    value = json['value'];
    title = json['title'];
  }
  String? value;
  String? title;
  MaritalStatusModel copyWith({  String? value,
    String? title,
  }) => MaritalStatusModel(  value: value ?? this.value,
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
  UserType? userType;

  Gender({
    this.value,
    this.title,
    this.userType,
  });

  Gender.fromJson(dynamic json) {
    value = json['value']; // en
    title = json['title']; // ar,
    userType = (json['title'] as String).toUserType();
  }
  String? value;
  String? title;
  Gender copyWith({
    String? value,
    String? title,
  }) => Gender(
    value: value ?? this.value,
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