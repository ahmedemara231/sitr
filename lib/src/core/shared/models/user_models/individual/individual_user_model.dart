import 'dart:developer';
import 'dart:io';

import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../features/auth/models/dowry.dart';
import '../../../../extensions/object.dart';
import '../../../../extensions/string_extension.dart';
import '../../../../helpers/user_type_enum.dart';
import '../../title_value_shape.dart';
import '../user_model.dart';
import 'female_model.dart';
import 'male_model.dart';

class IndividualUserModel extends UserModel {
  final String? nickName;
  final TitleValueShape? maritalStatus;
  final String? height;
  final String? weight;
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
  final ChildParentInfo? childParentInfo;

  IndividualUserModel({
    super.id,
    super.hasActivePackage,
    super.isPromoted,
    super.hasChatRequestFrom,
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
    super.canChat,
    super.hasChatWith,
    super.isParentMatch,
    super.views,
    this.childParentInfo,
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
  });

  factory IndividualUserModel.initial() => IndividualUserModel(
      // nickName: '',
      // maritalStatus: TitleValueShape.initial(),
      // hasActivePackage: false,
      // height: '',
      // weight: '',
      // currentJob: '',
      // bio: '',
      // hasChildren: false,
      // numOfChildren: 0,
      // childCustody: TitleValueShape.initial(),
      // wantChildren: false,
      // prohibitedThings: '',
      // dowry: Dowry(from: '', to: ''),
      // weddingType: TitleValueShape.initial(),
      // cityId: CityModel(),
      // educationLevel: '',
      // isPrayer: false,
      // healthConditions: '',
      // chatLang: '',
      // isSmoker: false,
      // tribeAffiliation: false,
      // skinColor: null,
      // religiousCommitment: TitleValueShape.initial(),
      // views: 0,
      // isNotify: false,
      // id: 0,
      // name: '',
      // parentId: 0,
      // type: null,
      // gender: null,
      // avatar: null,
      // phone: '',
      // countryCode: '',
      // fullPhone: '',
      // identityNumber: '',
      );

  factory IndividualUserModel.fromJson(Map<String, dynamic> json) {
    final UserGender user = json['gender']['value'].toString().toUserGender();

    if (user.isMale) {
      return MaleModel.fromJson(json);
    } else if (user.isFemale) {
      return FemaleModel.fromJson(json);
    } else {
      return IndividualUserModel.initial();
    }
  }

  Map<String, dynamic> toJsonBody() => {
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
        'dowry_min': dowry?.from,
        'dowry_max': dowry?.to,
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
        'avatar': avatar,

        // بشيلها لو مش file عشان الباك كان عايز اني ابعتها في حالة اني عدلت عليها بس
      }..removeWhere((key, value) => key == 'avatar' && value is! File);

