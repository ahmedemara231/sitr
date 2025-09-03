import 'dart:io';
import '../../../config/language/languages.dart';
import '../presentation/widgets/sign_up/shared_form_fields.dart';
import 'dowry.dart';

class SharedFormFieldModel{
  final String nickName;
  final String maritalStatus;
  final double? tall;
  final double? weight;
  final String? currentJob;
  final String? quickBrief;
  final Answer? childrenExists;
  final int? childrenNumber;
  final String? nursery;
  final bool? wantToHaveChildren;
  final String? thingsIAcceptOrWant;
  final String? typeOfWeddingParty;
  final String? city;
  final String? educationalQualification;
  final bool? pray;
  final String? diseasesIfExists;
  final Languages? inChatYouPrefer;
  final bool? smoke;
  final bool? belongToATribe;
  final String? skinColor;

  factory SharedFormFieldModel.initial() => SharedFormFieldModel(
    nickName: "",
    maritalStatus: "",
    tall: null,
    weight: null,
    currentJob: null,
    quickBrief: null,
    childrenExists: null,
    childrenNumber: null,
    nursery: null,
    wantToHaveChildren: null,
    thingsIAcceptOrWant: null,
    typeOfWeddingParty: null,
    city: null,
    educationalQualification: null,
    pray: null,
    diseasesIfExists: null,
    inChatYouPrefer: null,
    smoke: null,
    belongToATribe: null,
    skinColor: null,
  );

  SharedFormFieldModel({
    required this.nickName,
    required this.maritalStatus,
    required this.tall,
    required this.weight,
    required this.currentJob,
    required this.quickBrief,
    required this.childrenExists,
    required this.childrenNumber,
    required this.nursery,
    required this.wantToHaveChildren,
    required this.thingsIAcceptOrWant,
    required this.typeOfWeddingParty,
    required this.city,
    required this.educationalQualification,
    required this.pray,
    required this.diseasesIfExists,
    required this.inChatYouPrefer,
    required this.smoke,
    required this.belongToATribe,
    required this.skinColor,
  });
}

class MaleFields extends SharedFormFieldModel{
  final File? image;
  final String? phone;
  final int identifyNumber;
  final int age;

  MaleFields({
    required this.image,
    required this.phone,
    required this.identifyNumber,
    required this.age,
    required super.nickName,
    required super.maritalStatus,
    required super.tall,
    required super.weight,
    required super.currentJob,
    required super.quickBrief,
    required super.childrenExists,
    required super.childrenNumber,
    required super.nursery,
    required super.wantToHaveChildren,
    required super.thingsIAcceptOrWant,
    required super.typeOfWeddingParty,
    required super.city,
    required super.educationalQualification,
    required super.pray,
    required super.diseasesIfExists,
    required super.inChatYouPrefer,
    required super.smoke,
    required super.belongToATribe,
    required super.skinColor
  });
}

class FemaleFields extends SharedFormFieldModel{
  final String? whereDoYouAcceptToLiveAfterMarriage;
  final bool? acceptPolygamy;
  final bool waerHijab;
  final String degreeOfCommitment;
  final String? parentName;
  final String? parentNumber;
  final Dowry? dowry;

  FemaleFields({
    required this.whereDoYouAcceptToLiveAfterMarriage,
    required this.acceptPolygamy,
    required this.waerHijab,
    required this.degreeOfCommitment,
    required this.parentName,
    required this.parentNumber,
    required this.dowry,
    required super.nickName,
    required super.maritalStatus,
    required super.tall,
    required super.weight,
    required super.currentJob,
    required super.quickBrief,
    required super.childrenExists,
    required super.childrenNumber,
    required super.nursery,
    required super.wantToHaveChildren,
    required super.thingsIAcceptOrWant,
    required super.typeOfWeddingParty,
    required super.city,
    required super.educationalQualification,
    required super.pray,
    required super.diseasesIfExists,
    required super.inChatYouPrefer,
    required super.smoke,
    required super.belongToATribe,
    required super.skinColor
  });
}