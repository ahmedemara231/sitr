class UserModel {
  UserModel({
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
    this.views,});

  UserModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'];
    type = json['type'] != null ? Type.fromJson(json['type']) : null;
    gender = json['gender'] != null ? Gender.fromJson(json['gender']) : null;
    avatar = json['avatar'];
    phone = json['phone'];
    countryCode = json['country_code'];
    fullPhone = json['full_phone'];
    identityNumber = json['identity_number'];
    age = json['age'];
    isActive = json['is_active'];
    isBlocked = json['is_blocked'];
    adminApprovalStatus = json['admin_approval_status'] != null ? AdminApprovalStatus.fromJson(json['admin_approval_status']) : null;
    completeRegistration = json['complete_registration'];
    token = json['token'];
    nickName = json['nick_name'];
    maritalStatus = json['marital_status'] != null ? MaritalStatus.fromJson(json['marital_status']) : null;
    height = json['height'];
    weight = json['weight'];
    currentJob = json['current_job'];
    bio = json['bio'];
    hasChildren = json['has_children'];
    numOfChildren = json['num_of_children'];
    childCustody = null;
    // childCustody = json['child_custody'] != null ? ChildCustody.fromJson(json['child_custody']) : null;
    wantChildren = json['want_children'];
    prohibitedThings = json['prohibited_things'];
    dowryMin = json['dowry_min'];
    dowryMax = json['dowry_max'];
    weddingType = null;
    // weddingType = json['wedding_type'] != null ? WeddingType.fromJson(json['wedding_type']) : null;
    cityId = json['city_id'] != null ? CityId.fromJson(json['city_id']) : null;
    educationLevel = json['education_level'];
    isPrayer = json['is_prayer'];
    healthConditions = json['health_conditions'];
    chatLang = json['chat_lang'];
    isSmoker = json['is_smoker'];
    tribeAffiliation = json['tribe_affiliation'];
    skinColor = null;
    // skinColor = json['skin_color'] != null ? SkinColor.fromJson(json['skin_color']) : null;
    religiousCommitment = null;
    // religiousCommitment = json['religious_commitment'] != null ? ReligiousCommitment.fromJson(json['religious_commitment']) : null;
    views = json['views'];
  }
  int? id;
  String? name;
  dynamic parentId;
  Type? type;
  Gender? gender;
  String? avatar;
  String? phone;
  String? countryCode;
  String? fullPhone;
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
  int? dowryMin;
  int? dowryMax;
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

  UserModel copyWith({
    int? id,
    String? name,
    dynamic parentId,
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
    String? nickName,
    MaritalStatus? maritalStatus,
    double? height,
    double? weight,
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
    CityId? cityId,
    String? educationLevel,
    bool? isPrayer,
    String? healthConditions,
    String? chatLang,
    bool? isSmoker,
    bool? tribeAffiliation,
    SkinColor? skinColor,
    ReligiousCommitment? religiousCommitment,
    int? views,
  }) => UserModel(
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
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['parent_id'] = parentId;
    if (type != null) {
      map['type'] = type?.toJson();
    }
    if (gender != null) {
      map['gender'] = gender?.toJson();
    }
    map['avatar'] = avatar;
    map['phone'] = phone;
    map['country_code'] = countryCode;
    map['full_phone'] = fullPhone;
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
    map['dowry_min'] = dowryMin;
    map['dowry_max'] = dowryMax;
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
    value = json['value'];
    title = json['title'];
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
    this.title,});

  Gender.fromJson(dynamic json) {
    value = json['value'];
    title = json['title'];
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