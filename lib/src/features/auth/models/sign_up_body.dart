import 'dart:io';

import '../../../core/helpers/user_type_enum.dart';
import 'auth_body_static_data.dart';

class SignUpBody {
  final File? image;
  final String name;
  final String phone;
  final String identityNumber;
  final String gender;
  final String code;

  const SignUpBody({
    required this.name,
    required this.phone,
    required this.identityNumber,
    required this.image,
    required this.gender,
    required this.code,
  });

  Map<String, dynamic> toJson() => AuthBodyStaticData().toJson()
    ..addAll({
      'name': name,
      'phone': phone,
      'setr_code': code,
      'identity_number': identityNumber,
      'avatar': image,
      'gender': gender,
    });

  SignUpBody copyWith({
    File? image,
    String? name,
    String? phone,
    String? identityNumber,
    String? gender,
    String? code,
  }) =>
      SignUpBody(
        image: image ?? this.image,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        identityNumber: identityNumber ?? this.identityNumber,
        gender: gender ?? this.gender,
        code: code ?? this.code,
      );

  factory SignUpBody.initial() => const SignUpBody(
        name: '',
        phone: '',
        identityNumber: '',
        gender: '',
        code: '',
        image: null,
      );

  factory SignUpBody.fromSelectedGender(UserGender gender) {
    if (gender.isMale || gender.isFemale) {
      return MaleAndFemaleSignUp.initial().copyWith(gender: gender.name);
    }

    return ParentSignUp.initial();
  }
}

class MaleAndFemaleSignUp extends SignUpBody {
  final String age;
  const MaleAndFemaleSignUp(
      {required this.age,
      required super.name,
      required super.phone,
      required super.identityNumber,
      required super.image,
      required super.gender,
      required super.code});

  @override
  MaleAndFemaleSignUp copyWith(
      {String? age,
      File? image,
      String? name,
      String? phone,
      String? identityNumber,
      String? gender,
      String? code}) {
    return MaleAndFemaleSignUp(
      image: image ?? this.image,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      identityNumber: identityNumber ?? this.identityNumber,
      gender: gender ?? this.gender,
      code: code ?? this.code,
      age: age ?? this.age,
    );
  }

  factory MaleAndFemaleSignUp.initial() => const MaleAndFemaleSignUp(
      age: '',
      name: '',
      phone: '',
      identityNumber: '',
      image: null,
      gender: '',
      code: '');

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()..addAll({'age': age, 'type': 'individual'});
  }
}

class ParentSignUp extends SignUpBody {
  final String email;
  final int kinship;
  final String childrenNumber;

  const ParentSignUp(
      {required this.email,
      required this.kinship,
      required this.childrenNumber,
      required super.name,
      required super.phone,
      required super.identityNumber,
      required super.image,
      required super.gender,
      required super.code});

  @override
  ParentSignUp copyWith(
      {String? email,
      int? kinship,
      String? childrenNumber,
      File? image,
      String? name,
      String? phone,
      String? identityNumber,
      String? gender,
      String? code}) {
    return ParentSignUp(
      image: image ?? this.image,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      identityNumber: identityNumber ?? this.identityNumber,
      gender: gender ?? this.gender,
      code: code ?? this.code,
      email: email ?? this.email,
      kinship: kinship ?? this.kinship,
      childrenNumber: childrenNumber ?? this.childrenNumber,
    );
  }

  factory ParentSignUp.initial() => const ParentSignUp(
      email: '',
      kinship: 0,
      childrenNumber: '',
      name: '',
      phone: '',
      identityNumber: '',
      image: null,
      gender: '',
      code: '');

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'email': email,
        'num_of_children': childrenNumber,
        'relation_id': kinship,
        'type': 'parent'
      });
  }
}
