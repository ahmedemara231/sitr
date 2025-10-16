import '../../../../../features/auth/models/dowry.dart';
import '../../../../../features/auth/models/kinship.dart';
import '../../../../extensions/object.dart';
import '../../title_value_shape.dart';
import '../user_model.dart';
import 'individual_user_model.dart';


class FemaleModel extends IndividualUserModel {
  final String? hijab;
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
    hijab: '',
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
      height: json['height'],
      weight: json['weight'],

      currentJob: json['current_job'],
      bio: json['bio'],
      hasChildren: json['has_children'],
      numOfChildren: json['num_of_children'],
      wantChildren: json['want_children'],
      prohibitedThings: json['prohibited_things'],
      dowry: Dowry(from: json['dowry_min'], to: json['dowry_max']),
      educationLevel: json['education_level'],
      isPrayer: json['is_prayer'],
      healthConditions: json['health_conditions'],
      chatLang: json['chat_lang'],
      isSmoker: json['is_smoker'],
      tribeAffiliation: json['tribe_affiliation'],
      skinColor: TitleValueShape.fromJson(json['skin_color']),
      views: json['views'],
      hijab: json['hijab'],
      acceptsPolygamy: json['accepts_polygamy'],
      preferredResidenceAfterMarriage: json['preferred_residence_after_marriage'],
      guardianName: json['guardian_name'],
      guardianPhone: json['guardian_phone'],
      guardianCountryCode: json['guardian_country_code'],
      guardianRelation: Kinship.fromJson(json['guardian_relation'])
    );
  }

  @override
  Map<String, dynamic> toRequestBodyJson() {
    return super.toRequestBodyJson()..addAll({
      'preferred_residence_after_marriage': preferredResidenceAfterMarriage,
      'accepts_polygamy': acceptsPolygamy,
      'guardian_name': guardianName,
      'guardian_phone': guardianPhone,
      'guardian_relation_id': guardianRelation?.id.toString(),
      'hijab': hijab,
    });
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data.addAll({
      'hijab': hijab,
      'accepts_polygamy': acceptsPolygamy,
      'preferred_residence_after_marriage': preferredResidenceAfterMarriage,
      'guardian_name': guardianName,
      'guardian_phone': guardianPhone,
      'guardian_country_code': guardianCountryCode,
      'guardian_relation': guardianRelation,
    });
    return data;
  }

  FemaleModel merge(FemaleModel otherFemaleModel) {
    return FemaleModel(
      isNotify: otherFemaleModel.isNotify ?? isNotify,
      id: otherFemaleModel.id ?? id,
      name: otherFemaleModel.name ?? name,
      parentId: otherFemaleModel.parentId ?? parentId,
      type: otherFemaleModel.type ?? type,
      gender: otherFemaleModel.gender ?? gender,
      avatar: otherFemaleModel.avatar ?? avatar,
      phone: otherFemaleModel.phone ?? phone,
      countryCode: otherFemaleModel.countryCode ?? countryCode,
      fullPhone: otherFemaleModel.fullPhone ?? fullPhone,
      identityNumber: otherFemaleModel.identityNumber ?? identityNumber,
      age: otherFemaleModel.age ?? age,
      isActive: otherFemaleModel.isActive ?? isActive,
      isBlocked: otherFemaleModel.isBlocked ?? isBlocked,
      adminApprovalStatus: otherFemaleModel.adminApprovalStatus ?? adminApprovalStatus,
      completeRegistration: otherFemaleModel.completeRegistration ?? completeRegistration,
      token: otherFemaleModel.token ?? token,
      nickName: otherFemaleModel.nickName ?? nickName,
      maritalStatus: otherFemaleModel.maritalStatus ?? maritalStatus,
      height: otherFemaleModel.height ?? height,
      weight: otherFemaleModel.weight ?? weight,
      currentJob: otherFemaleModel.currentJob ?? currentJob,
      bio: otherFemaleModel.bio ?? bio,
      hasChildren: otherFemaleModel.hasChildren ?? hasChildren,
      numOfChildren: otherFemaleModel.numOfChildren ?? numOfChildren,
      childCustody: otherFemaleModel.childCustody ?? childCustody,
      wantChildren: otherFemaleModel.wantChildren ?? wantChildren,
      prohibitedThings: otherFemaleModel.prohibitedThings ?? prohibitedThings,
      dowry: otherFemaleModel.dowry ?? dowry,
      weddingType: otherFemaleModel.weddingType ?? weddingType,
      cityId: otherFemaleModel.cityId ?? cityId,
      educationLevel: otherFemaleModel.educationLevel ?? educationLevel,
      isPrayer: otherFemaleModel.isPrayer ?? isPrayer,
      healthConditions: otherFemaleModel.healthConditions ?? healthConditions,
      chatLang: otherFemaleModel.chatLang ?? chatLang,
      isSmoker: otherFemaleModel.isSmoker ?? isSmoker,
      tribeAffiliation: otherFemaleModel.tribeAffiliation ?? tribeAffiliation,
      skinColor: otherFemaleModel.skinColor ?? skinColor,
      religiousCommitment: otherFemaleModel.religiousCommitment ?? religiousCommitment,
      views: otherFemaleModel.views ?? views,
      hijab: otherFemaleModel.hijab ?? hijab,
      acceptsPolygamy: otherFemaleModel.acceptsPolygamy ?? acceptsPolygamy,
      preferredResidenceAfterMarriage: otherFemaleModel.preferredResidenceAfterMarriage ?? preferredResidenceAfterMarriage,
      guardianName: otherFemaleModel.guardianName ?? guardianName,
      guardianPhone: otherFemaleModel.guardianPhone ?? guardianPhone,
      guardianCountryCode: otherFemaleModel.guardianCountryCode ?? guardianCountryCode,
      guardianRelation: otherFemaleModel.guardianRelation ?? guardianRelation,
    );
  }


  @override
  FemaleModel copyWith({
    bool? isNotify,
    String? hijab,
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
