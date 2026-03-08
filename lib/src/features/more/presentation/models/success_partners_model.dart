import 'package:equatable/equatable.dart';

class SuccessPartnersModel extends Equatable {
  const SuccessPartnersModel({
    required this.id,
    required this.image,
  });

  final int? id;
  final String? image;

  factory SuccessPartnersModel.fromJson(Map<String, dynamic> json){
    return SuccessPartnersModel(
      id: json["id"],
      image: json["image"],
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'image': image};

  @override
  List<Object?> get props => [
    id, image, ];
}