  Map<String, dynamic> toRequestBodyJson(bool fullData) {
    final Map<String, dynamic> body;
    if (fullData) {
      body = toJsonBody()
        ..addAll({
          'name': name,
          'gender': gender?.userGender?.name,
          'phone': phone,
          'identity_number': identityNumber,
          'age': age,
        });
    } else {
      body = toJsonBody();
    }

    log('the body is $body');
    return body..removeWhere((key, value) => (value as Object?).isNull);
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'can_chat': canChat?.toJson(),
        'has_chat_with': hasChatWith,
        'is_parent_match': isParentMatch,
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
        'dowry_min': dowry?.from,
        'dowry_max': dowry?.to,
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

  IndividualUserModel merge(IndividualUserModel otherModel) {
    return IndividualUserModel(
      canChat: _mergeHelper(
          otherMaleModelValue: otherModel.canChat, currentValue: canChat),
      hasChatWith: _mergeHelper(
          otherMaleModelValue: otherModel.hasChatWith,
          currentValue: hasChatWith),
      isParentMatch: _mergeHelper(
          otherMaleModelValue: otherModel.isParentMatch,
          currentValue: isParentMatch),
      isPromoted: _mergeHelper(
          otherMaleModelValue: otherModel.isPromoted, currentValue: isPromoted),
      hasChatRequestFrom: _mergeHelper(
        otherMaleModelValue: otherModel.hasChatRequestFrom,
        currentValue: hasChatRequestFrom,
      ),
      id: _mergeHelper(otherMaleModelValue: otherModel.id, currentValue: id),
      name: _mergeHelper(
          otherMaleModelValue: otherModel.name, currentValue: name),
      parentId: _mergeHelper(
          otherMaleModelValue: otherModel.parentId, currentValue: parentId),
      type: _mergeHelper(
          otherMaleModelValue: otherModel.type, currentValue: type),
      gender: _mergeHelper(
          otherMaleModelValue: otherModel.gender, currentValue: gender),
      avatar: _mergeHelper(
          otherMaleModelValue: otherModel.avatar, currentValue: avatar),
      phone: _mergeHelper(
          otherMaleModelValue: otherModel.phone, currentValue: phone),
      countryCode: _mergeHelper(
          otherMaleModelValue: otherModel.countryCode,
          currentValue: countryCode),
      fullPhone: _mergeHelper(
          otherMaleModelValue: otherModel.fullPhone, currentValue: fullPhone),
      identityNumber: _mergeHelper(
          otherMaleModelValue: otherModel.identityNumber,
          currentValue: identityNumber),
      age: _mergeHelper(otherMaleModelValue: otherModel.age, currentValue: age),
      isActive: _mergeHelper(
          otherMaleModelValue: otherModel.isActive, currentValue: isActive),
      isBlocked: _mergeHelper(
          otherMaleModelValue: otherModel.isBlocked, currentValue: isBlocked),
      adminApprovalStatus: _mergeHelper(
          otherMaleModelValue: otherModel.adminApprovalStatus,
          currentValue: adminApprovalStatus),
      completeRegistration: _mergeHelper(
          otherMaleModelValue: otherModel.completeRegistration,
          currentValue: completeRegistration),
      token: _mergeHelper(
          otherMaleModelValue: otherModel.token, currentValue: token),
      nickName: _mergeHelper(
          otherMaleModelValue: otherModel.nickName, currentValue: nickName),
      maritalStatus: _mergeHelper(
          otherMaleModelValue: otherModel.maritalStatus,
          currentValue: maritalStatus),
      height: _mergeHelper(
          otherMaleModelValue: otherModel.height, currentValue: height),
      weight: _mergeHelper(
          otherMaleModelValue: otherModel.weight, currentValue: weight),
      currentJob: _mergeHelper(
          otherMaleModelValue: otherModel.currentJob, currentValue: currentJob),
      bio: _mergeHelper(otherMaleModelValue: otherModel.bio, currentValue: bio),
      hasChildren: _mergeHelper(
          otherMaleModelValue: otherModel.hasChildren,
          currentValue: hasChildren),
      numOfChildren: _mergeHelper(
          otherMaleModelValue: otherModel.numOfChildren,
          currentValue: numOfChildren),
      childCustody: _mergeHelper(
          otherMaleModelValue: otherModel.childCustody,
          currentValue: childCustody),
      wantChildren: _mergeHelper(
          otherMaleModelValue: otherModel.wantChildren,
          currentValue: wantChildren),
      prohibitedThings: _mergeHelper(
          otherMaleModelValue: otherModel.prohibitedThings,
          currentValue: prohibitedThings),
      dowry: _mergeHelper(
          otherMaleModelValue: otherModel.dowry, currentValue: dowry),
      weddingType: _mergeHelper(
          otherMaleModelValue: otherModel.weddingType,
          currentValue: weddingType),
      cityId: _mergeHelper(
          otherMaleModelValue: otherModel.cityId, currentValue: cityId),
      educationLevel: _mergeHelper(
          otherMaleModelValue: otherModel.educationLevel,
          currentValue: educationLevel),
      isPrayer: _mergeHelper(
          otherMaleModelValue: otherModel.isPrayer, currentValue: isPrayer),
      healthConditions: _mergeHelper(
          otherMaleModelValue: otherModel.healthConditions,
          currentValue: healthConditions),
      chatLang: _mergeHelper(
          otherMaleModelValue: otherModel.chatLang, currentValue: chatLang),
      isSmoker: _mergeHelper(
          otherMaleModelValue: otherModel.isSmoker, currentValue: isSmoker),
      tribeAffiliation: _mergeHelper(
          otherMaleModelValue: otherModel.tribeAffiliation,
          currentValue: tribeAffiliation),
      skinColor: _mergeHelper(
          otherMaleModelValue: otherModel.skinColor, currentValue: skinColor),
      religiousCommitment: _mergeHelper(
          otherMaleModelValue: otherModel.religiousCommitment,
          currentValue: religiousCommitment),
      views: _mergeHelper(
          otherMaleModelValue: otherModel.views, currentValue: views),
      isNotify: _mergeHelper(
          otherMaleModelValue: otherModel.isNotify, currentValue: isNotify),
    );
  }

  dynamic _mergeHelper(
      {required dynamic otherMaleModelValue, required dynamic currentValue}) {
    if (otherMaleModelValue is String) {
      return (otherMaleModelValue.isNotNull && otherMaleModelValue.isNotEmpty)
          ? otherMaleModelValue
          : currentValue;
    } else if (otherMaleModelValue is num) {
      return (otherMaleModelValue.isNotNull && otherMaleModelValue != 0)
          ? otherMaleModelValue
          : currentValue;
    } else {
      return (otherMaleModelValue as Object?).isNotNull
          ? otherMaleModelValue
          : currentValue;
    }
  }

  @override
  IndividualUserModel copyWith(
          {CanChat? canChat,
          bool? hasChatWith,
          bool? isParentMatch,
          bool? hasActivePackage,
          bool? isPromoted,
          bool? hasChatRequestFrom,
          ChildParentInfo? childParentInfo,
          String? nickName,
          bool? isNotify,
          TitleValueShape? maritalStatus,
          String? height,
          String? weight,
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
          String? token,
          bool clearNumOfChildren = false,
          bool clearChildCustody = false}) =>
      IndividualUserModel(
        id: id ?? this.id,
        canChat: canChat ?? this.canChat,
        hasChatWith: hasChatWith ?? this.hasChatWith,
        isParentMatch: isParentMatch ?? this.isParentMatch,
        hasActivePackage: hasActivePackage ?? this.hasActivePackage,
        isPromoted: isPromoted ?? this.isPromoted,
        hasChatRequestFrom: hasChatRequestFrom ?? this.hasChatRequestFrom,
        childParentInfo: childParentInfo ?? this.childParentInfo,
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
        numOfChildren:
            clearNumOfChildren ? null : numOfChildren ?? this.numOfChildren,
        childCustody:
            clearChildCustody ? null : childCustody ?? this.childCustody,
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

class ChildParentInfo {
  final int id;
  final String name;
  final String avatar;

  ChildParentInfo({
    required this.id,
    required this.name,
    required this.avatar,
  });

  factory ChildParentInfo.fromJson(Map<String, dynamic> json) =>
      ChildParentInfo(
          id: json['id'], name: json['name'], avatar: json['avatar']);
}

/// Reason why a user is or isn't allowed to start a chat.
enum ChatReason {
  chatWithYourself('chat_with_yourself'),
  blockedByMe('blocked_by_me'),
  accountInactive('account_inactive'),
  notApprovedByAdmin('not_approved_by_admin'),
  blockedByUser('blocked_by_user'),
  targetAccountInactive('target_account_inactive'),
  targetNotApprovedByAdmin('target_not_approved_by_admin'),
  parentCannotChatWithChild('parent_cannot_chat_with_child'),
  childCannotChatWithParent('child_cannot_chat_with_parent'),
  sameGender('same_gender'),
  activeMatchWithOther('active_match_with_other'),
  parentApprovalRequired('parent_approval_required'),
  chatRequestSent('chat_request_sent'),
  noActivePackages('no_active_package'),
  hasProblem('has_problem');

  final String value;
  const ChatReason(this.value);

  static ChatReason? fromValue(String? value) {
    if (value.isNull) return null;
    return ChatReason.values.firstWhere((e) => e.value == value,
        orElse: () => ChatReason.hasProblem);
  }
}

extension ChatReasonExtension on ChatReason? {
  bool get isChatWithYourself => this == ChatReason.chatWithYourself;
  bool get isBlockedByMe => this == ChatReason.blockedByMe;
  bool get isAccountInactive => this == ChatReason.accountInactive;
  bool get isNotApprovedByAdmin => this == ChatReason.notApprovedByAdmin;
  bool get isBlockedByUser => this == ChatReason.blockedByUser;
  bool get isTargetAccountInactive => this == ChatReason.targetAccountInactive;
  bool get isTargetNotApprovedByAdmin =>
      this == ChatReason.targetNotApprovedByAdmin;
  bool get isParentCannotChatWithChild =>
      this == ChatReason.parentCannotChatWithChild;
  bool get isChildCannotChatWithParent =>
      this == ChatReason.childCannotChatWithParent;
  bool get isSameGender => this == ChatReason.sameGender;
  bool get isActiveMatchWithOther => this == ChatReason.activeMatchWithOther;
  bool get isParentApprovalRequired =>
      this == ChatReason.parentApprovalRequired;
  bool get isChatRequestSent => this == ChatReason.chatRequestSent;

  /// Localized message describing the chat reason.
  String get getReason {
    switch (this) {
      case ChatReason.chatWithYourself:
        return LocaleKeys.chatReasonChatWithYourself;
      case ChatReason.blockedByMe:
        return LocaleKeys.chatReasonBlockedByMe;
      case ChatReason.accountInactive:
        return LocaleKeys.chatReasonAccountInactive;
      case ChatReason.notApprovedByAdmin:
        return LocaleKeys.chatReasonNotApprovedByAdmin;
      case ChatReason.blockedByUser:
        return LocaleKeys.chatReasonBlockedByUser;
      case ChatReason.targetAccountInactive:
        return LocaleKeys.chatReasonTargetAccountInactive;
      case ChatReason.targetNotApprovedByAdmin:
        return LocaleKeys.chatReasonTargetNotApprovedByAdmin;
      case ChatReason.parentCannotChatWithChild:
        return LocaleKeys.chatReasonParentCannotChatWithChild;
      case ChatReason.childCannotChatWithParent:
        return LocaleKeys.chatReasonChildCannotChatWithParent;
      case ChatReason.sameGender:
        return LocaleKeys.chatReasonSameGender;
      case ChatReason.activeMatchWithOther:
        return LocaleKeys.chatReasonActiveMatchWithOther;
      case ChatReason.parentApprovalRequired:
        return LocaleKeys.chatReasonParentApprovalRequired;
      case ChatReason.chatRequestSent:
        return LocaleKeys.chatReasonChatRequestSent;
      case ChatReason.noActivePackages:
        return LocaleKeys.theUserDoNotHasActivePackageSubscription;
      case ChatReason.hasProblem:
      case null:
        return LocaleKeys.chatReasonHasProblem;
    }
  }
}

class CanChat {
  final bool canChat;
  final ChatReason? reason;

  const CanChat({required this.canChat, this.reason});

  factory CanChat.initial() => const CanChat(canChat: false);

  factory CanChat.fromJson(dynamic json) {
    if (json == null) return CanChat.initial();
    // Legacy shape: API/cache used to return a plain bool.
    if (json is bool) return CanChat(canChat: json);
    return CanChat(
      canChat: json['can_chat'] ?? false,
      reason: ChatReason.fromValue(json['reason']),
    );
  }

  Map<String, dynamic> toJson() => {
        'can_chat': canChat,
        'reason': reason?.value,
      };

  CanChat copyWith({bool? canChat, ChatReason? reason}) => CanChat(
        canChat: canChat ?? this.canChat,
        reason: reason ?? this.reason,
      );
}
