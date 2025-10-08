import '../../../../extensions/object.dart';
import '../user_model.dart';
import 'individual_user_model.dart';


class FemaleModel extends IndividualUserModel {
  final String? hijab;
  final bool? acceptsPolygamy;
  final String? preferredResidenceAfterMarriage;
  final String? guardianName;
  final String? guardianPhone;
  final String? guardianCountryCode;
  final String? guardianRelation;

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
    guardianRelation: '',
  );

  factory FemaleModel.fromJson(Map<String, dynamic> json) {
    return FemaleModel(
      adminApprovalStatus: AdminApprovalStatus.fromJson(json['admin_approval_status']),
      completeRegistration: json['complete_registration'],

      maritalStatus: (json['marital_status'] as String?).isNull? null :
      MaritalStatusModel.fromJson(json['marital_status']),

      weddingType: (json['wedding_type'] as String?).isNull? null :
      WeddingType.fromJson(json['wedding_type']),

      cityId: (json['city_id'] as String?).isNull? null :
      CityModel.fromJson(json['city_id']),

      religiousCommitment: (json['religious_commitment'] as String?).isNull? null :
      ReligiousCommitment.fromJson(json['religious_commitment']),

      childCustody: (json['child_custody'] as String?).isNull? null :
      ChildCustody.fromJson(json['child_custody']),

      id: json['id'],
      name: json['name'],
      parentId: json['parent_id'],
      type: Type.fromJson(json['type']),
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
      educationLevel: json['education_level'],
      isPrayer: json['is_prayer'],
      healthConditions: json['health_conditions'],
      chatLang: json['chat_lang'],
      isSmoker: json['is_smoker'],
      tribeAffiliation: json['tribe_affiliation'],
      skinColor: json['skin_color'],
      views: json['views'],
      hijab: json['hijab'],
      acceptsPolygamy: json['accepts_polygamy'],
      preferredResidenceAfterMarriage: json['preferred_residence_after_marriage'],
      guardianName: json['guardian_name'],
      guardianPhone: json['guardian_phone'],
      guardianCountryCode: json['guardian_country_code'],
      guardianRelation: json['guardian_relation']?['name'],
    );
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

  @override
  UserModel copyWith({
    String? hijab,
    bool? acceptsPolygamy,
    String? preferredResidenceAfterMarriage,
    String? guardianName,
    String? guardianPhone,
    String? guardianCountryCode,
    String? guardianRelation,
    String? nickName, MaritalStatusModel? maritalStatus, int? height, int? weight, String? currentJob, String? bio, bool? hasChildren, int? numOfChildren, ChildCustody? childCustody, bool? wantChildren, String? prohibitedThings, int? dowryMin, int? dowryMax, WeddingType? weddingType, CityModel? cityId, String? educationLevel, bool? isPrayer, String? healthConditions, String? chatLang, bool? isSmoker, bool? tribeAffiliation, String? skinColor, ReligiousCommitment? religiousCommitment, int? views, int? id, String? name, int? parentId, Type? type, Gender? gender, String? avatar, String? phone, String? countryCode, String? fullPhone, String? identityNumber, int? age, bool? isActive, bool? isBlocked, AdminApprovalStatus? adminApprovalStatus, String? completeRegistration, String? token}) {

    return FemaleModel(
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
      hijab: hijab ?? this.hijab,
      acceptsPolygamy: acceptsPolygamy ?? this.acceptsPolygamy,
      preferredResidenceAfterMarriage: preferredResidenceAfterMarriage ?? this.preferredResidenceAfterMarriage,
      guardianName: guardianName ?? this.guardianName,
      guardianPhone: guardianPhone ?? this.guardianPhone,
      guardianCountryCode: guardianCountryCode ?? this.guardianCountryCode,
      guardianRelation: guardianRelation ?? this.guardianRelation,
    );
  }
  // @override
  // UserModel copyWith({
  //   String? hijab,
  //   bool? acceptsPolygamy,
  //   String? preferredResidenceAfterMarriage,
  //   String? guardianName,
  //   String? guardianPhone,
  //   String? guardianCountryCode,
  //   String? guardianRelation,
  //
  //   String? nickName, MaritalStatus? maritalStatus, int? height, int? weight, String? currentJob, String? bio, bool? hasChildren, int? numOfChildren, ChildCustody? childCustody, bool? wantChildren, String? prohibitedThings, int? dowryMin, int? dowryMax, String? weddingType, int? cityId, String? educationLevel, bool? isPrayer, String? healthConditions, String? chatLang, bool? isSmoker, String? tribeAffiliation, String? skinColor, String? religiousCommitment, int? views, int? id, String? name, int? parentId, Type? type, Gender? gender, String? avatar, String? phone, String? countryCode, String? fullPhone, String? identityNumber, int? age, bool? isActive, bool? isBlocked, AdminApprovalStatus? adminApprovalStatus, String? completeRegistration, String? token}) {
  //
  //   return FemaleModel(
  //     id: id ?? this.id,
  //     name: name ?? this.name,
  //     parentId: parentId ?? this.parentId,
  //     type: type ?? this.type,
  //     gender: gender ?? this.gender,
  //     avatar: avatar ?? this.avatar,
  //     phone: phone ?? this.phone,
  //     countryCode: countryCode ?? this.countryCode,
  //     fullPhone: fullPhone ?? this.fullPhone,
  //     identityNumber: identityNumber ?? this.identityNumber,
  //     age: age ?? this.age,
  //     isActive: isActive ?? this.isActive,
  //     isBlocked: isBlocked ?? this.isBlocked,
  //     adminApprovalStatus: adminApprovalStatus ?? this.adminApprovalStatus,
  //     completeRegistration: completeRegistration ?? this.completeRegistration,
  //     token: token ?? this.token,
  //     nickName: nickName ?? this.nickName,
  //     maritalStatus: maritalStatus ?? this.maritalStatus,
  //     height: height ?? this.height,
  //     weight: weight ?? this.weight,
  //     currentJob: currentJob ?? this.currentJob,
  //     bio: bio ?? this.bio,
  //     hasChildren: hasChildren ?? this.hasChildren,
  //     numOfChildren: numOfChildren ?? this.numOfChildren,
  //     childCustody: childCustody ?? this.childCustody,
  //     wantChildren: wantChildren ?? this.wantChildren,
  //     prohibitedThings: prohibitedThings ?? this.prohibitedThings,
  //   );
  // }
}
