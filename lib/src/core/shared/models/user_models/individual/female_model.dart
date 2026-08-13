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
  // final String? guardianName;
  // final String? guardianPhone;
  // final Kinship? guardianRelation;
  final String? guardianCountryCode;

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
    super.hasActivePackage,
    super.isPromoted,
    super.hasChatRequestFrom,
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
    super.canChat,
    super.hasChatWith,
    super.isParentMatch,
    super.childParentInfo,
    this.hijab,
    this.acceptsPolygamy,
    this.preferredResidenceAfterMarriage,
    // this.guardianName,
    // this.guardianPhone,
    this.guardianCountryCode,
    // this.guardianRelation,
  });

  factory FemaleModel.initial() => FemaleModel();

  factory FemaleModel.fromJson(Map<String, dynamic> json) {
    return FemaleModel(
      canChat: CanChat.fromJson(json['can_chat']),
      hasActivePackage: json['has_active_package'] ?? false,
      isPromoted: json['is_promoted'] ?? false,
      hasChatRequestFrom: json['has_chat_request_from'] ?? false,

      hasChatWith: json['has_chat_with'],
      isParentMatch: json['is_parent_match'],
      adminApprovalStatus:
          TitleValueShape.fromJson(json['admin_approval_status']),
      completeRegistration: json['complete_registration'],

      childParentInfo: (json['parent_info'] as Object?).isNull
          ? null
          : ChildParentInfo.fromJson(json['parent_info']),

      maritalStatus: (json['marital_status'] as Object?).isNull
          ? null
          : TitleValueShape.fromJson(json['marital_status']),

      weddingType: (json['wedding_type'] as Object?).isNull
          ? null
          : TitleValueShape.fromJson(json['wedding_type']),

      cityId: (json['city_id'] as Object?).isNull
          ? null
          : CityModel.fromJson(json['city_id']),

      religiousCommitment: (json['religious_commitment'] as Object?).isNull
          ? null
          : TitleValueShape.fromJson(json['religious_commitment']),

      childCustody: (json['child_custody'] as Object?).isNull
          ? null
          : TitleValueShape.fromJson(json['child_custody']),

      isNotify: json['is_notify'],
      id: json['id'],
      name: json['name'],
      parentId: json['parent_id'],
      type: TypeValueShape.fromJson(json['type']),
      gender: GenderValueShape.fromJson(json['gender']),
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
      numOfChildren: json['num_of_children'],
      wantChildren: json['want_children'],
      prohibitedThings: json['prohibited_things'],

      dowry: ((json['dowry_min'] as Object?).isNotNull &&
              (json['dowry_max'] as Object?).isNotNull)
          ? Dowry(
              from: json['dowry_min'].toString(),
              to: json['dowry_max'].toString())
          : null,

      educationLevel: json['education_level'],
      isPrayer: json['is_prayer'],
      healthConditions: json['health_conditions'],
      chatLang: json['chat_lang'],
      isSmoker: json['is_smoker'],
      tribeAffiliation: json['tribe_affiliation'],
      skinColor: (json['skin_color'] as Object?).isNotNull
          ? TitleValueShape.fromJson(json['skin_color'])
          : null,
      views: json['views'],
      hijab: (json['hijab'] as Object?).isNotNull
          ? TitleValueShape.fromJson(json['hijab'])
          : null,
      acceptsPolygamy: json['accepts_polygamy'],
      preferredResidenceAfterMarriage:
          json['preferred_residence_after_marriage'],
      // guardianName: json['guardian_name'],
      // guardianPhone: json['guardian_phone'],
      // guardianRelation: (json['guardian_relation'] as Object?).isNotNull?
      // Kinship.fromJson(json['guardian_relation']) : null
      guardianCountryCode: json['guardian_country_code'],
    );
  }

  @override
  Map<String, dynamic> toRequestBodyJson(bool fullData) {
    final body = super.toRequestBodyJson(fullData)
      ..addAll({
        'preferred_residence_after_marriage': preferredResidenceAfterMarriage,
        'hijab': hijab?.value,
        'accepts_polygamy': acceptsPolygamy,
        // 'guardian_name': guardianName,
        // 'guardian_phone': guardianPhone,
        // 'guardian_relation_id': guardianRelation?.id.toString(),
      });

    // Remove null values (parent already does this, but re-apply after adding female-specific fields)
    // body.removeWhere((key, value) => value == null);
    return body..removeWhere((key, value) => (value as Object?).isNull);
  }

  @override
  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'hijab': hijab,
      'accepts_polygamy': acceptsPolygamy,
      'preferred_residence_after_marriage': preferredResidenceAfterMarriage,
      // 'guardian_name': guardianName,
      // 'guardian_phone': guardianPhone,
      // 'guardian_relation': guardianRelation,
      'guardian_country_code': guardianCountryCode,
    });

  @override
  FemaleModel merge(IndividualUserModel otherModel) {
    return FemaleModel(
      canChat: _mergeHelper(
          otherFemaleModelValue: otherModel.canChat, currentValue: canChat),
      hasChatWith: _mergeHelper(
          otherFemaleModelValue: otherModel.hasChatWith,
          currentValue: hasChatWith),
      isParentMatch: _mergeHelper(
          otherFemaleModelValue: otherModel.isParentMatch,
          currentValue: isParentMatch),
      isPromoted: _mergeHelper(
          otherFemaleModelValue: otherModel.isPromoted,
          currentValue: isPromoted),
      hasChatRequestFrom: _mergeHelper(
        otherFemaleModelValue: otherModel.hasChatRequestFrom,
        currentValue: hasChatRequestFrom,
      ),
      // guardianName: _mergeHelper(otherFemaleModelValue: (otherModel as FemaleModel).guardianName, currentValue: guardianName),
      // guardianPhone: _mergeHelper(otherFemaleModelValue: otherModel.guardianPhone, currentValue: guardianPhone),
      hijab: _mergeHelper(
          otherFemaleModelValue: (otherModel as FemaleModel).hijab,
          currentValue: hijab),
      acceptsPolygamy: _mergeHelper(
          otherFemaleModelValue: otherModel.acceptsPolygamy,
          currentValue: acceptsPolygamy),
      guardianCountryCode: _mergeHelper(
          otherFemaleModelValue: otherModel.guardianCountryCode,
          currentValue: guardianCountryCode),
      // guardianRelation: _mergeHelper(otherFemaleModelValue: otherModel.guardianRelation, currentValue: guardianRelation),
      preferredResidenceAfterMarriage: _mergeHelper(
          otherFemaleModelValue: otherModel.preferredResidenceAfterMarriage,
          currentValue: preferredResidenceAfterMarriage),
      isNotify: _mergeHelper(
          otherFemaleModelValue: otherModel.isNotify, currentValue: isNotify),
      id: _mergeHelper(otherFemaleModelValue: otherModel.id, currentValue: id),
      name: _mergeHelper(
          otherFemaleModelValue: otherModel.name, currentValue: name),
      parentId: _mergeHelper(
          otherFemaleModelValue: otherModel.parentId, currentValue: parentId),
      type: _mergeHelper(
          otherFemaleModelValue: otherModel.type, currentValue: type),
      gender: _mergeHelper(
          otherFemaleModelValue: otherModel.gender, currentValue: gender),
      avatar: _mergeHelper(
          otherFemaleModelValue: otherModel.avatar, currentValue: avatar),
      phone: _mergeHelper(
          otherFemaleModelValue: otherModel.phone, currentValue: phone),
      countryCode: _mergeHelper(
          otherFemaleModelValue: otherModel.countryCode,
          currentValue: countryCode),
      fullPhone: _mergeHelper(
          otherFemaleModelValue: otherModel.fullPhone, currentValue: fullPhone),
      identityNumber: _mergeHelper(
          otherFemaleModelValue: otherModel.identityNumber,
          currentValue: identityNumber),
      age: _mergeHelper(
          otherFemaleModelValue: otherModel.age, currentValue: age),
      isActive: _mergeHelper(
          otherFemaleModelValue: otherModel.isActive, currentValue: isActive),
      isBlocked: _mergeHelper(
          otherFemaleModelValue: otherModel.isBlocked, currentValue: isBlocked),
      adminApprovalStatus: _mergeHelper(
          otherFemaleModelValue: otherModel.adminApprovalStatus,
          currentValue: adminApprovalStatus),
      completeRegistration: _mergeHelper(
          otherFemaleModelValue: otherModel.completeRegistration,
          currentValue: completeRegistration),
      token: _mergeHelper(
          otherFemaleModelValue: otherModel.token, currentValue: token),
      nickName: _mergeHelper(
          otherFemaleModelValue: otherModel.nickName, currentValue: nickName),
      maritalStatus: _mergeHelper(
          otherFemaleModelValue: otherModel.maritalStatus,
          currentValue: maritalStatus),
      height: _mergeHelper(
          otherFemaleModelValue: otherModel.height, currentValue: height),
      weight: _mergeHelper(
          otherFemaleModelValue: otherModel.weight, currentValue: weight),
      currentJob: _mergeHelper(
          otherFemaleModelValue: otherModel.currentJob,
          currentValue: currentJob),
      bio: _mergeHelper(
          otherFemaleModelValue: otherModel.bio, currentValue: bio),
      hasChildren: _mergeHelper(
          otherFemaleModelValue: otherModel.hasChildren,
          currentValue: hasChildren),
      numOfChildren: _mergeHelper(
          otherFemaleModelValue: otherModel.numOfChildren,
          currentValue: numOfChildren),
      childCustody: _mergeHelper(
          otherFemaleModelValue: otherModel.childCustody,
          currentValue: childCustody),
      wantChildren: _mergeHelper(
          otherFemaleModelValue: otherModel.wantChildren,
          currentValue: wantChildren),
      prohibitedThings: _mergeHelper(
          otherFemaleModelValue: otherModel.prohibitedThings,
          currentValue: prohibitedThings),
      dowry: _mergeHelper(
          otherFemaleModelValue: otherModel.dowry, currentValue: dowry),
      weddingType: _mergeHelper(
          otherFemaleModelValue: otherModel.weddingType,
          currentValue: weddingType),
      cityId: _mergeHelper(
          otherFemaleModelValue: otherModel.cityId, currentValue: cityId),
      educationLevel: _mergeHelper(
          otherFemaleModelValue: otherModel.educationLevel,
          currentValue: educationLevel),
      isPrayer: _mergeHelper(
          otherFemaleModelValue: otherModel.isPrayer, currentValue: isPrayer),
      healthConditions: _mergeHelper(
          otherFemaleModelValue: otherModel.healthConditions,
          currentValue: healthConditions),
      chatLang: _mergeHelper(
          otherFemaleModelValue: otherModel.chatLang, currentValue: chatLang),
      isSmoker: _mergeHelper(
          otherFemaleModelValue: otherModel.isSmoker, currentValue: isSmoker),
      tribeAffiliation: _mergeHelper(
          otherFemaleModelValue: otherModel.tribeAffiliation,
          currentValue: tribeAffiliation),
      skinColor: _mergeHelper(
          otherFemaleModelValue: otherModel.skinColor, currentValue: skinColor),
      religiousCommitment: _mergeHelper(
          otherFemaleModelValue: otherModel.religiousCommitment,
          currentValue: religiousCommitment),
      views: _mergeHelper(
          otherFemaleModelValue: otherModel.views, currentValue: views),
    );
  }

  dynamic _mergeHelper(
      {required dynamic otherFemaleModelValue, required dynamic currentValue}) {
    if (otherFemaleModelValue is String) {
      return (otherFemaleModelValue.isNotNull &&
              otherFemaleModelValue.isNotEmpty)
          ? otherFemaleModelValue
          : currentValue;
    } else if (otherFemaleModelValue is num) {
      return (otherFemaleModelValue.isNotNull && otherFemaleModelValue != 0)
          ? otherFemaleModelValue
          : currentValue;
    } else {
      return (otherFemaleModelValue as Object?).isNotNull
          ? otherFemaleModelValue
          : currentValue;
    }
  }

  @override
  FemaleModel copyWith(
      {bool? isNotify,
      TitleValueShape? hijab,
      bool? acceptsPolygamy,
      bool? hasActivePackage,
      bool? isPromoted,
      bool? hasChatRequestFrom,
      ChildParentInfo? childParentInfo,
      CanChat? canChat,
      bool? hasChatWith,
      bool? isParentMatch,
      String? preferredResidenceAfterMarriage,
      String? guardianName,
      String? guardianPhone,
      String? guardianCountryCode,
      Kinship? guardianRelation,
      String? nickName,
      TitleValueShape? maritalStatus,
      String? height,
      String? weight,
      String? currentJob,
      String? bio,
      bool? hasChildren,
      int? numOfChildren,
      TitleValueShape? childCustody,
      bool? wantChildren,
      String? prohibitedThings,
      Dowry? dowry,
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
      int? id,
      String? name,
      int? parentId,
      TypeValueShape? type,
      GenderValueShape? gender,
      dynamic avatar,
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
      bool clearNumOfChildren = false,
      bool clearChildCustody = false}) {
    return FemaleModel(
      hasActivePackage: hasActivePackage ?? this.hasActivePackage,
      isPromoted: isPromoted ?? this.isPromoted,
      hasChatRequestFrom: hasChatRequestFrom ?? this.hasChatRequestFrom,
      childParentInfo: childParentInfo ?? this.childParentInfo,
      canChat: canChat ?? this.canChat,
      hasChatWith: hasChatWith ?? this.hasChatWith,
      isParentMatch: isParentMatch ?? this.isParentMatch,
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
      numOfChildren:
          clearNumOfChildren ? null : numOfChildren ?? this.numOfChildren,
      childCustody:
          clearChildCustody ? null : childCustody ?? this.childCustody,
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
      preferredResidenceAfterMarriage: preferredResidenceAfterMarriage ??
          this.preferredResidenceAfterMarriage,
      // guardianName: guardianName ?? this.guardianName,
      // guardianPhone: guardianPhone ?? this.guardianPhone,
      guardianCountryCode: guardianCountryCode ?? this.guardianCountryCode,
      // guardianRelation: guardianRelation ?? this.guardianRelation,
    );
  }
}
