import 'dart:convert';
import '../../../extensions/object.dart';
import '../../../helpers/cache_service.dart';
import '../../../helpers/user_type_enum.dart';
import '../title_value_shape.dart';
import 'individual/female_model.dart';
import 'individual/male_model.dart';
import 'parent/parent_model.dart';

class UserModel {
  final int? id;
  final String? name;
  final int? parentId;
  final TitleValueShape? type;
  final Gender? gender;
  final String? avatar;
  final String? phone;
  final String? countryCode;
  final String? fullPhone;
  final String? identityNumber;
  final int? age;
  final bool? isActive;
  final bool? isBlocked;
  final TitleValueShape? adminApprovalStatus;
  final String? completeRegistration;
  final String? token;
  final bool? isNotify;

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
    this.isNotify
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final bool isParent = json['type']['value'].toString() == 'parent';
    final UserType user = json['gender']['value'].toString().toUserType();

    // log(json['gender']['value']);
    // log(json['gender']['value'].toString().toUserType().toString());
    // log(json.toString());

    if(isParent){
      return ParentModel.fromJson(json);

    }else {
      if(user.isMale){
        return MaleModel.fromJson(json);

      }else if(user.isFemale){
        return FemaleModel.fromJson(json);

      }else{
        return UserModel.initial();
      }
    }
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

  static bool get isAuthenticated{
    return currentUser.isNotNull;
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
    isNotify: false
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'parent_id': parentId,
      'type': type,
      'gender': gender?.toJson(),
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
      'is_notify': isNotify,
    };
  }

  UserModel copyWith({
    int? id,
    String? name,
    int? parentId,
    TitleValueShape? type,
    Gender? gender,
    String? avatar,
    String? phone,
    String? countryCode,
    String? fullPhone,
    String? identityNumber,
    int? age,
    bool? isActive,
    bool? isBlocked,
    TitleValueShape? adminApprovalStatus,
    String? completeRegistration,
    String? token,
    bool? isNotify,
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
      isNotify: isNotify ?? this.isNotify,
    );
  }

  /// Utility: parse from raw JSON string
  static UserModel fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  /// Utility: convert to raw JSON string
  String toRawJson() => json.encode(toJson());
}


class Gender {
  UserType? userType;
  TitleValueShape? titleValueShape;

  Gender({
    this.titleValueShape,
    this.userType,
  });

  Gender.fromJson(dynamic json) {
    titleValueShape = TitleValueShape.fromJson(json);
    userType = (json['value'] as String).toUserType();
  }

  Gender copyWith({
    TitleValueShape? titleValueShape,
  }) => Gender(
      titleValueShape: titleValueShape ?? this.titleValueShape
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['value'] = titleValueShape?.value;
    map['title'] = titleValueShape?.title;
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
