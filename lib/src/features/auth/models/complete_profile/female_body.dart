// import '../../../../config/language/languages.dart';
// import '../../presentation/data/enums_data.dart';
// import '../dowry.dart';
// import '../shared_form_fields_model.dart';
// import '../sign_up_body.dart';
//
// class FemaleCompleteProfileBody extends SharedFormFieldModel {
//   final String liveAfterMarry;
//   final bool? doYouAcceptPolygamy;
//   final String? wearingHijab;
//   final String degreeOfCommitment;
//   final String parentName;
//   final String parentNumber;
//   final int kinship;
//
//   FemaleCompleteProfileBody(
//       {required this.liveAfterMarry,
//       required this.doYouAcceptPolygamy,
//       required this.wearingHijab,
//       required this.degreeOfCommitment,
//       required this.parentName,
//       required this.parentNumber,
//       required this.kinship,
//       required super.dowry,
//       required super.nickName,
//       required super.maritalStatus,
//       required super.tall,
//       required super.weight,
//       required super.currentJob,
//       required super.quickBrief,
//       required super.childrenExists,
//       required super.childrenNumber,
//       required super.nursery,
//       required super.wantToHaveChildren,
//       required super.thingsIAcceptOrWant,
//       required super.typeOfWeddingParty,
//       required super.cityId,
//       required super.educationalQualification,
//       required super.pray,
//       required super.diseasesIfExists,
//       required super.inChatYouPrefer,
//       required super.smoke,
//       required super.belongToATribe,
//       required super.skinColor});
//
//   factory FemaleCompleteProfileBody.initial() => FemaleCompleteProfileBody(
//         nickName: '',
//         maritalStatus: '',
//         tall: '',
//         weight: '',
//         currentJob: '',
//         quickBrief: '',
//         childrenExists: null,
//         childrenNumber: '',
//         nursery: EnumsData.childCustody.data.first.value,
//         wantToHaveChildren: null,
//         thingsIAcceptOrWant: '',
//         typeOfWeddingParty: '',
//         cityId: 0,
//         educationalQualification: '',
//         pray: null,
//         diseasesIfExists: '',
//         inChatYouPrefer: Languages.arabic.languageCode,
//         smoke: null,
//         belongToATribe: null,
//         skinColor: '',
//         dowry: Dowry(from: 'from', to: 'to'),
//         liveAfterMarry: '',
//         doYouAcceptPolygamy: null,
//         wearingHijab: null,
//         degreeOfCommitment: '',
//         parentName: '',
//         parentNumber: '',
//         kinship: 0,
//       );
//
//   @override
//   SharedFormFieldModel copyWith(
//           {Dowry? dowry,
//           String? liveAfterMarry,
//           bool? doYouAcceptPolygamy,
//           String? wearingHijab,
//           String? degreeOfCommitment,
//           String? parentName,
//           String? parentNumber,
//           int? kinship,
//           String? nickName,
//           String? maritalStatus,
//           String? tall,
//           String? weight,
//           String? currentJob,
//           String? quickBrief,
//           bool? childrenExists,
//           String? childrenNumber,
//           String? nursery,
//           bool? wantToHaveChildren,
//           String? thingsIAcceptOrWant,
//           String? typeOfWeddingParty,
//           int? cityId,
//           String? educationalQualification,
//           bool? pray,
//           String? diseasesIfExists,
//           String? inChatYouPrefer,
//           bool? smoke,
//           bool? belongToATribe,
//           String? skinColor}) =>
//       FemaleCompleteProfileBody(
//         nickName: nickName ?? this.nickName,
//         maritalStatus: maritalStatus ?? this.maritalStatus,
//         tall: tall ?? this.tall,
//         weight: weight ?? this.weight,
//         currentJob: currentJob ?? this.currentJob,
//         quickBrief: quickBrief ?? this.quickBrief,
//         childrenExists: childrenExists ?? this.childrenExists,
//         childrenNumber: childrenNumber ?? this.childrenNumber,
//         nursery: nursery ?? this.nursery,
//         wantToHaveChildren: wantToHaveChildren ?? this.wantToHaveChildren,
//         thingsIAcceptOrWant: thingsIAcceptOrWant ?? this.thingsIAcceptOrWant,
//         typeOfWeddingParty: typeOfWeddingParty ?? this.typeOfWeddingParty,
//         cityId: cityId ?? this.cityId,
//         educationalQualification:
//         educationalQualification ?? this.educationalQualification,
//         pray: pray ?? this.pray,
//         diseasesIfExists: diseasesIfExists ?? this.diseasesIfExists,
//         inChatYouPrefer: inChatYouPrefer ?? this.inChatYouPrefer,
//         smoke: smoke ?? this.smoke,
//         belongToATribe: belongToATribe ?? this.belongToATribe,
//         skinColor: skinColor ?? this.skinColor,
//         dowry: dowry ?? this.dowry,
//         liveAfterMarry: liveAfterMarry ?? this.liveAfterMarry,
//         doYouAcceptPolygamy: doYouAcceptPolygamy ?? this.doYouAcceptPolygamy,
//         wearingHijab: wearingHijab ?? this.wearingHijab,
//         degreeOfCommitment: degreeOfCommitment ?? this.degreeOfCommitment,
//         parentName: parentName ?? this.parentName,
//         parentNumber: parentNumber ?? this.parentNumber,
//         kinship: kinship ?? this.kinship,
//       );
//
//   @override
//   Map<String, dynamic> toJson() {
//     final base = super.toJson();
//     return {
//       ...base,
//       'preferred_residence_after_marriage': liveAfterMarry,
//       'accepts_polygamy': doYouAcceptPolygamy,
//       'guardian_name': parentName,
//       'guardian_phone': parentNumber,
//       'guardian_relation_id': kinship,
//       'hijab': wearingHijab,
//       'religious_commitment': degreeOfCommitment,
//     };
//   }
// }
//
// class FemaleParentCompleteProfileBody extends SharedFormFieldModel {
//   final String name;
//   final String liveAfterMarry;
//   final bool? doYouAcceptPolygamy;
//   final String? wearingHijab;
//   final String degreeOfCommitment;
//
//   final String phone;
//   final String identifyNumber;
//   final String age;
//
//   final String parentName;
//   final String parentNumber;
//   final int kinship;
//
//   FemaleParentCompleteProfileBody({
//     required this.name,
//     required this.phone,
//     required this.identifyNumber,
//     required this.age,
//
//       required this.liveAfterMarry,
//       required this.wearingHijab,
//       required this.doYouAcceptPolygamy,
//       required this.degreeOfCommitment,
//       required this.parentName,
//       required this.parentNumber,
//       required this.kinship,
//
//       required super.dowry,
//       required super.nickName,
//       required super.maritalStatus,
//       required super.tall,
//       required super.weight,
//       required super.currentJob,
//       required super.quickBrief,
//       required super.childrenExists,
//       required super.childrenNumber,
//       required super.nursery,
//       required super.wantToHaveChildren,
//       required super.thingsIAcceptOrWant,
//       required super.typeOfWeddingParty,
//       required super.cityId,
//       required super.educationalQualification,
//       required super.pray,
//       required super.diseasesIfExists,
//       required super.inChatYouPrefer,
//       required super.smoke,
//       required super.belongToATribe,
//       required super.skinColor
//   });
//
//   @override
//   SharedFormFieldModel copyWith({
//     int? kinship,
//     Dowry? dowry,
//     MaleAndFemaleSignUp? signUpBody,
//     String? name,
//     String? phone,
//     String? identifyNumber,
//     String? age,
//     String? liveAfterMarry,
//     bool? doYouAcceptPolygamy,
//     String? wearingHijab,
//     String? degreeOfCommitment,
//     String? parentName,
//     String? parentNumber,
//     String? nickName,
//     String? maritalStatus,
//     String? tall,
//     String? weight,
//     String? currentJob,
//     String? quickBrief,
//     bool? childrenExists,
//     String? childrenNumber,
//     String? nursery,
//     bool? wantToHaveChildren,
//     String? thingsIAcceptOrWant,
//     String? typeOfWeddingParty,
//     int? cityId,
//     String? educationalQualification,
//     bool? pray,
//     String? diseasesIfExists,
//     String? inChatYouPrefer,
//     bool? smoke,
//     bool? belongToATribe,
//     String? skinColor,
//   }) => FemaleParentCompleteProfileBody(
//         name: name ?? this.name,
//         parentName: parentName??this.parentName,
//         parentNumber: parentNumber??this.parentNumber,
//         kinship: kinship??this.kinship,
//         phone: phone ?? this.phone,
//         identifyNumber: identifyNumber ?? this.identifyNumber,
//         age: age ?? this.age,
//         nickName: nickName ?? this.nickName,
//         maritalStatus: maritalStatus ?? this.maritalStatus,
//         tall: tall ?? this.tall,
//         weight: weight ?? this.weight,
//         currentJob: currentJob ?? this.currentJob,
//         quickBrief: quickBrief ?? this.quickBrief,
//         childrenExists: childrenExists ?? this.childrenExists,
//         childrenNumber: childrenNumber ?? this.childrenNumber,
//         nursery: nursery ?? this.nursery,
//         wantToHaveChildren: wantToHaveChildren ?? this.wantToHaveChildren,
//         thingsIAcceptOrWant: thingsIAcceptOrWant ?? this.thingsIAcceptOrWant,
//         typeOfWeddingParty: typeOfWeddingParty ?? this.typeOfWeddingParty,
//         cityId: cityId ?? this.cityId,
//         educationalQualification:
//             educationalQualification ?? this.educationalQualification,
//         pray: pray ?? this.pray,
//         diseasesIfExists: diseasesIfExists ?? this.diseasesIfExists,
//         inChatYouPrefer: inChatYouPrefer ?? this.inChatYouPrefer,
//         smoke: smoke ?? this.smoke,
//         belongToATribe: belongToATribe ?? this.belongToATribe,
//         skinColor: skinColor ?? this.skinColor,
//         dowry: dowry ?? this.dowry,
//         liveAfterMarry: liveAfterMarry ?? this.liveAfterMarry,
//         doYouAcceptPolygamy: doYouAcceptPolygamy ?? this.doYouAcceptPolygamy,
//         wearingHijab: wearingHijab ?? this.wearingHijab,
//         degreeOfCommitment: degreeOfCommitment ?? this.degreeOfCommitment,
//       );
//
//   factory FemaleParentCompleteProfileBody.initial() =>
//       FemaleParentCompleteProfileBody(
//           phone: '',
//           identifyNumber: '',
//           age: '',
//           nickName: '',
//           maritalStatus: '',
//           tall: '',
//           weight: '',
//           currentJob: '',
//           quickBrief: '',
//           childrenExists: null,
//           childrenNumber: '',
//           nursery: EnumsData.childCustody.data.first.value,
//           wantToHaveChildren: null,
//           thingsIAcceptOrWant: '',
//           typeOfWeddingParty: '',
//           cityId: 0,
//           educationalQualification: '',
//           pray: null,
//           diseasesIfExists: '',
//           inChatYouPrefer: Languages.arabic.languageCode,
//           smoke: null,
//           belongToATribe: null,
//           skinColor: '',
//           dowry: Dowry(from: 'from', to: 'to'),
//           liveAfterMarry: '',
//           doYouAcceptPolygamy: null,
//           wearingHijab: null,
//           degreeOfCommitment: '',
//           parentName: '',
//           parentNumber: '',
//           kinship: 0,
//           name: ''
//       );
//
//   @override
//   Map<String, dynamic> toJson() {
//     return super.toJson()
//       ..addAll({
//         'identity_number' : identifyNumber,
//         'age' : age,
//         'gender' : 'female',
//         'preferred_residence_after_marriage': liveAfterMarry,
//         'accepts_polygamy': doYouAcceptPolygamy,
//         'phone' : phone,
//
//         'guardian_name': parentName,
//         'guardian_phone': parentNumber,
//         'guardian_relation_id': kinship,
//
//         'name': name,
//         'hijab': wearingHijab,
//         'religious_commitment': degreeOfCommitment
//       });
//   }
// }
