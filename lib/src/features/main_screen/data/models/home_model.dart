import '../../../../core/extensions/object.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/shared/models/title_value_shape.dart';
import '../../../../core/shared/models/user_models/user_model.dart';

class HomeModel {
  HomeModel({
    this.banners,
    this.marriageConsultants,
    this.opportunities,
  });

  factory HomeModel.fromJson(dynamic json) {
    return HomeModel(
      banners: json['banners'] != null
          ? List<Banners>.from(
          json['banners'].map((v) => Banners.fromJson(v)))
          : null,
      marriageConsultants: json['marriage_consultants'] != null
          ? List<MarriageConsultants>.from(
          json['marriage_consultants'].map((v) => MarriageConsultants.fromJson(v)))
          : null,
      opportunities: (json['opportunities'] as Object?).isNotNull
          ? Opportunities.fromJson(json['opportunities'])
          : null,
    );
  }

  List<Banners>? banners;
  List<MarriageConsultants>? marriageConsultants;
  Opportunities? opportunities;

  HomeModel copyWith({
    List<Banners>? banners,
    List<MarriageConsultants>? marriageConsultants,
    Opportunities? opportunities,
  }) =>
      HomeModel(
        banners: banners ?? this.banners,
        marriageConsultants: marriageConsultants ?? this.marriageConsultants,
        opportunities: opportunities ?? this.opportunities,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (banners != null) {
      map['banners'] = banners?.map((v) => v.toJson()).toList();
    }
    if (marriageConsultants != null) {
      map['marriage_consultants'] =
          marriageConsultants?.map((v) => v.toJson()).toList();
    }
    if (opportunities != null) {
      map['opportunities'] = opportunities?.toJson();
    }
    return map;
  }
}

class Opportunities {
  Opportunities({
    this.parent,
    this.male,
    this.female,
  });

  factory Opportunities.fromJson(dynamic json) {
    return Opportunities(
      parent: json['parent'] != null
          ? List<Parent>.from(json['parent'].map((v) => Parent.fromJson(v)))
          : null,
      male: json['male'] != null
          ? List<Opportunity>.from(json['male'].map((v) => Opportunity.fromJson(v)))
          : null,
      female: json['female'] != null
          ? List<Opportunity>.from(json['female'].map((v) => Opportunity.fromJson(v)))
          : null,
    );
  }

  List<Parent>? parent;
  List<Opportunity>? male;
  List<Opportunity>? female;

