import 'package:equatable/equatable.dart';
import '../../../../config/language/locale_keys.g.dart';

enum ContactSender { user, support }

class ContactMessage extends Equatable {
  final int? id;
  final int parentId;
  final ContactSender sender;
  final String authorName;
  final String message;
  final String time;
  final String? avatarUrl;
  final bool highlighted;

  const ContactMessage({
    this.id,
    required this.parentId,
    required this.sender,
    required this.authorName,
    required this.message,
    required this.time,
    this.avatarUrl,
    this.highlighted = false,
  });

  factory ContactMessage.initial() => const ContactMessage(
        parentId: 0,
        sender: ContactSender.user,
        authorName: '',
        message: '',
        time: '',
      );

  bool get isSupport => sender == ContactSender.support;

  factory ContactMessage.fromParentJson(Map<String, dynamic> json) {
    final int parentId = json['id'] ?? 0;
    return ContactMessage(
      id: parentId,
      parentId: parentId,
      sender: ContactSender.user,
      authorName: json['name'] ?? '',
      message: json['message'] ?? '',
      time: json['created_at'] ?? '',
    );
  }

  factory ContactMessage.fromReplyJson(
    Map<String, dynamic> json, {
    required int parentId,
    required String parentName,
  }) {
    final bool isAdmin = (json['sender_type'] ?? '') == 'admin';
    return ContactMessage(
      id: json['id'],
      parentId: parentId,
      sender: isAdmin ? ContactSender.support : ContactSender.user,
      authorName: isAdmin ? LocaleKeys.supportBadge : parentName,
      message: json['reply'] ?? '',
      time: json['created_at'] ?? '',
    );
  }

  ContactMessage copyWith({
    int? id,
    int? parentId,
    ContactSender? sender,
    String? authorName,
    String? message,
    String? time,
    String? avatarUrl,
    bool? highlighted,
  }) =>
      ContactMessage(
        id: id ?? this.id,
        parentId: parentId ?? this.parentId,
        sender: sender ?? this.sender,
        authorName: authorName ?? this.authorName,
        message: message ?? this.message,
        time: time ?? this.time,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        highlighted: highlighted ?? this.highlighted,
      );

  @override
  List<Object?> get props => [
        id,
        parentId,
        sender,
        authorName,
        message,
        time,
        avatarUrl,
        highlighted,
      ];
}
