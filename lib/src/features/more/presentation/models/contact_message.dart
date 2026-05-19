enum ContactSender { user, support }

class ContactMessage {
  final ContactSender sender;
  final String authorName;
  final String message;
  final String time;
  final String? avatarUrl;
  final bool highlighted;

  const ContactMessage({
    required this.sender,
    required this.authorName,
    required this.message,
    required this.time,
    this.avatarUrl,
    this.highlighted = false,
  });

  bool get isSupport => sender == ContactSender.support;

  factory ContactMessage.fromJson(Map<String, dynamic> json) => ContactMessage(
        sender: (json['sender'] ?? '') == 'support'
            ? ContactSender.support
            : ContactSender.user,
        authorName: json['author_name'] ?? '',
        message: json['message'] ?? '',
        time: json['time'] ?? '',
        avatarUrl: json['avatar_url'],
        highlighted: json['highlighted'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'sender': isSupport ? 'support' : 'user',
        'author_name': authorName,
        'message': message,
        'time': time,
        'avatar_url': avatarUrl,
        'highlighted': highlighted,
      };

  ContactMessage copyWith({
    ContactSender? sender,
    String? authorName,
    String? message,
    String? time,
    String? avatarUrl,
    bool? highlighted,
  }) =>
      ContactMessage(
        sender: sender ?? this.sender,
        authorName: authorName ?? this.authorName,
        message: message ?? this.message,
        time: time ?? this.time,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        highlighted: highlighted ?? this.highlighted,
      );
}
