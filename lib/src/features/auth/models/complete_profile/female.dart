import '../../../../config/language/languages.dart';
import '../../../../core/extensions/enum.dart';
import '../../presentation/enums/answer.dart';
import '../../presentation/enums/nursery.dart';
import '../dowry.dart';
import '../shared_form_fields_model.dart';

class FemaleCompleteProfileBody extends SharedFormFieldModel{
  final Dowry dowry;
  final String liveAfterMarry;
  final Answer doYouAcceptPolygamy;
  final Answer wearingHijab;
  final String degreeOfCommitment;
  final String parentName;
  final String parentNumber;
  final String kinship;

  FemaleCompleteProfileBody({
    required this.dowry,
    required this.liveAfterMarry,
    required this.doYouAcceptPolygamy,
    required this.wearingHijab,
    required this.degreeOfCommitment,
    required this.parentName,
    required this.parentNumber,
    required this.kinship,

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

  factory FemaleCompleteProfileBody.initial() => FemaleCompleteProfileBody(
    nickName: '',
    maritalStatus: '',
    tall: '',
    weight: '',
    currentJob: '',
    quickBrief: '',
    childrenExists: Answer.yes,
    childrenNumber: '',
    nursery: Nursery.father,
    wantToHaveChildren: Answer.yes,
    thingsIAcceptOrWant: '',
    typeOfWeddingParty: '',
    city: '',
    educationalQualification: '',
    pray: Answer.yes,
    diseasesIfExists: '',
    inChatYouPrefer: Languages.arabic,
    smoke: Answer.yes,
    belongToATribe: Answer.yes,
    skinColor: '',
    dowry: Dowry(from: 'from', to: 'to'),
    liveAfterMarry: '',
    doYouAcceptPolygamy: Answer.yes,
    wearingHijab: Answer.yes,
    degreeOfCommitment: '',
    parentName: '',
    parentNumber: '',
    kinship: '',
  );

  @override
  SharedFormFieldModel copyWith({
    Dowry? dowry,
    String? liveAfterMarry, Answer? doYouAcceptPolygamy, Answer? wearingHijab, String? degreeOfCommitment, String? parentName, String? parentNumber, String? kinship,
    String? nickName, String? maritalStatus, String? tall, String? weight, String? currentJob, String? quickBrief, Answer? childrenExists, String? childrenNumber, Nursery? nursery, Answer? wantToHaveChildren, String? thingsIAcceptOrWant, String? typeOfWeddingParty, String? city, String? educationalQualification, Answer? pray, String? diseasesIfExists, Languages? inChatYouPrefer, Answer? smoke, Answer? belongToATribe, String? skinColor}) => FemaleCompleteProfileBody(

    nickName: nickName ?? this.nickName,
    maritalStatus: maritalStatus ?? this.maritalStatus,
    tall: tall ?? this.tall,
    weight: weight ?? this.weight,
    currentJob: currentJob ?? this.currentJob,
    quickBrief: quickBrief ?? this.quickBrief,
    childrenExists: childrenExists ?? this.childrenExists,
    childrenNumber: childrenNumber ?? this.childrenNumber,
    nursery: nursery ?? this.nursery,
    wantToHaveChildren: wantToHaveChildren ?? this.wantToHaveChildren,
    thingsIAcceptOrWant: thingsIAcceptOrWant ?? this.thingsIAcceptOrWant,
    typeOfWeddingParty: typeOfWeddingParty ?? this.typeOfWeddingParty,
    city: city ?? this.city,
    educationalQualification: educationalQualification ?? this.educationalQualification,
    pray: pray ?? this.pray,
    diseasesIfExists: diseasesIfExists ?? this.diseasesIfExists,
    inChatYouPrefer: inChatYouPrefer ?? this.inChatYouPrefer,
    smoke: smoke ?? this.smoke,
    belongToATribe: belongToATribe ?? this.belongToATribe,
    skinColor: skinColor ?? this.skinColor,
    dowry: dowry?? this.dowry,
    liveAfterMarry: liveAfterMarry ?? this.liveAfterMarry,
    doYouAcceptPolygamy: doYouAcceptPolygamy ?? this.doYouAcceptPolygamy,
    wearingHijab: wearingHijab ?? this.wearingHijab,
    degreeOfCommitment: degreeOfCommitment ?? this.degreeOfCommitment,
    parentName: parentName ?? this.parentName,
    parentNumber: parentNumber ?? this.parentNumber,
    kinship: kinship ?? this.kinship,
  );

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()..addAll({
      'dowry_min' : dowry.from,
      'dowry_max' : dowry.to,
      'preferred_residence_after_marriage' : liveAfterMarry,
      'accepts_polygamy' : doYouAcceptPolygamy.translate,
      'guardian_name' : parentName,
      'guardian_phone' : parentNumber,
      'guardian_relation_id' : kinship,
    });
  }
}

class FemaleParentCompleteProfileBody extends SharedFormFieldModel{
  final String name;
  final Dowry dowry;
  final String liveAfterMarry;
  final Answer doYouAcceptPolygamy;
  final Answer wearingHijab;
  final String degreeOfCommitment;
  final String parentName;
  final String parentNumber;

