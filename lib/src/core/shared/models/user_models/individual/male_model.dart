import 'dart:io';

import '../../../../extensions/object.dart';
import '../../title_value_shape.dart' show TitleValueShape;
import '../user_model.dart';
import 'individual_user_model.dart';

class MaleModel extends IndividualUserModel {
  MaleModel({
    super.id,
    super.name,
    super.parentId,
    super.type,
    super.gender,
    super.avatar,
    super.phone,
    super.countryCode,
    super.fullPhone,
    super.identityNumber,
    super.age,
    super.isActive,
    super.isBlocked,
    super.adminApprovalStatus,
    super.completeRegistration,
    super.token,
    super.nickName,
    super.maritalStatus,
    super.height,
    super.weight,
    super.currentJob,
    super.bio,
    super.hasChildren,
    super.numOfChildren,
    super.childCustody,
    super.wantChildren,
    super.prohibitedThings,
    super.dowryMin,
    super.dowryMax,
    super.weddingType,
    super.cityId,
    super.educationLevel,
    super.isPrayer,
    super.healthConditions,
    super.chatLang,
    super.isSmoker,
    super.tribeAffiliation,
    super.skinColor,
    super.religiousCommitment,
    super.views,
    super.isNotify,
  });

  factory MaleModel.initial() => MaleModel(
    name: '',
    age: 0,
    gender: Gender(),
  );

  factory MaleModel.fromJson(Map<String, dynamic> json) {
    return MaleModel(
      id: json['id'],
      name: json['name'],
      parentId: json['parent_id'],
      type: TitleValueShape.fromJson(json['type']),
      gender: Gender.fromJson(json['gender']),
      avatar: json['avatar'],
      phone: json['phone'],
      countryCode: json['country_code'],
      fullPhone: json['full_phone'],
      identityNumber: json['identity_number'],
      age: json['age'],
      isActive: json['is_active'],
      isBlocked: json['is_blocked'],

      token: json['token'],
      nickName: json['nick_name'],

      height: json['height'],
      weight: json['weight'],
      currentJob: json['current_job'],
      bio: json['bio'],
      hasChildren: json['has_children'],
      numOfChildren: json['num_of_children'],

      wantChildren: json['want_children'],
      prohibitedThings: json['prohibited_things'],
      dowryMin: json['dowry_min'],
      dowryMax: json['dowry_max'],

      adminApprovalStatus: TitleValueShape.fromJson(json['admin_approval_status']),
      completeRegistration: json['complete_registration'],

      maritalStatus: (json['marital_status'] as Object?).isNull? null :
      TitleValueShape.fromJson(json['marital_status']),

      weddingType: (json['wedding_type'] as Object?).isNull? null :
      TitleValueShape.fromJson(json['wedding_type']),

      cityId: (json['city_id'] as Object?).isNull? null :
      CityModel.fromJson(json['city_id']),

      religiousCommitment: (json['religious_commitment'] as Object?).isNull? null :
      TitleValueShape.fromJson(json['religious_commitment']),

      childCustody: (json['child_custody'] as Object?).isNull? null :
      TitleValueShape.fromJson(json['child_custody']),

      educationLevel: json['education_level'],
      isPrayer: json['is_prayer'],
      healthConditions: json['health_conditions'],
      chatLang: json['chat_lang'],
      isSmoker: json['is_smoker'],
      tribeAffiliation: json['tribe_affiliation'],
      skinColor: (json['skin_color'] as Object?).isNotNull? TitleValueShape.fromJson(json['skin_color']) : null,
      views: json['views'],
    );
  }

