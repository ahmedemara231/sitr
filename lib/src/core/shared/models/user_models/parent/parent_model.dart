import '../../../../../features/auth/models/kinship.dart';
import '../../title_value_shape.dart';
import '../user_model.dart';

class ParentModel extends UserModel {
  final String? email;
  final Kinship? relation;
  final int? numOfChildren;
  final int? maleChildrenNum;
  final int? femaleChildrenNum;

  ParentModel({
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
    this.email,
    this.relation,
    this.numOfChildren,
    this.maleChildrenNum,
    this.femaleChildrenNum,
  });

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      id: json['id'],
      name: json['name'],
      parentId: json['parent_id'],
      type: TitleValueShape.fromJson(json['type']),
      gender: Gender.fromJson(json['type']),
      avatar: json['avatar'],
      phone: json['phone'],
      countryCode: json['country_code'],
      fullPhone: json['full_phone'],
      identityNumber: json['identity_number'],
      age: json['age'],
      isActive: json['is_active'],
      isBlocked: json['is_blocked'],
      adminApprovalStatus: TitleValueShape.fromJson(json['admin_approval_status']),
      completeRegistration: json['complete_registration'],
      token: json['token'],
      email: json['email'],
      relation: Kinship.fromJson(json['relation']),
      numOfChildren: json['num_of_children'],
      maleChildrenNum: json['male_children_num'],
      femaleChildrenNum: json['female_children_num'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data.addAll({
      'email': email,
      'relation': relation?.toJson(),
      'num_of_children': numOfChildren,
      'male_children_num': maleChildrenNum,
      'female_children_num': femaleChildrenNum,
    });
    return data;
  }

  @override
  UserModel copyWith({
    String? email,
    Kinship? relation,
    int? numOfChildren,
    int? maleChildrenNum,
    int? femaleChildrenNum,

    int? id, String? name, int? parentId, TitleValueShape? type, Gender? gender, String? avatar, String? phone, String? countryCode, String? fullPhone, String? identityNumber, int? age, bool? isActive, bool? isBlocked, TitleValueShape? adminApprovalStatus, String? completeRegistration, String? token}) {
    return ParentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      type: type ?? this.type,
      gender: gender ?? this.gender,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
      fullPhone: fullPhone ?? this.fullPhone,
      identityNumber: identityNumber?? this.identityNumber,
      age: age ?? this.age,
      isActive: isActive ?? this.isActive,
      isBlocked: isBlocked ?? this.isBlocked,
      adminApprovalStatus: adminApprovalStatus ?? this.adminApprovalStatus,
      completeRegistration: completeRegistration ?? this.completeRegistration,
      token: token ?? this.token,
      email: email ?? this.email,
      relation: relation ?? this.relation,
      numOfChildren: numOfChildren ?? this.numOfChildren,
      maleChildrenNum: maleChildrenNum ?? this.maleChildrenNum,
      femaleChildrenNum: femaleChildrenNum ?? this.femaleChildrenNum,
    );
  }
}
