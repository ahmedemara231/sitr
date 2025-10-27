import 'dart:io';

class ChatInputsModel{
  final String? text;
  final File? image;

  ChatInputsModel({this.text, this.image});

  ChatInputsModel copyWith({
    String? text,
    File? image,
  }) => ChatInputsModel(
    text: text ?? this.text,
    image: image ?? this.image,
  );
}