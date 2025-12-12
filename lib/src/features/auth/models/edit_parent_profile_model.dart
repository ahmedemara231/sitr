import 'dart:io';

class EditParentProfileModel {
  final String? name;
  final int? age;
  final String? identityNumber;
  final String? email;
  final int? relationId;
  final int? numOfChildren;
  final File? avatar;

  EditParentProfileModel({
    this.name,
    this.age,
    this.identityNumber,
    this.email,
    this.relationId,
    this.numOfChildren,
    this.avatar,
  });

  factory EditParentProfileModel.initial() {
    return EditParentProfileModel(
      name: null,
      age: null,
      identityNumber: null,
      email: null,
      relationId: null,
      numOfChildren: null,
      avatar: null,
    );
  }

  EditParentProfileModel copyWith({
    String? name,
    int? age,
    String? identityNumber,
    String? email,
    int? relationId,
    int? numOfChildren,
    File? avatar,
  }) {
    return EditParentProfileModel(
      name: name ?? this.name,
      age: age ?? this.age,
      identityNumber: identityNumber ?? this.identityNumber,
      email: email ?? this.email,
      relationId: relationId ?? this.relationId,
      numOfChildren: numOfChildren ?? this.numOfChildren,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'identity_number': identityNumber,
      'email': email,
      'relation_id': relationId,
      'num_of_children': numOfChildren,
      if (avatar != null) 'avatar': avatar,
    };
  }
}
