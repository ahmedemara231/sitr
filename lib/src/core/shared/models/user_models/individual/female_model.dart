import 'dart:developer';

import '../../../../../features/auth/models/dowry.dart';
import '../../../../../features/auth/models/kinship.dart';
import '../../../../extensions/object.dart';
import '../../title_value_shape.dart';
import '../user_model.dart';
import 'individual_user_model.dart';


class FemaleModel extends IndividualUserModel {
  final TitleValueShape? hijab;
  final bool? acceptsPolygamy;
  final String? preferredResidenceAfterMarriage;
  final String? guardianName;
  final String? guardianPhone;
  final String? guardianCountryCode;
  final Kinship? guardianRelation;

  FemaleModel({
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
    super.dowry,
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

    this.hijab,
    this.acceptsPolygamy,
    this.preferredResidenceAfterMarriage,
    this.guardianName,
    this.guardianPhone,
    this.guardianCountryCode,
    this.guardianRelation,
  });

  factory FemaleModel.initial() => FemaleModel(
    name: '',
    age: 0,
    gender: Gender(),
    hijab: TitleValueShape.initial(),
    acceptsPolygamy: false,
    preferredResidenceAfterMarriage: '',
    guardianName: '',
    guardianPhone: '',
    guardianCountryCode: '',
    guardianRelation: Kinship(id: 0, value: ''),
  );


  factory FemaleModel.fromJson(Map<String, dynamic> json) {
    return FemaleModel(
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

      isNotify: json['is_notify'],
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
      height: json['height'].toString(),
      weight: json['weight'].toString(),

      currentJob: json['current_job'],
      bio: json['bio'],
      hasChildren: json['has_children'],
      numOfChildren: json['num_of_children'].toString(),
      wantChildren: json['want_children'],
      prohibitedThings: json['prohibited_things'],

      dowry: ((json['dowry_min'] as Object?).isNotNull && (json['dowry_max'] as Object?).isNotNull)?
      Dowry(from: json['dowry_min'].toString(), to: json['dowry_max'].toString()) : null,

      educationLevel: json['education_level'],
      isPrayer: json['is_prayer'],
      healthConditions: json['health_conditions'],
      chatLang: json['chat_lang'],
      isSmoker: json['is_smoker'],
      tribeAffiliation: json['tribe_affiliation'],
      skinColor: (json['skin_color'] as Object?).isNotNull?
      TitleValueShape.fromJson(json['skin_color']) : null,
      views: json['views'],
      hijab: (json['hijab'] as Object?).isNotNull?
      TitleValueShape.fromJson(json['hijab']) : null,
      acceptsPolygamy: json['accepts_polygamy'],
      preferredResidenceAfterMarriage: json['preferred_residence_after_marriage'],
      guardianName: json['guardian_name'],
      guardianPhone: json['guardian_phone'],
      guardianCountryCode: json['guardian_country_code'],
      guardianRelation: (json['guardian_relation'] as Object?).isNotNull?
      Kinship.fromJson(json['guardian_relation']) : null
    );
  }

  @override
  Map<String, dynamic> toRequestBodyJson() {
    return super.toRequestBodyJson()..addAll({
      'preferred_residence_after_marriage': preferredResidenceAfterMarriage,
      'hijab': hijab?.value,
      'accepts_polygamy': acceptsPolygamy,

      'guardian_name': guardianName,
      'guardian_phone': guardianPhone,
      'guardian_relation_id': guardianRelation?.id.toString(),
    });
  }

  @override
  Map<String, dynamic> toJson() => super.toJson()..addAll({
      'hijab': hijab,
      'accepts_polygamy': acceptsPolygamy,
      'preferred_residence_after_marriage': preferredResidenceAfterMarriage,
      'guardian_name': guardianName,
      'guardian_phone': guardianPhone,
      'guardian_country_code': guardianCountryCode,
      'guardian_relation': guardianRelation,
    });

