import '../../../../extensions/object.dart';
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

      adminApprovalStatus: AdminApprovalStatus.fromJson(json['admin_approval_status']),
      completeRegistration: json['complete_registration'],

      maritalStatus: (json['marital_status'] as String?).isNull? null :
      MaritalStatus.fromJson(json['marital_status']),

      weddingType: (json['wedding_type'] as String?).isNull? null :
      WeddingType.fromJson(json['wedding_type']),

      cityId: (json['city_id'] as String?).isNull? null :
      CityModel.fromJson(json['city_id']),

      religiousCommitment: (json['religious_commitment'] as String?).isNull? null :
      ReligiousCommitment.fromJson(json['religious_commitment']),

      childCustody: (json['child_custody'] as String?).isNull? null :
      ChildCustody.fromJson(json['child_custody']),

      educationLevel: json['education_level'],
      isPrayer: json['is_prayer'],
      healthConditions: json['health_conditions'],
      chatLang: json['chat_lang'],
      isSmoker: json['is_smoker'],
      tribeAffiliation: json['tribe_affiliation'],
      skinColor: json['skin_color'],
      views: json['views'],
    );
  }
}
