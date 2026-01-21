import '../../../../core/extensions/object.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/shared/models/title_value_shape.dart';
import '../../../../core/shared/models/user_models/user_model.dart';

class HomeModel {
  HomeModel({
      this.banners, 
      this.marriageConsultants, 
      this.opportunities
  });

  HomeModel.fromJson(dynamic json) {
    if (json['banners'] != null) {
      banners = [];
      json['banners'].forEach((v) {
        banners?.add(Banners.fromJson(v));
      });
    }
    if (json['marriage_consultants'] != null) {
      marriageConsultants = [];
      json['marriage_consultants'].forEach((v) {
        marriageConsultants?.add(MarriageConsultants.fromJson(v));
      });
    }
    opportunities = (json['opportunities'] as Object).isNotNull?
    Opportunities.fromJson(json['opportunities']) : null;
  }
  List<Banners>? banners;
  List<MarriageConsultants>? marriageConsultants;
  Opportunities? opportunities;
HomeModel copyWith({  List<Banners>? banners,
  List<MarriageConsultants>? marriageConsultants,
  Opportunities? opportunities,
}) => HomeModel(  banners: banners ?? this.banners,
  marriageConsultants: marriageConsultants ?? this.marriageConsultants,
  opportunities: opportunities ?? this.opportunities,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (banners != null) {
      map['banners'] = banners?.map((v) => v.toJson()).toList();
    }
    if (marriageConsultants != null) {
      map['marriage_consultants'] = marriageConsultants?.map((v) => v.toJson()).toList();
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
      this.female
  });

  // bool get isEmptyData => (parent == null && male == null && female == null) ||
  //     (parent!.isEmpty && male!.isEmpty && female!.isEmpty);


  Opportunities.fromJson(dynamic json) {
    if (json['parent'] != null) {
      parent = [];
      json['parent'].forEach((v) {
        parent?.add(Parent.fromJson(v));
      });
    }
    if (json['male'] != null) {
      male = [];
      json['male'].forEach((v) {
        male?.add(Opportunity.fromJson(v));
      });
    }
    if (json['female'] != null) {
      female = [];
      json['female'].forEach((v) {
        female?.add(Opportunity.fromJson(v));
      });
    }
  }
  List<Parent>? parent;
  List<Opportunity>? male;
  List<Opportunity>? female;
Opportunities copyWith({
  List<Parent>? parent,
  List<Opportunity>? male,
  List<Opportunity>? female,
}) => Opportunities(  parent: parent ?? this.parent,
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

class OpportunityModel{
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

  factory OpportunityModel.fromJson(Map<String, dynamic> json) {
    if(TitleValueShape.fromJson(json['type']).value.toUserType().isParent){
      return Parent.fromJson(json);

    }else{
      return Opportunity.fromJson(json);
    }
  }
}
class Opportunity extends OpportunityModel{

  TitleValueShape? skin;
  TitleValueShape? hijab;
  int? age;
  String? city;
  num? height;
  num? weight;
  TitleValueShape? martialStatus;
  String? nickName;

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
      martialStatus: (json['marital_status'] as Object?).isNotNull?
      TitleValueShape.fromJson(json['marital_status']) :
      TitleValueShape.initial(),
      nickName: json['nick_name'],
      hijab: json['hijab'] != null ? TitleValueShape.fromJson(json['hijab']) : null,
      skin: json['skin_color'] != null ? TitleValueShape.fromJson(json['skin_color']) : null,
    );
  }

Opportunity copyWith({  int? id,
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
}) => Opportunity(  id: id ?? this.id,
  name: name ?? this.name,
  avatar: avatar ?? this.avatar,
  age: age ?? this.age,
  martialStatus: martialStatus??this.martialStatus,
  nickName: nickName??this.nickName,
  type: type ?? this.type,
  gender: gender ?? this.gender,
  city: city ?? this.city,
  height: height ?? this.height,
  weight: weight ?? this.weight,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['avatar'] = avatar;
    map['age'] = age;
    map['skin_color'] = skin?.toJson();
    map['hijab'] = hijab?.toJson();
    map['martial_status'] = martialStatus;
    map['nick_name'] = nickName;
    if (type != null) {
      map['type'] = type?.toJson();
    }
    if (gender != null) {
      map['gender'] = gender?.toJson();
    }
    map['city'] = city;
    map['height'] = height;
    map['weight'] = weight;
    return map;
  }

}

class Parent extends OpportunityModel{
  Parent({
      super.id,
      super.name,
      super.avatar,
      super.type,
      super.gender,
      this.relation,
      this.numOfChildren,
  });

  Parent.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
    type = json['type'] != null ? TitleValueShape.fromJson(json['type']) : null;
    gender = json['gender'] != null ? GenderValueShape.fromJson(json['gender']) : null;
    relation = json['relation'] != null ? Relation.fromJson(json['relation']) : null;
    numOfChildren = json['num_of_children'];
  }

  Relation? relation;
  int? numOfChildren;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['avatar'] = avatar;
    if (type != null) {
      map['type'] = type?.toJson();
    }
    if (gender != null) {
      map['gender'] = gender?.toJson();
    }
    if (relation != null) {
      map['relation'] = relation?.toJson();
    }
    map['num_of_children'] = numOfChildren;
    return map;
  }

}

class Relation {
  Relation({
      this.id, 
      this.name,});

  Relation.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  int? id;
  String? name;
Relation copyWith({  int? id,
  String? name,
}) => Relation(  id: id ?? this.id,
  name: name ?? this.name,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
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

  MarriageConsultants.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    phone = json['phone'];
    countryCode = json['country_code'];
    fullPhone = json['full_phone'];
  }
  int? id;
  String? name;
  String? description;
  String? image;
  String? phone;
  String? countryCode;
  String? fullPhone;
MarriageConsultants copyWith({  int? id,
  String? name,
  String? description,
  String? image,
  String? phone,
  String? countryCode,
  String? fullPhone,
}) => MarriageConsultants(  id: id ?? this.id,
  name: name ?? this.name,
  description: description ?? this.description,
  image: image ?? this.image,
  phone: phone ?? this.phone,
  countryCode: countryCode ?? this.countryCode,
  fullPhone: fullPhone ?? this.fullPhone,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['image'] = image;
    map['phone'] = phone;
    map['country_code'] = countryCode;
    map['full_phone'] = fullPhone;
    return map;
  }

}

class Banners {
  Banners({
      this.id, 
      this.image,});

  Banners.fromJson(dynamic json) {
    id = json['id'];
    image = json['image'];
  }
  int? id;
  String? image;
Banners copyWith({  int? id,
  String? image,
}) => Banners(  id: id ?? this.id,
  image: image ?? this.image,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['image'] = image;
    return map;
  }

}