  FemaleParentCompleteProfileBody({
    required this.name,
    required this.dowry,
    required this.liveAfterMarry,
    required this.wearingHijab,
    required this.doYouAcceptPolygamy,
    required this.degreeOfCommitment,
    required this.parentName,
    required this.parentNumber,

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

  @override
  SharedFormFieldModel copyWith({
    Dowry? dowry,
    String? name,
    String? liveAfterMarry, Answer? doYouAcceptPolygamy, Answer? wearingHijab, String? degreeOfCommitment, String? parentName, String? parentNumber,
    String? nickName, String? maritalStatus, String? tall, String? weight, String? currentJob, String? quickBrief, Answer? childrenExists, String? childrenNumber, Nursery? nursery, Answer? wantToHaveChildren, String? thingsIAcceptOrWant, String? typeOfWeddingParty, String? city, String? educationalQualification, Answer? pray, String? diseasesIfExists, Languages? inChatYouPrefer, Answer? smoke, Answer? belongToATribe, String? skinColor}) => FemaleParentCompleteProfileBody(

    name: name ?? this.name,
    nickName: nickName ?? this.nickName,
    maritalStatus: maritalStatus ?? this.maritalStatus,
    tall: tall ?? this.tall,
    weight: weight ?? this.weight,
    currentJob: currentJob ?? this.currentJob,
    quickBrief: quickBrief ?? this.quickBrief,
    childrenExists: childrenExists ?? this.childrenExists,
    childrenNumber: childrenNumber ?? this.childrenNumber,
    nursery: nursery ?? this.nursery,
    wantToHaveChildren: wantToHaveChildren ?? this.wantToHaveChildren,
    thingsIAcceptOrWant: thingsIAcceptOrWant ?? this.thingsIAcceptOrWant,
    typeOfWeddingParty: typeOfWeddingParty ?? this.typeOfWeddingParty,
    city: city ?? this.city,
    educationalQualification: educationalQualification ?? this.educationalQualification,
    pray: pray ?? this.pray,
    diseasesIfExists: diseasesIfExists ?? this.diseasesIfExists,
    inChatYouPrefer: inChatYouPrefer ?? this.inChatYouPrefer,
    smoke: smoke ?? this.smoke,
    belongToATribe: belongToATribe ?? this.belongToATribe,
    skinColor: skinColor ?? this.skinColor,
    dowry: dowry?? this.dowry,
    liveAfterMarry: liveAfterMarry ?? this.liveAfterMarry,
    doYouAcceptPolygamy: doYouAcceptPolygamy ?? this.doYouAcceptPolygamy,
    wearingHijab: wearingHijab ?? this.wearingHijab,
    degreeOfCommitment: degreeOfCommitment ?? this.degreeOfCommitment,
    parentName: parentName ?? this.parentName,
    parentNumber: parentNumber ?? this.parentNumber,
  );

  factory FemaleParentCompleteProfileBody.initial() => FemaleParentCompleteProfileBody(
    nickName: '',
    maritalStatus: '',
    tall: '',
    weight: '',
    currentJob: '',
    quickBrief: '',
    childrenExists: Answer.yes,
    childrenNumber: '',
    nursery: Nursery.father,
    wantToHaveChildren: Answer.yes,
    thingsIAcceptOrWant: '',
    typeOfWeddingParty: '',
    city: '',
    educationalQualification: '',
    pray: Answer.yes,
    diseasesIfExists: '',
    inChatYouPrefer: Languages.arabic,
    smoke: Answer.yes,
    belongToATribe: Answer.yes,
    skinColor: '',
    dowry: Dowry(from: 'from', to: 'to'),
    liveAfterMarry: '',
    doYouAcceptPolygamy: Answer.yes,
    wearingHijab: Answer.yes,
    degreeOfCommitment: '',
    parentName: '',
    parentNumber: '',
    name: ''
  );

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()..addAll({
      'dowry_min' : dowry.from,
      'dowry_max' : dowry.to,
      'preferred_residence_after_marriage' : liveAfterMarry,
      'accepts_polygamy' : doYouAcceptPolygamy.translate,
      'guardian_name' : parentName,
      'guardian_phone' : parentNumber,
      'name' : name
    });
  }

}