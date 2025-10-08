import '../user_model.dart';

class IndividualUserModel extends UserModel {
  final String? nickName;
  final MaritalStatusModel? maritalStatus;
  final num? height;
  final num? weight;
  final String? currentJob;
  final String? bio;
  final bool? hasChildren;
  final int? numOfChildren;
  final ChildCustody? childCustody;
  final bool? wantChildren;
  final String? prohibitedThings;
  final int? dowryMin;
  final int? dowryMax;
  final WeddingType? weddingType;
  final CityModel? cityId;
  final String? educationLevel;
  final bool? isPrayer;
  final String? healthConditions;
  final String? chatLang;
  final bool? isSmoker;
  final bool? tribeAffiliation;
  final String? skinColor;
  final ReligiousCommitment? religiousCommitment;
  final int? views;

  IndividualUserModel({
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
    this.dowryMin,
    this.dowryMax,
    this.weddingType,
    this.cityId,
    this.educationLevel,
    this.isPrayer,
    this.healthConditions,
    this.chatLang,
    this.isSmoker,
    this.tribeAffiliation,
    this.skinColor,
    this.religiousCommitment,
    this.views,
  });

  factory IndividualUserModel.initial() => IndividualUserModel(
    nickName: '',
    maritalStatus: MaritalStatusModel(),
    height: 0,
    weight: 0,
    currentJob: '',
    bio: '',
    hasChildren: false,
    numOfChildren: 0,
    childCustody: ChildCustody(),
    wantChildren: false,
    prohibitedThings: '',
    dowryMin: 0,
    dowryMax: 0,
    weddingType: WeddingType(),
    cityId: CityModel(),
    educationLevel: '',
    isPrayer: false,
    healthConditions: '',
    chatLang: '',
    isSmoker: false,
    tribeAffiliation: false,
    skinColor: '',
    religiousCommitment: ReligiousCommitment(),
    views: 0,
  );

  factory IndividualUserModel.fromJson(Map<String, dynamic> json) {
    return IndividualUserModel(
      id: json['id'],
      name: json['name'],
      parentId: json['parent_id'],
      type: json['type'],
      gender: json['gender'],
      avatar: json['avatar'],
      phone: json['phone'],
      countryCode: json['country_code'],
      fullPhone: json['full_phone'],
      identityNumber: json['identity_number'],
      age: json['age'],
      isActive: json['is_active'],
      isBlocked: json['is_blocked'],
      adminApprovalStatus: json['admin_approval_status'],
      completeRegistration: json['complete_registration'],
      token: json['token'],
      nickName: json['nick_name'],
      maritalStatus: json['marital_status'],
      height: json['height'],
      weight: json['weight'],
      currentJob: json['current_job'],
      bio: json['bio'],
      hasChildren: json['has_children'],
      numOfChildren: json['num_of_children'],
      childCustody: json['child_custody'],
      wantChildren: json['want_children'],
      prohibitedThings: json['prohibited_things'],
      dowryMin: json['dowry_min'],
      dowryMax: json['dowry_max'],
      weddingType: json['wedding_type'],
      cityId: json['city_id'],
      educationLevel: json['education_level'],
      isPrayer: json['is_prayer'],
      healthConditions: json['health_conditions'],
      chatLang: json['chat_lang'],
      isSmoker: json['is_smoker'],
      tribeAffiliation: json['tribe_affiliation'],
      skinColor: json['skin_color'],
      religiousCommitment: json['religious_commitment'],
      views: json['views'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()..addAll({
      'nick_name': nickName,
      'marital_status': maritalStatus?.toJson(),
      'height': height,
      'weight': weight,
      'current_job': currentJob,
      'bio': bio,
      'has_children': hasChildren,
      'num_of_children': numOfChildren,
      'child_custody': childCustody?.toJson(),
      'want_children': wantChildren,
      'prohibited_things': prohibitedThings,
      'dowry_min': dowryMin,
      'dowry_max': dowryMax,
      'wedding_type': weddingType?.toJson(),
      'city_id': cityId?.toJson(),
      'education_level': educationLevel,
      'is_prayer': isPrayer,
      'health_conditions': healthConditions,
      'chat_lang': chatLang,
      'is_smoker': isSmoker,
      'tribe_affiliation': tribeAffiliation,
      'skin_color': skinColor,
      'religious_commitment': religiousCommitment?.toJson(),
      'views': views,
    });
  }

  @override
  UserModel copyWith({
      String? nickName,
      MaritalStatusModel? maritalStatus,
      int? height,
      int? weight,
      String? currentJob,
      String? bio,
      bool? hasChildren,
      int? numOfChildren,
      ChildCustody? childCustody,
      bool? wantChildren,
      String? prohibitedThings,
      int? dowryMin,
      int? dowryMax,
      WeddingType? weddingType,
      CityModel? cityId,
      String? educationLevel,
      bool? isPrayer,
      String? healthConditions,
      String? chatLang,
      bool? isSmoker,
      bool? tribeAffiliation,
      String? skinColor,
      ReligiousCommitment? religiousCommitment,
      int? views,
    int? id, String? name, int? parentId, Type? type, Gender? gender, String? avatar, String? phone, String? countryCode, String? fullPhone, String? identityNumber, int? age, bool? isActive, bool? isBlocked, AdminApprovalStatus? adminApprovalStatus, String? completeRegistration, String? token}) {

    return IndividualUserModel(
        id: id,
        name: name,
        parentId: parentId,
        type: type,
        gender: gender,
        avatar: avatar,
        phone: phone,
        countryCode: countryCode,
        fullPhone: fullPhone,
        identityNumber: identityNumber,
        age: age,
        isActive: isActive,
        isBlocked: isBlocked,
        adminApprovalStatus: adminApprovalStatus,
        completeRegistration: completeRegistration,
        token: token,
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
      );
  }
}
