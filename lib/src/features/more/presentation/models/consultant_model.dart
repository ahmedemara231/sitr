import 'package:equatable/equatable.dart';

class ConsultantModel extends Equatable {
  const ConsultantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.phone,
    required this.countryCode,
    required this.fullPhone,
  });

  final int? id;
  final String? name;
  final String? description;
  final String? image;
  final String? phone;
  final String? countryCode;
  final String? fullPhone;

  factory ConsultantModel.fromJson(Map<String, dynamic> json){
    return ConsultantModel(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      image: json["image"],
      phone: json["phone"],
      countryCode: json["country_code"],
      fullPhone: json["full_phone"],
    );
  }

  @override
  List<Object?> get props => [
    id, name, description, image, phone, countryCode, fullPhone, ];
}