  FemaleModel merge(FemaleModel otherFemaleModel) {
    return FemaleModel(
      guardianName: _mergeHelper(otherFemaleModelValue: otherFemaleModel.guardianName, currentValue: guardianName),
      isNotify: _mergeHelper(otherFemaleModelValue: otherFemaleModel.isNotify, currentValue: isNotify),
      id: _mergeHelper(otherFemaleModelValue: otherFemaleModel.id, currentValue: id),
      name: _mergeHelper(otherFemaleModelValue: otherFemaleModel.name, currentValue: name),
      parentId: _mergeHelper(otherFemaleModelValue: otherFemaleModel.parentId, currentValue: parentId),
      type: _mergeHelper(otherFemaleModelValue: otherFemaleModel.type, currentValue: type),
      gender: _mergeHelper(otherFemaleModelValue: otherFemaleModel.gender, currentValue: gender),
      avatar: _mergeHelper(otherFemaleModelValue: otherFemaleModel.avatar, currentValue: avatar),
      phone: _mergeHelper(otherFemaleModelValue: otherFemaleModel.phone, currentValue: phone),
      countryCode: _mergeHelper(otherFemaleModelValue: otherFemaleModel.countryCode, currentValue: countryCode),
      fullPhone: _mergeHelper(otherFemaleModelValue: otherFemaleModel.fullPhone, currentValue: fullPhone),
      identityNumber: _mergeHelper(otherFemaleModelValue: otherFemaleModel.identityNumber, currentValue: identityNumber),
      age: _mergeHelper(otherFemaleModelValue: otherFemaleModel.age, currentValue: age),
      isActive: _mergeHelper(otherFemaleModelValue: otherFemaleModel.isActive, currentValue: isActive),
      isBlocked: _mergeHelper(otherFemaleModelValue: otherFemaleModel.isBlocked, currentValue: isBlocked),
      adminApprovalStatus: _mergeHelper(otherFemaleModelValue: otherFemaleModel.adminApprovalStatus, currentValue: adminApprovalStatus),
      completeRegistration: _mergeHelper(otherFemaleModelValue: otherFemaleModel.completeRegistration, currentValue: completeRegistration),
      token: _mergeHelper(otherFemaleModelValue: otherFemaleModel.token, currentValue: token),
      nickName: _mergeHelper(otherFemaleModelValue: otherFemaleModel.nickName, currentValue: nickName),
      maritalStatus: _mergeHelper(otherFemaleModelValue: otherFemaleModel.maritalStatus, currentValue: maritalStatus),
      height: _mergeHelper(otherFemaleModelValue: otherFemaleModel.height, currentValue: height),
      weight: _mergeHelper(otherFemaleModelValue: otherFemaleModel.weight, currentValue: weight),
      currentJob: _mergeHelper(otherFemaleModelValue: otherFemaleModel.currentJob, currentValue: currentJob),
      bio: _mergeHelper(otherFemaleModelValue: otherFemaleModel.bio, currentValue: bio),
      hasChildren: _mergeHelper(otherFemaleModelValue: otherFemaleModel.hasChildren, currentValue: hasChildren),
      numOfChildren: _mergeHelper(otherFemaleModelValue: otherFemaleModel.numOfChildren, currentValue: numOfChildren),
      childCustody: _mergeHelper(otherFemaleModelValue: otherFemaleModel.childCustody, currentValue: childCustody),
      wantChildren: _mergeHelper(otherFemaleModelValue: otherFemaleModel.wantChildren, currentValue: wantChildren),
      prohibitedThings: _mergeHelper(otherFemaleModelValue: otherFemaleModel.prohibitedThings, currentValue: prohibitedThings),
      dowry: _mergeHelper(otherFemaleModelValue: otherFemaleModel.dowry, currentValue: dowry),
      weddingType: _mergeHelper(otherFemaleModelValue: otherFemaleModel.weddingType, currentValue: weddingType),
      cityId: _mergeHelper(otherFemaleModelValue: otherFemaleModel.cityId, currentValue: cityId),
      educationLevel: _mergeHelper(otherFemaleModelValue: otherFemaleModel.educationLevel, currentValue: educationLevel),
      isPrayer: _mergeHelper(otherFemaleModelValue: otherFemaleModel.isPrayer, currentValue: isPrayer),
      healthConditions: _mergeHelper(otherFemaleModelValue: otherFemaleModel.healthConditions, currentValue: healthConditions),
      chatLang: _mergeHelper(otherFemaleModelValue: otherFemaleModel.chatLang, currentValue: chatLang),
      isSmoker: _mergeHelper(otherFemaleModelValue: otherFemaleModel.isSmoker, currentValue: isSmoker),
      tribeAffiliation: _mergeHelper(otherFemaleModelValue: otherFemaleModel.tribeAffiliation, currentValue: tribeAffiliation),
      skinColor: _mergeHelper(otherFemaleModelValue: otherFemaleModel.skinColor, currentValue: skinColor),
      religiousCommitment: _mergeHelper(otherFemaleModelValue: otherFemaleModel.religiousCommitment, currentValue: religiousCommitment),
      views: _mergeHelper(otherFemaleModelValue: otherFemaleModel.views, currentValue: views),
      hijab: _mergeHelper(otherFemaleModelValue: otherFemaleModel.hijab, currentValue: hijab),
      acceptsPolygamy: _mergeHelper(otherFemaleModelValue: otherFemaleModel.acceptsPolygamy, currentValue: acceptsPolygamy),
      guardianPhone: _mergeHelper(otherFemaleModelValue: otherFemaleModel.guardianPhone, currentValue: guardianPhone),
      guardianCountryCode: _mergeHelper(otherFemaleModelValue: otherFemaleModel.guardianCountryCode, currentValue: guardianCountryCode),
      guardianRelation: _mergeHelper(otherFemaleModelValue: otherFemaleModel.guardianRelation, currentValue: guardianRelation),
      preferredResidenceAfterMarriage: _mergeHelper(otherFemaleModelValue: otherFemaleModel.preferredResidenceAfterMarriage, currentValue: preferredResidenceAfterMarriage),
    );
  }


