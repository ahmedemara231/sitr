import 'package:equatable/equatable.dart';

class BlockUserModel extends Equatable {
  const BlockUserModel({
    required this.id,
    required this.name,
    required this.avatar,
  });

  final int? id;
  final String? name;
  final String? avatar;

  factory BlockUserModel.fromJson(Map<String, dynamic> json){
    return BlockUserModel(
      id: json["id"],
      name: json["name"],
      avatar: json["avatar"],
    );
  }

  @override
  List<Object?> get props => [
    id, name, avatar, ];
}
