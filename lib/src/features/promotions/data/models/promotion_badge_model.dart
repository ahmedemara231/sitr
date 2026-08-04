import 'package:equatable/equatable.dart';

class PromotionBadgeDataModel extends Equatable {
  final String title;
  final String subtitle;
  final String actionText;

  const PromotionBadgeDataModel({
    required this.title,
    required this.subtitle,
    required this.actionText,
  });

  const PromotionBadgeDataModel.initial()
      : title = '',
        subtitle = '',
        actionText = '';

  factory PromotionBadgeDataModel.fromJson(dynamic json) {
    final Map<String, dynamic> map = _asMap(json);

    return PromotionBadgeDataModel(
      title: map['title']?.toString() ?? '',
      subtitle: map['subtitle']?.toString() ?? '',
      actionText: (map['action_text'] ?? map['status_text'])?.toString() ?? '',
    );
  }

  PromotionBadgeDataModel copyWith({
    String? title,
    String? subtitle,
    String? actionText,
  }) =>
      PromotionBadgeDataModel(
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        actionText: actionText ?? this.actionText,
      );

  Map<String, dynamic> toJson({bool isPromoted = false}) => {
        'title': title,
        'subtitle': subtitle,
        isPromoted ? 'status_text' : 'action_text': actionText,
      };

  @override
  List<Object?> get props => [title, subtitle, actionText];
}

Map<String, dynamic> _asMap(dynamic json) {
  if (json is Map<String, dynamic>) return json;
  if (json is Map) return Map<String, dynamic>.from(json);
  return {};
}