  dynamic _mergeHelper({required dynamic otherFemaleModelValue, required dynamic currentValue}){
    if(otherFemaleModelValue is String){
      return (otherFemaleModelValue.isNotNull && otherFemaleModelValue.isNotEmpty)?
      otherFemaleModelValue : currentValue;

    }else if(otherFemaleModelValue is num){
      return (otherFemaleModelValue.isNotNull && otherFemaleModelValue != 0)?
      otherFemaleModelValue : currentValue;

    }else {
      return (otherFemaleModelValue as Object?).isNotNull?
      otherFemaleModelValue : currentValue;
    }
  }

  @override
  FemaleModel copyWith({
    bool? isNotify,
    TitleValueShape? hijab,
    bool? acceptsPolygamy,
    String? preferredResidenceAfterMarriage,
    String? guardianName,
    String? guardianPhone,
    String? guardianCountryCode,
    Kinship? guardianRelation,
    String? nickName, TitleValueShape? maritalStatus, String? height, String? weight, String? currentJob, String? bio, bool? hasChildren, String? numOfChildren, TitleValueShape? childCustody, bool? wantChildren, String? prohibitedThings, Dowry? dowry, TitleValueShape? weddingType, CityModel? cityId, String? educationLevel, bool? isPrayer, String? healthConditions, String? chatLang, bool? isSmoker, bool? tribeAffiliation, TitleValueShape? skinColor, TitleValueShape? religiousCommitment, int? views, int? id, String? name, int? parentId, TitleValueShape? type, Gender? gender, String? avatar, String? phone, String? countryCode, String? fullPhone, String? identityNumber, int? age, bool? isActive, bool? isBlocked, TitleValueShape? adminApprovalStatus, String? completeRegistration, String? token}) {

    return FemaleModel(
      isNotify: isNotify ?? this.isNotify,
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
      dowry: dowry ?? this.dowry,
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
      hijab: hijab ?? this.hijab,
      acceptsPolygamy: acceptsPolygamy ?? this.acceptsPolygamy,
      preferredResidenceAfterMarriage: preferredResidenceAfterMarriage ?? this.preferredResidenceAfterMarriage,
      guardianName: guardianName ?? this.guardianName,
      guardianPhone: guardianPhone ?? this.guardianPhone,
      guardianCountryCode: guardianCountryCode ?? this.guardianCountryCode,
      guardianRelation: guardianRelation ?? this.guardianRelation,
    );
  }
}
