import 'package:equatable/equatable.dart';

class ComplaintDetailsModel extends Equatable {
  const ComplaintDetailsModel({
    required this.id,
    required this.number,
    required this.complaint,
    required this.images,
    required this.status,
    required this.adminReply,
    required this.createdAt,
  });

  final int? id;
  final num? number;
  final String? complaint;
  final List<Image> images;
  final Status? status;
  final String? adminReply;
  final DateTime? createdAt;

  factory ComplaintDetailsModel.fromJson(Map<String, dynamic> json){
    return ComplaintDetailsModel(
      id: json["id"],
      number: json["num"],
      complaint: json["complaint"],
      images: json["images"] == null ? [] : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
      status: json["status"] == null ? null : Status.fromJson(json["status"]),
      adminReply: json["admin_reply"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
    );
  }

  @override
  List<Object?> get props => [
    id, number, complaint, images, status, adminReply, createdAt, ];
}

class Image extends Equatable {
  const Image({
    required this.id,
    required this.image,
  });

  final int? id;
  final String? image;

  factory Image.fromJson(Map<String, dynamic> json){
    return Image(
      id: json["id"],
      image: json["image"],
    );
  }

  @override
  List<Object?> get props => [
    id, image, ];
}

class Status extends Equatable {
  const Status({
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
