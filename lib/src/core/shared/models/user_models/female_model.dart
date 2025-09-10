import '../../../../features/auth/models/dowry.dart';
import 'parent.dart';
import 'user_model.dart';

class FemaleModel extends UserModel{
  final Dowry dowry;
  final String degreeOfCommitment;
  final Parent parent;

  FemaleModel({
    required this.dowry,
    required this.degreeOfCommitment,
    required this.parent,
    required super.name,
    required super.age,
    required super.gender,
    required super.id,
    required super.type,
    required super.countryCode,
    required super.identityNumber,
    required super.isActive,
    required super.isBlocked,
    required super.adminApprovalStatus,
    required super.completeRegistration,
    required super.token,
    required super.nickName,
    required super.maritalStatus,
    required super.height,
    required super.weight,
    required super.currentJob,
    required super.bio,
    required super.hasChildren,
    required super.numOfChildren,
    required super.childCustody,
    required super.wantChildren,
    required super.prohibitedThings,
    required super.weddingType,
    required super.cityId,
    required super.educationLevel,
    required super.isPrayer,
    required super.healthConditions,
    required super.chatLang,
    required super.isSmoker,
    required super.tribeAffiliation,
    required super.skinColor,
    required super.religiousCommitment,
    required super.views
  });

  factory FemaleModel.fromJson(Map<String, dynamic> json) => FemaleModel(
      dowry: Dowry.fromJson(json['dowry']),
      degreeOfCommitment: json['degreeOfCommitment'],
      parent: Parent.fromJson(json['parent']),
      name: json['name'],
      age: json['age'],
      gender: Gender.fromJson(json['gender']),
      id: json['id'],
      type: json['type'],
      countryCode: json['countryCode'],
      identityNumber: json['identityNumber'],
      isActive: json['isActive'],
      isBlocked: json['isBlocked'],
      adminApprovalStatus: AdminApprovalStatus.fromJson(json['adminApprovalStatus']),
      completeRegistration: json['completeRegistration'],
      token: json['token'],
      nickName: json['nickName'],
      maritalStatus: json['maritalStatus'],
      height: json['height'],
      weight: json['weight'],
      currentJob: json['currentJob'],
      bio: json['bio'],
      hasChildren: json['hasChildren'],
      numOfChildren: json['numOfChildren'],
      childCustody: json['childCustody'],
      wantChildren: json['wantChildren'],
      prohibitedThings: json['prohibitedThings'],
      weddingType: json['weddingType'],
      cityId: json['cityId'],
      educationLevel: json['educationLevel'],
      isPrayer: json['isPrayer'],
      healthConditions: json['healthConditions'],
      chatLang: json['chatLang'],
      isSmoker: json['isSmoker'],
      tribeAffiliation: json['tribeAffiliation'],
      skinColor: json['skinColor'],
      religiousCommitment: json['religiousCommitment'],
      views: json['views']
  );
}