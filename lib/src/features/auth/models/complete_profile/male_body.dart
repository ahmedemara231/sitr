// import 'dart:developer';
// import 'dart:io';
// import '../../../../config/language/languages.dart';
// import '../../../../core/extensions/object.dart';
// import '../../../../core/shared/models/user_models/individual/male_model.dart';
// import '../../../../core/shared/models/user_models/user_model.dart';
// import '../../presentation/data/enums_data.dart';
// import '../dowry.dart';
// import '../shared_form_fields_model.dart';
//
// class MaleCompleteProfileBody extends SharedFormFieldModel{
//   final String degreeOfCommitment;
//
//   MaleCompleteProfileBody({
//     required this.degreeOfCommitment,
//
//     required super.dowry,
//     required super.nickName,
//     required super.maritalStatus,
//     required super.tall,
//     required super.weight,
//     required super.currentJob,
//     required super.quickBrief,
//     required super.childrenExists,
//     required super.childrenNumber,
//     required super.nursery,
//     required super.wantToHaveChildren,
//     required super.thingsIAcceptOrWant,
//     required super.typeOfWeddingParty,
//     required super.cityId,
//     required super.educationalQualification,
//     required super.pray,
//     required super.diseasesIfExists,
//     required super.inChatYouPrefer,
//     required super.smoke,
//     required super.belongToATribe,
//     required super.skinColor
//   });
//
//   factory MaleCompleteProfileBody.initial() => UserModel.currentUser.isNotNull?
//   MaleCompleteProfileBody.fromMaleModel() :
//   MaleCompleteProfileBody(degreeOfCommitment: '', dowry: Dowry(from: 'from', to: 'to'), nickName: 'nickName', maritalStatus: 'maritalStatus', tall: 'tall', weight: 'weight', currentJob: 'currentJob', quickBrief: 'quickBrief', childrenExists: null, childrenNumber: 'childrenNumber', nursery: EnumsData.childCustody.data.first.value, wantToHaveChildren: null, thingsIAcceptOrWant: 'thingsIAcceptOrWant', typeOfWeddingParty: 'typeOfWeddingParty', cityId: 0, educationalQualification: 'educationalQualification', pray: null, diseasesIfExists: 'diseasesIfExists', inChatYouPrefer: Languages.arabic.languageCode, smoke: null, belongToATribe: null, skinColor: 'skinColor');
//
//   factory MaleCompleteProfileBody.fromMaleModel(){
//     final maleModel = UserModel.currentUser as MaleModel?;
//
//     return MaleCompleteProfileBody(
//         degreeOfCommitment: maleModel!.religiousCommitment!.title,
//         dowry: Dowry(
//             from: maleModel.dowry!.from.toString(),
//             to: maleModel.dowry!.to.toString()
//         ),
//         nickName: maleModel.nickName??'',
//         maritalStatus: maleModel.maritalStatus?.title??'',
//         tall: maleModel.height.toString(),
//         weight: maleModel.weight.toString(),
//         currentJob: maleModel.currentJob,
//         quickBrief: maleModel.bio,
//         childrenExists: maleModel.hasChildren,
//         childrenNumber: maleModel.numOfChildren.toString(),
//         nursery: maleModel.childCustody?.title,
//         wantToHaveChildren: maleModel.wantChildren,
//         thingsIAcceptOrWant: maleModel.prohibitedThings,
//         typeOfWeddingParty: maleModel.weddingType?.title,
//         cityId: maleModel.cityId?.id,
//         educationalQualification: maleModel.educationLevel,
//         pray: maleModel.isPrayer,
//         diseasesIfExists: maleModel.healthConditions,
//         inChatYouPrefer: maleModel.chatLang,
//         smoke: maleModel.isSmoker,
//         belongToATribe: maleModel.tribeAffiliation,
//         skinColor: maleModel.skinColor?.title
//     );
//   }
//
//   @override
//   MaleCompleteProfileBody merge(SharedFormFieldModel other) {
//     return copyWith(
//       // degreeOfCommitment: (other.degreeOfCommitment as MaleCompleteProfileBody) ?? degreeOfCommitment,
//       nickName: other.nickName ?? nickName,
//       maritalStatus: other.maritalStatus ?? maritalStatus,
//       tall: other.tall ?? tall,
//       weight: other.weight ?? weight,
//       currentJob: other.currentJob ?? currentJob,
//       quickBrief: other.quickBrief ?? quickBrief,
//       childrenExists: other.childrenExists ?? childrenExists,
//       childrenNumber: other.childrenNumber ?? childrenNumber,
//       nursery: other.nursery ?? nursery,
//       wantToHaveChildren: other.wantToHaveChildren ?? wantToHaveChildren,
//       thingsIAcceptOrWant: other.thingsIAcceptOrWant ?? thingsIAcceptOrWant,
//       dowry: other.dowry ?? dowry,
//       typeOfWeddingParty: other.typeOfWeddingParty ?? typeOfWeddingParty,
//       cityId: other.cityId ?? cityId,
//       educationalQualification:
//       other.educationalQualification ?? educationalQualification,
//       pray: other.pray ?? pray,
//       diseasesIfExists: other.diseasesIfExists ?? diseasesIfExists,
//       inChatYouPrefer: other.inChatYouPrefer ?? inChatYouPrefer,
//       smoke: other.smoke ?? smoke,
//       belongToATribe: other.belongToATribe ?? belongToATribe,
//       skinColor: other.skinColor ?? skinColor,
//     );
//   }
//
//   @override
//   MaleCompleteProfileBody copyWith({
//     String? degreeOfCommitment,
//     Dowry? dowry,
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
//   }) => MaleCompleteProfileBody(
//     degreeOfCommitment: degreeOfCommitment ?? this.degreeOfCommitment,
//     dowry: dowry ?? this.dowry,
//     nickName: nickName ?? this.nickName,
//     maritalStatus: maritalStatus ?? this.maritalStatus,
//     tall: tall ?? this.tall,
//     weight: weight ?? this.weight,
//     currentJob: currentJob ?? this.currentJob,
//     quickBrief: quickBrief ?? this.quickBrief,
//     childrenExists: childrenExists ?? this.childrenExists,
//     childrenNumber: childrenNumber ?? this.childrenNumber,
//     nursery: nursery ?? this.nursery,
//     wantToHaveChildren: wantToHaveChildren ?? this.wantToHaveChildren,
//     thingsIAcceptOrWant: thingsIAcceptOrWant ?? this.thingsIAcceptOrWant,
//     typeOfWeddingParty: typeOfWeddingParty ?? this.typeOfWeddingParty,
//     cityId: cityId ?? this.cityId,
//     educationalQualification: educationalQualification ?? this.educationalQualification,
//     pray: pray ?? this.pray,
//     diseasesIfExists: diseasesIfExists ?? this.diseasesIfExists,
//     inChatYouPrefer: inChatYouPrefer ?? this.inChatYouPrefer,
//     smoke: smoke ?? this.smoke,
//     belongToATribe: belongToATribe ?? this.belongToATribe,
//     skinColor: skinColor ?? this.skinColor,
//   );
//
//   @override
//   Map<String, dynamic> toJson() {
//     return super.toJson()..addAll({
//       'religious_commitment': degreeOfCommitment
//     });
//   }
// }
//
// class MaleParentCompleteProfileBody extends SharedFormFieldModel{
//   final String name;
//   final String phone;
//   final String identifyNumber;
//   final String age;
//   final File? image;
//   final String degreeOfCommitment;
//
//   MaleParentCompleteProfileBody({
//     required this.name,
//     required this.phone,
//     required this.identifyNumber,
//     required this.age,
//     required this.image,
//     required this.degreeOfCommitment,
//
//     required super.dowry,
//     required super.nickName,
//     required super.maritalStatus,
//     required super.tall,
//     required super.weight,
//     required super.currentJob,
//     required super.quickBrief,
//     required super.childrenExists,
//     required super.childrenNumber,
//     required super.nursery,
//     required super.wantToHaveChildren,
//     required super.thingsIAcceptOrWant,
//     required super.typeOfWeddingParty,
//     required super.cityId,
//     required super.educationalQualification,
//     required super.pray,
//     required super.diseasesIfExists,
//     required super.inChatYouPrefer,
//     required super.smoke,
//     required super.belongToATribe,
//     required super.skinColor
//   });
//
//   factory MaleParentCompleteProfileBody.initial() => MaleParentCompleteProfileBody(degreeOfCommitment: '', dowry: Dowry(from: 'from', to: 'to'), nickName: 'nickName', maritalStatus: 'maritalStatus', tall: 'tall', weight: 'weight', currentJob: 'currentJob', quickBrief: 'quickBrief', childrenExists: null, childrenNumber: 'childrenNumber', nursery: EnumsData.childCustody.data.first.value, wantToHaveChildren: null, thingsIAcceptOrWant: 'thingsIAcceptOrWant', typeOfWeddingParty: 'typeOfWeddingParty', cityId: 0, educationalQualification: 'educationalQualification', pray: null, diseasesIfExists: 'diseasesIfExists', inChatYouPrefer: Languages.arabic.languageCode, smoke: null, belongToATribe: null, skinColor: 'skinColor', name: '', phone: '', identifyNumber: '', age: '', image: null);
//
//   @override
//   MaleParentCompleteProfileBody copyWith({
//     String? degreeOfCommitment,
//     String? name,
//     String? phone,
//     String? identifyNumber,
//     String? age,
//     File? image,
//     Dowry? dowry,
//     String? nickName, String? maritalStatus, String? tall, String? weight, String? currentJob, String? quickBrief, bool? childrenExists, String? childrenNumber, String? nursery, bool? wantToHaveChildren, String? thingsIAcceptOrWant, String? typeOfWeddingParty, int? cityId, String? educationalQualification, bool? pray, String? diseasesIfExists, String? inChatYouPrefer, bool? smoke, bool? belongToATribe, String? skinColor}) {
//     return MaleParentCompleteProfileBody(
//       degreeOfCommitment: degreeOfCommitment ?? this.degreeOfCommitment,
//       name: name ?? this.name,
//       phone: phone ?? this.phone,
//       identifyNumber: identifyNumber ?? this.identifyNumber,
//       age: age ?? this.age,
//       image: image ?? this.image,
//
//       dowry: dowry?? this.dowry,
//       nickName: nickName ?? this.nickName,
//       maritalStatus: maritalStatus ?? this.maritalStatus,
//       tall: tall ?? this.tall,
//       weight: weight ?? this.weight,
//       currentJob: currentJob ?? this.currentJob,
//       quickBrief: quickBrief ?? this.quickBrief,
//       childrenExists: childrenExists ?? this.childrenExists,
//       childrenNumber: childrenNumber ?? this.childrenNumber,
//       nursery: nursery ?? this.nursery,
//       wantToHaveChildren: wantToHaveChildren ?? this.wantToHaveChildren,
//       thingsIAcceptOrWant: thingsIAcceptOrWant ?? this.thingsIAcceptOrWant,
//       typeOfWeddingParty: typeOfWeddingParty ?? this.typeOfWeddingParty,
//       educationalQualification: educationalQualification ?? this.educationalQualification,
//       pray: pray ?? this.pray,
//       diseasesIfExists: diseasesIfExists ?? this.diseasesIfExists,
//       inChatYouPrefer: inChatYouPrefer ?? this.inChatYouPrefer,
//       smoke: smoke ?? this.smoke,
//       belongToATribe: belongToATribe ?? this.belongToATribe,
//       skinColor: skinColor ?? this.skinColor,
//       cityId: cityId?? this.cityId,
//     );
//   }
//
//   @override
//   Map<String, dynamic> toJson() {
//     return super.toJson()..addAll({
//       'name' : name,
//       'gender' : 'male',
//       'age' : age,
//       'phone' : phone,
//       'identity_number' : identifyNumber,
//       'avatar' : image,
//       'religious_commitment': degreeOfCommitment
//     });
//   }
//
// }