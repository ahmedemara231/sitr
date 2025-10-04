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

  SignUpBody merge(SignUpBody other) => copyWith(
    image: other.image,
    name: other.name,
    phone: other.phone,
    identityNumber: other.identityNumber,
    gender: other.gender,
    code: other.code,
  );

  Map<String, dynamic> toJson() => AuthBodyStaticData().toJson()..addAll({
    'name' : name,
    'phone' : phone,
    'code' : code,
    'identity_number' : identityNumber,
    'avatar' : image,
    'gender' : gender,
  });

  SignUpBody copyWith({
    File? image,
    String? name,
    String? phone,
    String? identityNumber,
    String? gender,
    String? code,
  }) => SignUpBody(
    image: image ?? this.image,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    identityNumber: identityNumber ?? this.identityNumber,
    gender: gender ?? this.gender,
    code: code ?? this.code,
  );

  factory SignUpBody.initial() => SignUpBody(name: 'name', phone: 'phone', identityNumber: 'identityNumber', gender: 'gender', code: 'code', image: null);
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


  @override
  MaleAndFemaleSignUp merge(SignUpBody other) {
    return copyWith(
      image: other.image,
      name: other.name,
      phone: other.phone,
      identityNumber: other.identityNumber,
      gender: other.gender,
      code: other.code,
      age: (other as MaleAndFemaleSignUp).age
    );
  }

  @override
  MaleAndFemaleSignUp copyWith({
    String? age,
    File? image,
    String? name,
    String? phone,
    String? identityNumber,
    String? gender,
    String? code
  }) {
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
  final int kinship;
  final String childrenNumber;
  // final String childGender;
  ParentSignUp({
    required this.email,
    required this.kinship,
    required this.childrenNumber,
    // required this.childGender,
    required super.name,
    required super.phone,
    required super.identityNumber,
    required super.image,
    required super.gender,
    required super.code
  });

  @override
  ParentSignUp copyWith({
    String? email,
    int? kinship,
    String? childrenNumber,
    // String? childGender,
    File? image,
    String? name,
    String? phone,
    String? identityNumber,
    String? gender,
    String? code
  }) {
    return ParentSignUp(
      image: image ?? this.image,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      identityNumber: identityNumber ?? this.identityNumber,
      gender: gender ?? this.gender,
      code: code ?? this.code,
      email: email ?? this.email,
      kinship: kinship?? this.kinship,
      childrenNumber: childrenNumber?? this.childrenNumber,
      // childGender: childGender?? this.childGender,
    );
  }

  factory ParentSignUp.initial() => ParentSignUp(
      email: '',
      kinship: 0,
      childrenNumber: '',
      // childGender: '',
      name: '',
      phone: '',
      identityNumber: '',
      image: null,
      gender: '',
      code: ''
  );

  @override
  ParentSignUp merge(SignUpBody other) {
    return copyWith(
      image: other.image,
      name: other.name,
      phone: other.phone,
      identityNumber: other.identityNumber,
      gender: other.gender,
      code: other.code,
      email: (other as ParentSignUp).email,
      kinship: other.kinship,
      childrenNumber: other.childrenNumber,
      // childGender: other.childGender,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()..addAll({
      'email' : email,
      'num_of_children' : childrenNumber,
      'relation_id' : kinship,
      'type' : 'parent'
    });
  }
}