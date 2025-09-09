import '../presentation/widgets/sign_up/shared_form_fields.dart';

class CompleteProfileModel {
  String? nickName;
  String? maritalStatus;
  String? height;
  String? weight;
  String? currentJob;
  String? bio;
  Answer? hasChildren;
  String? numOfChildren;
  String? childCustody;
  Answer? wantChildren;
  String? prohibitedThings;
  String? dowryMin;
  String? dowryMax;
  String? weddingType;
  String? city;
  String? educationLevel;
  Answer? isPrayer;
  String? healthConditions;
  String? chatLang;
  Answer? isSmoker;
  Answer? tribeAffiliation;
  String? skinColor;
  String? religiousCommitment;
  String? preferredResidenceAfterMarriage;
  String? hijabWearing;
  Answer? acceptsPolygamy;
  String? parentName;
  String? parentRelationId;
  String? parentPhone;

  CompleteProfileModel({
    required this.nickName,
    required this.maritalStatus,
    required this.height,
    required this.weight,
    required this.currentJob,
    required this.bio,
    required this.hasChildren,
    required this.numOfChildren,
    required this.childCustody,
    required this.wantChildren,
    required this.prohibitedThings,
    required this.dowryMin,
    required this.dowryMax,
    required this.weddingType,
    required this.city,
    required this.educationLevel,
    required this.isPrayer,
    required this.healthConditions,
    required this.chatLang,
    required this.isSmoker,
    required this.tribeAffiliation,
    required this.skinColor,
    required this.religiousCommitment,
    required this.preferredResidenceAfterMarriage,
    required this.hijabWearing,
    required this.acceptsPolygamy,
    required this.parentName,
    required this.parentRelationId,
    required this.parentPhone,
  });

  Map<String, dynamic> toJson() {
    return {
      "nick_name": nickName,
      "marital_status": maritalStatus,
      "height": height,
      "weight": weight,
      "current_job": currentJob,
      "bio": bio,
      "has_children": hasChildren,
      "num_of_children": numOfChildren,
      "child_custody": childCustody,
      "want_children": wantChildren,
      "prohibited_things": prohibitedThings,
      "dowry_min": dowryMin,
      "dowry_max": dowryMax,
      "wedding_type": weddingType,
      "city_id": city,
      "education_level": educationLevel,
      "is_prayer": isPrayer,
      "health_conditions": healthConditions,
      "chat_lang": chatLang,
      "is_smoker": isSmoker,
      "tribe_affiliation": tribeAffiliation,
      "skin_color": skinColor,
      "religious_commitment": religiousCommitment,
      "preferred_residence_after_marriage": preferredResidenceAfterMarriage,
      "hijab": hijabWearing,
      "accepts_polygamy": acceptsPolygamy,
      "parent_name": parentName,
      "parent_relation_id": parentRelationId,
      "parent_phone": parentPhone,
    };
  }
}
