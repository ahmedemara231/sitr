import 'dart:io';
import '../../../../config/language/languages.dart';
import '../../presentation/data/enums_data.dart';
import '../../presentation/enums/nursery.dart';
import '../dowry.dart';
import '../shared_form_fields_model.dart';

class MaleCompleteProfileBody extends SharedFormFieldModel{
  MaleCompleteProfileBody({
    required super.dowry,
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
    required super.cityId,
    required super.educationalQualification,
    required super.pray,
    required super.diseasesIfExists,
    required super.inChatYouPrefer,
    required super.smoke,
    required super.belongToATribe,
    required super.skinColor
  });

  factory MaleCompleteProfileBody.initial() => MaleCompleteProfileBody(dowry: Dowry(from: 'from', to: 'to'), nickName: 'nickName', maritalStatus: 'maritalStatus', tall: 'tall', weight: 'weight', currentJob: 'currentJob', quickBrief: 'quickBrief', childrenExists: null, childrenNumber: 'childrenNumber', nursery: EnumsData.childCustody.data.first.value, wantToHaveChildren: null, thingsIAcceptOrWant: 'thingsIAcceptOrWant', typeOfWeddingParty: 'typeOfWeddingParty', cityId: 0, educationalQualification: 'educationalQualification', pray: null, diseasesIfExists: 'diseasesIfExists', inChatYouPrefer: Languages.arabic.languageCode, smoke: null, belongToATribe: null, skinColor: 'skinColor');
}

class MaleParentCompleteProfileBody extends SharedFormFieldModel{
  final String name;
  final String phone;
  final String identifyNumber;
  final String age;
  final File? image;

  MaleParentCompleteProfileBody({
    required this.name,
    required this.phone,
    required this.identifyNumber,
    required this.age,
    required this.image,

    required super.dowry,
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
    required super.cityId,
    required super.educationalQualification,
    required super.pray,
    required super.diseasesIfExists,
    required super.inChatYouPrefer,
    required super.smoke,
    required super.belongToATribe,
    required super.skinColor
  });

  factory MaleParentCompleteProfileBody.initial() => MaleParentCompleteProfileBody(dowry: Dowry(from: 'from', to: 'to'), nickName: 'nickName', maritalStatus: 'maritalStatus', tall: 'tall', weight: 'weight', currentJob: 'currentJob', quickBrief: 'quickBrief', childrenExists: null, childrenNumber: 'childrenNumber', nursery: EnumsData.childCustody.data.first.value, wantToHaveChildren: null, thingsIAcceptOrWant: 'thingsIAcceptOrWant', typeOfWeddingParty: 'typeOfWeddingParty', cityId: 0, educationalQualification: 'educationalQualification', pray: null, diseasesIfExists: 'diseasesIfExists', inChatYouPrefer: Languages.arabic.languageCode, smoke: null, belongToATribe: null, skinColor: 'skinColor', name: '', phone: '', identifyNumber: '', age: '', image: null);

  @override
  SharedFormFieldModel copyWith({
    String? name,
    String? phone,
    String? identifyNumber,
    String? age,
    File? image,
    Dowry? dowry,
    String? nickName, String? maritalStatus, String? tall, String? weight, String? currentJob, String? quickBrief, bool? childrenExists, String? childrenNumber, String? nursery, bool? wantToHaveChildren, String? thingsIAcceptOrWant, String? typeOfWeddingParty, int? cityId, String? educationalQualification, bool? pray, String? diseasesIfExists, String? inChatYouPrefer, bool? smoke, bool? belongToATribe, String? skinColor}) {
    return MaleParentCompleteProfileBody(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      identifyNumber: identifyNumber ?? this.identifyNumber,
      age: age ?? this.age,
      image: image ?? this.image,

      dowry: dowry?? this.dowry,
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
      educationalQualification: educationalQualification ?? this.educationalQualification,
      pray: pray ?? this.pray,
      diseasesIfExists: diseasesIfExists ?? this.diseasesIfExists,
      inChatYouPrefer: inChatYouPrefer ?? this.inChatYouPrefer,
      smoke: smoke ?? this.smoke,
      belongToATribe: belongToATribe ?? this.belongToATribe,
      skinColor: skinColor ?? this.skinColor,
      cityId: cityId?? this.cityId,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()..addAll({
      'name' : name,
      'age' : age,
      'phone' : phone,
      'identity_number' : identifyNumber,
      'avatar' : image
    });
  }

}