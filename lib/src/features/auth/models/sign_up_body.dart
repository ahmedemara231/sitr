import 'dart:io';

import 'auth_body_static_data.dart';

class SignUpBody{
  final File? image;
  final String name;
  final String phone;
  final String identityNumber;
  final String gender;
  final String code;

  SignUpBody({
    required this.name,
    required this.phone,
    required this.identityNumber,
    required this.image,
    required this.gender,
    required this.code,
  });

  Map<String, dynamic> toJson() => AuthBodyStaticData().toJson()..addAll({
    'name' : name,
    'phone' : phone,
    'code' : code,
    'identity_number' : identityNumber,
    'avatar' : image,
    'gender' : gender,
  });
}

class MaleAndFemaleSignUp extends SignUpBody{
  final String age;
  MaleAndFemaleSignUp({
    required this.age,
    required super.name,
    required super.phone,
    required super.identityNumber,
    required super.image,
    required super.gender,
    required super.code
  });

  factory MaleAndFemaleSignUp.initial() => MaleAndFemaleSignUp(
    age: '',
    name: '',
    phone: '',
    identityNumber: '',
    image: null,
    gender: '',
    code: ''
  );
  @override
  Map<String, dynamic> toJson() {
    return super.toJson()..addAll({
      'age' : age,
      'type' : 'individual'
    });
  }
}

class ParentSignUp extends SignUpBody{
  final String email;
  final String kinship;
  final String childrenNumber;
  final String childGender;
  ParentSignUp({
    required this.email,
    required this.kinship,
    required this.childrenNumber,
    required this.childGender,
    required super.name,
    required super.phone,
    required super.identityNumber,
    required super.image,
    required super.gender,
    required super.code
  });

  factory ParentSignUp.initial() => ParentSignUp(
      email: '',
      kinship: '',
      childrenNumber: '',
      childGender: '',
      name: '',
      phone: '',
      identityNumber: '',
      image: null,
      gender: '',
      code: ''
  );
  @override
  Map<String, dynamic> toJson() {
    return super.toJson()..addAll({
      'email' : email,
      'children_number' : childrenNumber,
      'kinship' : kinship,
      'type' : 'parent'
    });
  }
}