import 'dart:io';

import 'auth_body_static_data.dart';

class SignUpBody{
  final String name;
  final String phone;
  final String age;
  final String identityNumber;
  final File? image;
  final String gender;

  SignUpBody({
    required this.name,
    required this.phone,
    required this.age,
    required this.identityNumber,
    required this.image,
    required this.gender,
  });

  Map<String, dynamic> toJson() => AuthBodyStaticData().toJson()..addAll({
    'name' : name,
    'phone' : phone,
    'age' : age,
    'identity_number' : identityNumber,
    'avatar' : image,
    'gender' : gender,
    // 'type' : ''
  });
}