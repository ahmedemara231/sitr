import 'dowry.dart';

class SharedFormFieldModel{
  final String nickName;
  final Dowry dowry;
  final String maritalStatus;
  final String? tall;
  final String? weight;
  final String? currentJob;
  final String? quickBrief;
  final bool? childrenExists;
  final String? childrenNumber;
  final String? nursery;
  final bool? wantToHaveChildren;
  final String? thingsIAcceptOrWant;
  final String? typeOfWeddingParty;
  final int? cityId;
  final String? educationalQualification;
  final bool? pray;
  final String? diseasesIfExists;
  final String? inChatYouPrefer;
  final bool? smoke;
  final bool? belongToATribe;
  final String? skinColor;

  Map<String, dynamic> toJson() => {
    'dowry_min' : dowry.from,
    'dowry_max' : dowry.to,
    "nick_name": nickName,
    "marital_status": maritalStatus,
    "height": tall,
    "weight": weight,
    "current_job": currentJob,
    "bio": quickBrief,
    "has_children": childrenExists,
    "num_of_children": childrenNumber,
    "child_custody": nursery,
    "want_children": wantToHaveChildren,
    "prohibited_things": thingsIAcceptOrWant,
    "wedding_type": typeOfWeddingParty,
    "city_id": cityId,
    "education_level": educationalQualification,
    "is_prayer": pray,
    "health_conditions": diseasesIfExists,
    "chat_lang": inChatYouPrefer,
    "is_smoker": smoke,
    "tribe_affiliation": belongToATribe,
    "skin_color": skinColor,
  };

  factory SharedFormFieldModel.initial() => SharedFormFieldModel(
    dowry: Dowry(from: 'from', to: 'to'),
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
    cityId: null,
    educationalQualification: null,
    pray: null,
    diseasesIfExists: 'null',
    inChatYouPrefer: null,
    smoke: null,
    belongToATribe: null,
    skinColor: null,
  );

  SharedFormFieldModel copyWith({
    Dowry? dowry,
    String? nickName,
    String? maritalStatus,
    String? tall,
    String? weight,
    String? currentJob,
    String? quickBrief,
    bool? childrenExists,
    String? childrenNumber,
    String? nursery,
    bool? wantToHaveChildren,
    String? thingsIAcceptOrWant,
    String? typeOfWeddingParty,
    int? cityId,
    String? educationalQualification,
    bool? pray,
    String? diseasesIfExists,
    String? inChatYouPrefer,
    bool? smoke,
    bool? belongToATribe,
    String? skinColor,
  }) => SharedFormFieldModel(
    dowry: dowry ?? this.dowry,
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
    cityId: cityId ?? this.cityId,
    educationalQualification: educationalQualification ?? this.educationalQualification,
    pray: pray ?? this.pray,
    diseasesIfExists: diseasesIfExists ?? this.diseasesIfExists,
    inChatYouPrefer: inChatYouPrefer ?? this.inChatYouPrefer,
    smoke: smoke ?? this.smoke,
    belongToATribe: belongToATribe ?? this.belongToATribe,
    skinColor: skinColor ?? this.skinColor,
  );

  SharedFormFieldModel merge(SharedFormFieldModel other) {
    return copyWith(
      nickName: other.nickName ?? nickName,
      maritalStatus: other.maritalStatus ?? maritalStatus,
      tall: other.tall ?? tall,
      weight: other.weight ?? weight,
      currentJob: other.currentJob ?? currentJob,
      quickBrief: other.quickBrief ?? quickBrief,
      childrenExists: other.childrenExists ?? childrenExists,
      childrenNumber: other.childrenNumber ?? childrenNumber,
      nursery: other.nursery ?? nursery,
      wantToHaveChildren: other.wantToHaveChildren ?? wantToHaveChildren,
      thingsIAcceptOrWant: other.thingsIAcceptOrWant ?? thingsIAcceptOrWant,
      dowry: other.dowry ?? dowry,
      typeOfWeddingParty: other.typeOfWeddingParty ?? typeOfWeddingParty,
      cityId: other.cityId ?? cityId,
      educationalQualification:
      other.educationalQualification ?? educationalQualification,
      pray: other.pray ?? pray,
      diseasesIfExists: other.diseasesIfExists ?? diseasesIfExists,
      inChatYouPrefer: other.inChatYouPrefer ?? inChatYouPrefer,
      smoke: other.smoke ?? smoke,
      belongToATribe: other.belongToATribe ?? belongToATribe,
      skinColor: other.skinColor ?? skinColor,
    );
  }

  SharedFormFieldModel({
    required this.dowry,
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
    required this.cityId,
    required this.educationalQualification,
    required this.pray,
    required this.diseasesIfExists,
    required this.inChatYouPrefer,
    required this.smoke,
    required this.belongToATribe,
    required this.skinColor,
  });
}