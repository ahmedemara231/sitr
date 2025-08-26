import '../../helpers/gender_enum.dart';

class UserModel {
  final Gender gender;
  final String id;
  final String image;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String city;
  final int userType;
  final bool allowNotify;
  final String? token;

  UserModel({
    required this.gender,
    required this.id,
    required this.image,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.city,
    required this.userType,
    required this.allowNotify,
    required this.token,
  });

  factory UserModel.initial() => UserModel(
    gender: Gender.male,
        id: '',
        image: '',
        fullName: '',
        phoneNumber: '',
        email: '',
        city: '',
        userType: 0,
        allowNotify: false,
        token: '',
      );

  UserModel copyWith({
    Gender? gender,
    String? id,
    String? image,
    String? fullName,
    String? phoneNumber,
    String? email,
    String? city,
    int? userType,
    bool? allowNotify,
    String? token,
  }) {
    return UserModel(
      gender: gender ?? this.gender,
      id: id ?? this.id,
      image: image ?? this.image,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      city: city ?? this.city,
      userType: userType ?? this.userType,
      allowNotify: allowNotify ?? this.allowNotify,
      token: token ?? this.token,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    gender: json['gender'],
        id: json['id'],
        image: json['image'],
        fullName: json['fullName'],
        phoneNumber: json['phoneNumber'],
        email: json['email'],
        city: json['city'],
        userType: json['userType'],
        allowNotify: json['allowNotify'],
        token: json['token'],
      );

  Map<String, dynamic> toJson() => {
        'gender': gender.name,
        'id': id,
        'image': image,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'email': email,
        'city': city,
        'userType': userType,
        'allowNotify': allowNotify,
      };
}
