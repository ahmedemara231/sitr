import 'package:equatable/equatable.dart';

// ============ Main Response Model ============

class HomeDataModel extends Equatable {
  final List<BannerModel> banners;
  final List<MarriageConsultantModel> marriageConsultants;
  final OpportunitiesModel opportunities;

  const HomeDataModel({
    required this.banners,
    required this.marriageConsultants,
    required this.opportunities,
  });

  const HomeDataModel.initial()
      : banners = const [],
        marriageConsultants = const [],
        opportunities = const OpportunitiesModel.initial();

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      banners: (json['banners'] as List<dynamic>?)
              ?.map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      marriageConsultants: (json['marriage_consultants'] as List<dynamic>?)
              ?.map((e) => MarriageConsultantModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      opportunities: OpportunitiesModel.fromJson(json['opportunities'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'banners': banners.map((e) => e.toJson()).toList(),
      'marriage_consultants': marriageConsultants.map((e) => e.toJson()).toList(),
      'opportunities': opportunities.toJson(),
    };
  }

  HomeDataModel copyWith({
    List<BannerModel>? banners,
    List<MarriageConsultantModel>? marriageConsultants,
    OpportunitiesModel? opportunities,
  }) {
    return HomeDataModel(
      banners: banners ?? this.banners,
      marriageConsultants: marriageConsultants ?? this.marriageConsultants,
      opportunities: opportunities ?? this.opportunities,
    );
  }

  @override
  List<Object?> get props => [banners, marriageConsultants, opportunities];
}

// ============ Banner Model ============

class BannerModel extends Equatable {
  final int id;
  final String image;

  const BannerModel({
    required this.id,
    required this.image,
  });

  const BannerModel.initial()
      : id = 0,
        image = '';

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
    };
  }

  BannerModel copyWith({
    int? id,
    String? image,
  }) {
    return BannerModel(
      id: id ?? this.id,
      image: image ?? this.image,
    );
  }

  @override
  List<Object?> get props => [id, image];
}

// ============ Marriage Consultant Model ============

class MarriageConsultantModel extends Equatable {
  final int id;
  final String name;
  final String description;
  final String image;
  final String phone;
  final String countryCode;
  final String fullPhone;

  const MarriageConsultantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.phone,
    required this.countryCode,
    required this.fullPhone,
  });

  const MarriageConsultantModel.initial()
      : id = 0,
        name = '',
        description = '',
        image = '',
        phone = '',
        countryCode = '',
        fullPhone = '';

  factory MarriageConsultantModel.fromJson(Map<String, dynamic> json) {
    return MarriageConsultantModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      phone: json['phone'] ?? '',
      countryCode: json['country_code'] ?? '',
      fullPhone: json['full_phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'phone': phone,
      'country_code': countryCode,
      'full_phone': fullPhone,
    };
  }

  MarriageConsultantModel copyWith({
    int? id,
    String? name,
    String? description,
    String? image,
    String? phone,
    String? countryCode,
    String? fullPhone,
  }) {
    return MarriageConsultantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
      fullPhone: fullPhone ?? this.fullPhone,
    );
  }

  @override
  List<Object?> get props => [id, name, description, image, phone, countryCode, fullPhone];
}

// ============ Opportunities Model ============

class OpportunitiesModel extends Equatable {
  final List<ParentUserModel> parent;
  final List<MaleUserModel> male;

  const OpportunitiesModel({
    required this.parent,
    required this.male,
  });

  const OpportunitiesModel.initial()
      : parent = const [],
        male = const [];

  factory OpportunitiesModel.fromJson(Map<String, dynamic> json) {
    return OpportunitiesModel(
      parent: (json['parent'] as List<dynamic>?)
              ?.map((e) => ParentUserModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      male: (json['male'] as List<dynamic>?)
              ?.map((e) => MaleUserModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parent': parent.map((e) => e.toJson()).toList(),
      'male': male.map((e) => e.toJson()).toList(),
    };
  }

  OpportunitiesModel copyWith({
    List<ParentUserModel>? parent,
    List<MaleUserModel>? male,
  }) {
    return OpportunitiesModel(
      parent: parent ?? this.parent,
      male: male ?? this.male,
    );
  }

  @override
  List<Object?> get props => [parent, male];
}

// ============ Parent User Model ============

class ParentUserModel extends Equatable {
  final int id;
  final String name;
  final String avatar;
  final KeyValueModel type;
  final KeyValueModel gender;
  final RelationModel relation;
  final int numOfChildren;

  const ParentUserModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.type,
    required this.gender,
    required this.relation,
    required this.numOfChildren,
  });

