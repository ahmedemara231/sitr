import '../../../config/language/languages.dart';
import '../../../core/extensions/enum.dart';
import '../presentation/enums/answer.dart';
import '../presentation/enums/nursery.dart';

class SharedFormFieldModel{
  final String nickName;
  final String maritalStatus;
  final String? tall;
  final String? weight;
  final String? currentJob;
  final String? quickBrief;
  final Answer? childrenExists;
  final String? childrenNumber;
  final Nursery? nursery;
  final Answer? wantToHaveChildren;
  final String? thingsIAcceptOrWant;
  final String? typeOfWeddingParty;
  final String? city;
  final String? educationalQualification;
  final Answer? pray;
  final String? diseasesIfExists;
  final Languages? inChatYouPrefer;
  final Answer? smoke;
  final Answer? belongToATribe;
  final String? skinColor;

  Map<String, dynamic> toJson() => {
    "nick_name": nickName,
    "marital_status": maritalStatus,
    "tall": tall,
    "weight": weight,
    "current_job": currentJob,
    "bio": quickBrief,
    "has_children": childrenExists?.translate,
    "num_of_children": childrenNumber,
    "child_custody": nursery?.translate,
    "want_children": wantToHaveChildren?.translate,
    "prohibited_things": thingsIAcceptOrWant,
    "wedding_type": typeOfWeddingParty,
    "city_id": city,
    "education_level": educationalQualification,
    "is_prayer": pray?.translate,
    "health_conditions": diseasesIfExists,
    "chat_lang": inChatYouPrefer?.translate,
    "is_smoker": smoke?.translate,
    "tribe_affiliation": belongToATribe?.translate,
    "skin_color": skinColor,
  };

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

  SharedFormFieldModel copyWith({
    String? nickName,
    String? maritalStatus,
    String? tall,
    String? weight,
    String? currentJob,
    String? quickBrief,
    Answer? childrenExists,
    String? childrenNumber,
    Nursery? nursery,
    Answer? wantToHaveChildren,
    String? thingsIAcceptOrWant,
    String? typeOfWeddingParty,
    String? city,
    String? educationalQualification,
    Answer? pray,
    String? diseasesIfExists,
    Languages? inChatYouPrefer,
    Answer? smoke,
    Answer? belongToATribe,
    String? skinColor,
}) => SharedFormFieldModel(
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