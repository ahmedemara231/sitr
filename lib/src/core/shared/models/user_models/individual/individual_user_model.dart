import '../../../../../features/auth/models/dowry.dart';
import '../../title_value_shape.dart';
import '../user_model.dart';

class IndividualUserModel extends UserModel {
  final String? nickName;
  final TitleValueShape? maritalStatus;
  final num? height;
  final num? weight;
  final String? currentJob;
  final String? bio;
  final bool? hasChildren;
  final int? numOfChildren;
  final TitleValueShape? childCustody;
  final bool? wantChildren;
  final String? prohibitedThings;
  final Dowry? dowry;
  final TitleValueShape? weddingType;
  final CityModel? cityId;
  final String? educationLevel;
  final bool? isPrayer;
  final String? healthConditions;
  final String? chatLang;
  final bool? isSmoker;
  final bool? tribeAffiliation;
  final TitleValueShape? skinColor;
  final TitleValueShape? religiousCommitment;
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
    super.isNotify,

    this.dowry,
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
    this.religiousCommitment,
    this.views,
  });

  factory IndividualUserModel.initial() => IndividualUserModel(
    nickName: '',
    maritalStatus: TitleValueShape.initial(),
    height: 0,
    weight: 0,
    currentJob: '',
    bio: '',
    hasChildren: false,
    numOfChildren: 0,
    childCustody: TitleValueShape.initial(),
    wantChildren: false,
    prohibitedThings: '',
    dowry: Dowry(from: '', to: ''),
    weddingType: TitleValueShape.initial(),
    cityId: CityModel(),
    educationLevel: '',
    isPrayer: false,
    healthConditions: '',
    chatLang: '',
    isSmoker: false,
    tribeAffiliation: false,
    skinColor: null,
    religiousCommitment: TitleValueShape.initial(),
    views: 0,
  );

  factory IndividualUserModel.fromJson(Map<String, dynamic> json) {
    return IndividualUserModel(
      isNotify: json['is_notify'],
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
      dowry: Dowry(from: json['dowry_min'], to: json['dowry_max']),
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

  Map<String, dynamic> toRequestBodyJson() => {
    "nick_name": nickName,
    "marital_status": maritalStatus?.value,
    "height": height,
    "weight": weight,
    "current_job": currentJob,
    "bio": bio,
    "has_children": hasChildren,
    "num_of_children": numOfChildren,
    "child_custody": childCustody?.value,
    "want_children": wantChildren,
    "prohibited_things": prohibitedThings,
    'dowry_min' : dowry?.from,
    'dowry_max' : dowry?.to,
    "wedding_type": weddingType?.value,
    "city_id": cityId?.id.toString(),
    "education_level": educationLevel,
    "is_prayer": isPrayer,
    "health_conditions": healthConditions,
    "chat_lang": chatLang,
    "is_smoker": isSmoker,
    "tribe_affiliation": tribeAffiliation,
    "skin_color": skinColor?.value,
    'religious_commitment': religiousCommitment?.value,
  };

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
      'dowry_min' : dowry?.from,
      'dowry_max' : dowry?.to,
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
  IndividualUserModel copyWith({
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
    int? id, String? name, int? parentId, TitleValueShape? type, Gender? gender, String? avatar, String? phone, String? countryCode, String? fullPhone, String? identityNumber, int? age, bool? isActive, bool? isBlocked, TitleValueShape? adminApprovalStatus, String? completeRegistration, String? token}) => IndividualUserModel(
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
    isNotify: isNotify ?? this.isNotify,
  );
}