  Opportunities copyWith({
    List<Parent>? parent,
    List<Opportunity>? male,
    List<Opportunity>? female,
  }) =>
      Opportunities(
        parent: parent ?? this.parent,
        male: male ?? this.male,
        female: female ?? this.female,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (parent != null) {
      map['parent'] = parent?.map((v) => v.toJson()).toList();
    }
    if (male != null) {
      map['male'] = male?.map((v) => v.toJson()).toList();
    }
    if (female != null) {
      map['female'] = female?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class OpportunityModel {
  int? id;
  String? name;
  String? avatar;
  TitleValueShape? type;
  GenderValueShape? gender;

  OpportunityModel({
    this.id,
    this.name,
    this.avatar,
    this.type,
    this.gender,
  });

  Map<String, dynamic> toJson() => {};
  factory OpportunityModel.fromJson(Map<String, dynamic> json) {
    try {
      if (json['type'] != null) {
        final typeValue = TitleValueShape.fromJson(json['type']);
        if (typeValue.value.toUserType().isParent) {
          return Parent.fromJson(json);
        }
      }
      return Opportunity.fromJson(json);
    } catch (e) {
      return Opportunity.fromJson(json);
    }
  }
}

class Opportunity extends OpportunityModel {
  TitleValueShape? skin;
  TitleValueShape? hijab;
  int? age;
  String? city;
  num? height;
  num? weight;
  TitleValueShape? martialStatus;
  String? nickName;
  bool isPromoted;

  Opportunity({
    super.id,
    super.name,
    super.avatar,
    super.type,
    super.gender,
    this.martialStatus,
    this.nickName,
    this.age,
    this.city,
    this.height,
    this.weight,
    this.hijab,
    this.skin,
    this.isPromoted = false,
  });

  factory Opportunity.fromJson(dynamic json) {
    return Opportunity(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      age: json['age'],
      type: json['type'] != null ? TitleValueShape.fromJson(json['type']) : null,
      gender: json['gender'] != null ? GenderValueShape.fromJson(json['gender']) : null,
      city: json['city'],
      height: json['height'],
      weight: json['weight'],
      martialStatus: (json['marital_status'] as Object?).isNotNull
          ? TitleValueShape.fromJson(json['marital_status'])
          : TitleValueShape.initial(),
      nickName: json['nick_name'],
      hijab: json['hijab'] != null ? TitleValueShape.fromJson(json['hijab']) : null,
      skin: json['skin_color'] != null ? TitleValueShape.fromJson(json['skin_color']) : null,
      isPromoted: json['is_promoted'] ?? false,
    );
  }

  Opportunity copyWith({
    int? id,
    String? name,
    String? avatar,
    int? age,
    TitleValueShape? type,
    GenderValueShape? gender,
    String? city,
    double? height,
    double? weight,
    TitleValueShape? martialStatus,
    String? nickName,
    TitleValueShape? hijab,
    TitleValueShape? skin,
    bool? isPromoted,
  }) =>
      Opportunity(
        id: id ?? this.id,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        age: age ?? this.age,
        martialStatus: martialStatus ?? this.martialStatus,
        nickName: nickName ?? this.nickName,
        type: type ?? this.type,
        gender: gender ?? this.gender,
        city: city ?? this.city,
        height: height ?? this.height,
        weight: weight ?? this.weight,
        hijab: hijab ?? this.hijab,
        skin: skin ?? this.skin,
        isPromoted: isPromoted ?? this.isPromoted,
      );

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (id != null) map['id'] = id;
    if (name != null) map['name'] = name;
    if (avatar != null) map['avatar'] = avatar;
    if (age != null) map['age'] = age;
    if (skin != null) map['skin_color'] = skin!.toJson();
    if (hijab != null) map['hijab'] = hijab!.toJson();
    if (martialStatus != null) map['marital_status'] = martialStatus!.toJson();
    if (nickName != null) map['nick_name'] = nickName;
    if (type != null) map['type'] = type!.toJson();
    if (gender != null) map['gender'] = gender!.toJson();
    if (city != null) map['city'] = city;
    if (height != null) map['height'] = height;
    if (weight != null) map['weight'] = weight;
    map['is_promoted'] = isPromoted;
    return map;
  }
}

class Parent extends OpportunityModel {
  Relation? relation;
  int? numOfChildren;
  bool isPromoted;

  Parent({
    super.id,
    super.name,
    super.avatar,
    super.type,
    super.gender,
    this.relation,
    this.numOfChildren,
    this.isPromoted = false,
  });

  factory Parent.fromJson(dynamic json) {
    return Parent(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      type: json['type'] != null ? TitleValueShape.fromJson(json['type']) : null,
      gender: json['gender'] != null ? GenderValueShape.fromJson(json['gender']) : null,
      relation: json['relation'] != null ? Relation.fromJson(json['relation']) : null,
      numOfChildren: json['num_of_children'],
      isPromoted: json['is_promoted'] ?? false,
    );
  }

  Parent copyWith({
    int? id,
    String? name,
    String? avatar,
    TitleValueShape? type,
    GenderValueShape? gender,
    Relation? relation,
    int? numOfChildren,
    bool? isPromoted,
  }) =>
      Parent(
        id: id ?? this.id,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        type: type ?? this.type,
        gender: gender ?? this.gender,
        relation: relation ?? this.relation,
        numOfChildren: numOfChildren ?? this.numOfChildren,
        isPromoted: isPromoted ?? this.isPromoted,
      );

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (id != null) map['id'] = id;
    if (name != null) map['name'] = name;
    if (avatar != null) map['avatar'] = avatar;
    if (type != null) map['type'] = type!.toJson();
    if (gender != null) map['gender'] = gender!.toJson();
    if (relation != null) map['relation'] = relation!.toJson();
    if (numOfChildren != null) map['num_of_children'] = numOfChildren;
    map['is_promoted'] = isPromoted;
    return map;
  }
}

class Relation {
  Relation({
    this.id,
    this.name,
  });

  factory Relation.fromJson(dynamic json) {
    return Relation(
      id: json['id'],
      name: json['name'],
    );
  }

  int? id;
  String? name;

  Relation copyWith({
    int? id,
    String? name,
  }) =>
      Relation(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (id != null) map['id'] = id;
    if (name != null) map['name'] = name;
    return map;
  }
}

class MarriageConsultants {
  MarriageConsultants({
    this.id,
    this.name,
    this.description,
    this.image,
    this.phone,
    this.countryCode,
    this.fullPhone,
  });

  factory MarriageConsultants.fromJson(dynamic json) {
    return MarriageConsultants(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      phone: json['phone'],
      countryCode: json['country_code'],
      fullPhone: json['full_phone'],
    );
  }

  int? id;
  String? name;
  String? description;
  String? image;
  String? phone;
  String? countryCode;
  String? fullPhone;

  MarriageConsultants copyWith({
    int? id,
    String? name,
    String? description,
    String? image,
    String? phone,
    String? countryCode,
    String? fullPhone,
  }) =>
      MarriageConsultants(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        image: image ?? this.image,
        phone: phone ?? this.phone,
        countryCode: countryCode ?? this.countryCode,
        fullPhone: fullPhone ?? this.fullPhone,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (id != null) map['id'] = id;
    if (name != null) map['name'] = name;
    if (description != null) map['description'] = description;
    if (image != null) map['image'] = image;
    if (phone != null) map['phone'] = phone;
    if (countryCode != null) map['country_code'] = countryCode;
    if (fullPhone != null) map['full_phone'] = fullPhone;
    return map;
  }
}

class Banners {
  Banners({
    this.id,
    this.image,
  });

  factory Banners.fromJson(dynamic json) {
    return Banners(
      id: json['id'],
      image: json['image'],
    );
  }

  int? id;
  String? image;

  Banners copyWith({
    int? id,
    String? image,
  }) =>
      Banners(
        id: id ?? this.id,
        image: image ?? this.image,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (id != null) map['id'] = id;
    if (image != null) map['image'] = image;
    return map;
  }
}
