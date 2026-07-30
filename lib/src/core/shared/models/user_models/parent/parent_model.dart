import '../../../../../features/auth/models/kinship.dart';
import '../../title_value_shape.dart';
import '../individual/individual_user_model.dart';
import '../user_model.dart';

class ParentModel extends UserModel {
  final String? email;
  final Kinship? relation;
  final int? numOfChildren;
  final int? maleChildrenNum;
  final int? femaleChildrenNum;

  ParentModel({
    super.isNotify,
    super.hasActivePackage,
    super.isPromoted,
    super.hasChatRequestFrom,
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
    super.canChat,
    super.hasChatWith,
    super.isParentMatch,
    super.views,
    this.email,
    this.relation,
    this.numOfChildren,
    this.maleChildrenNum,
    this.femaleChildrenNum,
  });

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      views: json['views'],
      hasActivePackage: json['has_active_package'],
      isPromoted: json['is_promoted'] ?? false,
      hasChatRequestFrom: json['has_chat_request_from'] ?? false,
      isNotify: json['is_notify'],
      canChat: CanChat.fromJson(json['can_chat']),
      hasChatWith: json['has_chat_with'],
      isParentMatch: json['is_parent_match'],
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
      adminApprovalStatus:
          TitleValueShape.fromJson(json['admin_approval_status']),
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
  UserModel copyWith(
      {bool? isNotify,
      String? email,
      bool? hasActivePackage,
      bool? isPromoted,
      bool? hasChatRequestFrom,
      Kinship? relation,
      int? numOfChildren,
      int? maleChildrenNum,
      int? femaleChildrenNum,
      CanChat? canChat,
      bool? hasChatWith,
      bool? isParentMatch,
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
      String? token}) {
    return ParentModel(
      hasActivePackage: hasActivePackage ?? this.hasActivePackage,
      isPromoted: isPromoted ?? this.isPromoted,
      hasChatRequestFrom: hasChatRequestFrom ?? this.hasChatRequestFrom,
      isNotify: isNotify ?? this.isNotify,
      id: id ?? this.id,
      canChat: canChat ?? this.canChat,
      hasChatWith: hasChatWith ?? this.hasChatWith,
      isParentMatch: isParentMatch ?? this.isParentMatch,
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
      email: email ?? this.email,
      relation: relation ?? this.relation,
      numOfChildren: numOfChildren ?? this.numOfChildren,
      maleChildrenNum: maleChildrenNum ?? this.maleChildrenNum,
      femaleChildrenNum: femaleChildrenNum ?? this.femaleChildrenNum,
    );
  }
}
