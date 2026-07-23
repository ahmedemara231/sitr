class DeleteAccountReason {
  final int id;
  final String title;
  final String? description;
  final bool isOther;

  const DeleteAccountReason({
    required this.id,
    required this.title,
    this.description,
    this.isOther = false,
  });

  factory DeleteAccountReason.initial() =>
      const DeleteAccountReason(id: 0, title: '');

  factory DeleteAccountReason.fromJson(Map<String, dynamic> json) =>
      DeleteAccountReason(
        id: json['id'] ?? 0,
        title: json['text'] ?? '',
        description: json['description'],
        isOther: json['is_other'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': title,
        'description': description,
        'is_other': isOther,
      };

  DeleteAccountReason copyWith({
    int? id,
    String? title,
    String? description,
    bool? isOther,
  }) =>
      DeleteAccountReason(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        isOther: isOther ?? this.isOther,
      );
}