  @override
  Map<String, dynamic> toRequestBodyJson() {
    return super.toRequestBodyJson()..addAll({
      'name' : name,
      'gender' : gender?.titleValueShape?.value,
      'age' : age,
      'phone' : phone,
      'identity_number' : identityNumber,
      'avatar' : avatar.isNotNull? File(avatar!) : null,
      'religious_commitment': religiousCommitment,
    });
  }
  @override
  MaleModel copyWith({
    String? nickName,
    bool? isNotify,
    TitleValueShape? maritalStatus,
    int? height,
    int? weight,
    String? currentJob,
    String? bio,
    bool? hasChildren,
    int? numOfChildren,
    TitleValueShape? childCustody,
    bool? wantChildren,
    String? prohibitedThings,
    int? dowryMin,
    int? dowryMax,
    TitleValueShape? weddingType,
    CityModel? cityId,
    String? educationLevel,
    bool? isPrayer,
    String? healthConditions,
    String? chatLang,
    bool? isSmoker,
    bool? tribeAffiliation,
    TitleValueShape? skinColor,
    TitleValueShape? religiousCommitment,
    int? views,
    int? id, String? name, int? parentId, TitleValueShape? type, Gender? gender, String? avatar, String? phone, String? countryCode, String? fullPhone, String? identityNumber, int? age, bool? isActive, bool? isBlocked, TitleValueShape? adminApprovalStatus, String? completeRegistration, String? token}) {
    return MaleModel(
      id: id?? this.id,
      name: name?? this.name,
      parentId: parentId?? this.parentId,
      type: type?? this.type,
      gender: gender??this.gender,
      avatar: avatar??this.avatar,
      phone: phone??this.phone,
      countryCode: countryCode??this.countryCode,
      fullPhone: fullPhone??this.fullPhone,
      identityNumber: identityNumber??identityNumber,
      age: age??this.age,
      isActive: isActive??this.isActive,
      isBlocked: isBlocked??this.isBlocked,
      adminApprovalStatus: adminApprovalStatus??this.adminApprovalStatus,
      completeRegistration: completeRegistration??this.completeRegistration,
      token: token??this.token,
      nickName: nickName ?? this.nickName,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      currentJob: currentJob ?? this.currentJob,
      bio: bio ?? this.bio,
      hasChildren: hasChildren ?? this.hasChildren,
      numOfChildren: numOfChildren ?? this.numOfChildren,
      childCustody: childCustody ?? this.childCustody,
      wantChildren: wantChildren ?? this.wantChildren,
      prohibitedThings: prohibitedThings ?? this.prohibitedThings,
      dowryMin: dowryMin ?? this.dowryMin,
      dowryMax: dowryMax ?? this.dowryMax,
      weddingType: weddingType ?? this.weddingType,
      cityId: cityId ?? this.cityId,
      educationLevel: educationLevel ?? this.educationLevel,
      isPrayer: isPrayer ?? this.isPrayer,
      healthConditions: healthConditions ?? this.healthConditions,
      chatLang: chatLang ?? this.chatLang,
      isSmoker: isSmoker ?? this.isSmoker,
      tribeAffiliation: tribeAffiliation ?? this.tribeAffiliation,
      skinColor: skinColor ?? this.skinColor,
      religiousCommitment: religiousCommitment ?? this.religiousCommitment,
      views: views ?? this.views,
      isNotify: isNotify ?? this.isNotify,
    );
  }

  MaleModel merge(MaleModel otherMaleModel){
    return MaleModel(
      id: id?? otherMaleModel.id,
      name: name?? otherMaleModel.name,
      parentId: parentId?? otherMaleModel.parentId,
      type: type?? otherMaleModel.type,
      gender: gender??otherMaleModel.gender,
      avatar: avatar??otherMaleModel.avatar,
      phone: phone??otherMaleModel.phone,
      countryCode: countryCode??otherMaleModel.countryCode,
      fullPhone: fullPhone??otherMaleModel.fullPhone,
      identityNumber: identityNumber??identityNumber,
      age: age??otherMaleModel.age,
      isActive: isActive??otherMaleModel.isActive,
      isBlocked: isBlocked??otherMaleModel.isBlocked,
      adminApprovalStatus: adminApprovalStatus??otherMaleModel.adminApprovalStatus,
      completeRegistration: completeRegistration??otherMaleModel.completeRegistration,
      token: token??otherMaleModel.token,
      nickName: nickName ?? otherMaleModel.nickName,
      maritalStatus: maritalStatus ?? otherMaleModel.maritalStatus,
      height: height ?? otherMaleModel.height,
      weight: weight ?? otherMaleModel.weight,
      currentJob: currentJob ?? otherMaleModel.currentJob,
      bio: bio ?? otherMaleModel.bio,
      hasChildren: hasChildren ?? otherMaleModel.hasChildren,
      numOfChildren: numOfChildren ?? otherMaleModel.numOfChildren,
      childCustody: childCustody ?? otherMaleModel.childCustody,
      wantChildren: wantChildren ?? otherMaleModel.wantChildren,
      prohibitedThings: prohibitedThings ?? otherMaleModel.prohibitedThings,
      dowryMin: dowryMin ?? otherMaleModel.dowryMin,
      dowryMax: dowryMax ?? otherMaleModel.dowryMax,
      weddingType: weddingType ?? otherMaleModel.weddingType,
      cityId: cityId ?? otherMaleModel.cityId,
      educationLevel: educationLevel ?? otherMaleModel.educationLevel,
      isPrayer: isPrayer ?? otherMaleModel.isPrayer,
      healthConditions: healthConditions ?? otherMaleModel.healthConditions,
      chatLang: chatLang ?? otherMaleModel.chatLang,
      isSmoker: isSmoker ?? otherMaleModel.isSmoker,
      tribeAffiliation: tribeAffiliation ?? otherMaleModel.tribeAffiliation,
      skinColor: skinColor ?? otherMaleModel.skinColor,
      religiousCommitment: religiousCommitment ?? otherMaleModel.religiousCommitment,
      views: views ?? otherMaleModel.views,
      isNotify: isNotify ?? otherMaleModel.isNotify,
    );
  }

}
