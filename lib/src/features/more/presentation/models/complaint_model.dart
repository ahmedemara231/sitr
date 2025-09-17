import 'package:equatable/equatable.dart';

class ComplaintModel extends Equatable {
  const ComplaintModel({
    required this.id,
    required this.number,
    required this.status,
    required this.image,
    required this.createdAt,
  });

  final int? id;
  final num? number;
  final Status? status;
  final String? image;
  final String? createdAt;

  factory ComplaintModel.fromJson(Map<String, dynamic> json){
    return ComplaintModel(
      id: json["id"],
      number: json["num"],
      status: json["status"] == null ? null : Status.fromJson(json["status"]),
      image: json["image"],
      createdAt: json["created_at"].toString() ?? "",
    );
  }

  @override
  List<Object?> get props => [
    id, num, status, image, createdAt, ];
}

class Status extends Equatable {
  Status({
    required this.value,
    required this.title,
  });

  final String? value;
  final String? title;

  factory Status.fromJson(Map<String, dynamic> json){
    return Status(
      value: json["value"],
      title: json["title"],
    );
  }

  @override
  List<Object?> get props => [
    value, title, ];
}