  const ParentUserModel.initial()
      : id = 0,
        name = '',
        avatar = '',
        type = const KeyValueModel.initial(),
        gender = const KeyValueModel.initial(),
        relation = const RelationModel.initial(),
        numOfChildren = 0;

  factory ParentUserModel.fromJson(Map<String, dynamic> json) {
    return ParentUserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      type: KeyValueModel.fromJson(json['type'] ?? {}),
      gender: KeyValueModel.fromJson(json['gender'] ?? {}),
      relation: RelationModel.fromJson(json['relation'] ?? {}),
      numOfChildren: json['num_of_children'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'type': type.toJson(),
      'gender': gender.toJson(),
      'relation': relation.toJson(),
      'num_of_children': numOfChildren,
    };
  }

  ParentUserModel copyWith({
    int? id,
    String? name,
    String? avatar,
    KeyValueModel? type,
    KeyValueModel? gender,
    RelationModel? relation,
    int? numOfChildren,
  }) {
    return ParentUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      type: type ?? this.type,
      gender: gender ?? this.gender,
      relation: relation ?? this.relation,
      numOfChildren: numOfChildren ?? this.numOfChildren,
    );
  }

  @override
  List<Object?> get props => [id, name, avatar, type, gender, relation, numOfChildren];
}

// ============ Male User Model ============

class MaleUserModel extends Equatable {
  final int id;
  final String name;
  final String avatar;
  final int age;
  final KeyValueModel type;
  final KeyValueModel gender;
  final String city;
  final int height;
  final int weight;

  const MaleUserModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.age,
    required this.type,
    required this.gender,
    required this.city,
    required this.height,
    required this.weight,
  });

  const MaleUserModel.initial()
      : id = 0,
        name = '',
        avatar = '',
        age = 0,
        type = const KeyValueModel.initial(),
        gender = const KeyValueModel.initial(),
        city = '',
        height = 0,
        weight = 0;

  factory MaleUserModel.fromJson(Map<String, dynamic> json) {
    return MaleUserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      age: json['age'] ?? 0,
      type: KeyValueModel.fromJson(json['type'] ?? {}),
      gender: KeyValueModel.fromJson(json['gender'] ?? {}),
      city: json['city'] ?? '',
      height: json['height'] ?? 0,
      weight: json['weight'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'age': age,
      'type': type.toJson(),
      'gender': gender.toJson(),
      'city': city,
      'height': height,
      'weight': weight,
    };
  }

  MaleUserModel copyWith({
    int? id,
    String? name,
    String? avatar,
    int? age,
    KeyValueModel? type,
    KeyValueModel? gender,
    String? city,
    int? height,
    int? weight,
  }) {
    return MaleUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      age: age ?? this.age,
      type: type ?? this.type,
      gender: gender ?? this.gender,
      city: city ?? this.city,
      height: height ?? this.height,
      weight: weight ?? this.weight,
    );
  }

  @override
  List<Object?> get props => [id, name, avatar, age, type, gender, city, height, weight];
}

// ============ Key Value Model (Shared) ============

class KeyValueModel extends Equatable {
  final String value;
  final String title;

  const KeyValueModel({
    required this.value,
    required this.title,
  });

  const KeyValueModel.initial()
      : value = '',
        title = '';

  factory KeyValueModel.fromJson(Map<String, dynamic> json) {
    return KeyValueModel(
      value: json['value'] ?? '',
      title: json['title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'title': title,
    };
  }

  KeyValueModel copyWith({
    String? value,
    String? title,
  }) {
    return KeyValueModel(
      value: value ?? this.value,
      title: title ?? this.title,
    );
  }

  @override
  List<Object?> get props => [value, title];
}

// ============ Relation Model ============

class RelationModel extends Equatable {
  final int id;
  final String name;

  const RelationModel({
    required this.id,
    required this.name,
  });

  const RelationModel.initial()
      : id = 0,
        name = '';

  factory RelationModel.fromJson(Map<String, dynamic> json) {
    return RelationModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  RelationModel copyWith({
    int? id,
    String? name,
  }) {
    return RelationModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [id, name];
}
