import 'package:equatable/equatable.dart';

import 'promotion_plans_model.dart';

class PromotionDataModel extends Equatable {
  final PromotionBadgeDataModel promotionBadge;
  final PromotionBadgeDataModel promotedBadge;
  final PromotionSheetDataModel promotionSheet;

  const PromotionDataModel({
    required this.promotionBadge,
    required this.promotedBadge,
    required this.promotionSheet,
  });

  factory PromotionDataModel.initial() => PromotionDataModel(
        promotionBadge: const PromotionBadgeDataModel.initial(),
        promotedBadge: const PromotionBadgeDataModel.initial(),
        promotionSheet: PromotionSheetDataModel.initial(),
      );

  factory PromotionDataModel.fromJson(dynamic json) {
    final Map<String, dynamic> map = _asMap(json);

    return PromotionDataModel(
      promotionBadge: PromotionBadgeDataModel.fromJson(
        _readMap(map, ['promotion_badge', 'promotion']),
      ),
      promotedBadge: PromotionBadgeDataModel.fromJson(
        _readMap(map, ['promoted_badge', 'promoted']),
      ),
      promotionSheet: PromotionSheetDataModel.fromJson(
        _readMap(map, ['promotion_sheet', 'sheet']),
      ),
    );
  }

  PromotionDataModel copyWith({
    PromotionBadgeDataModel? promotionBadge,
    PromotionBadgeDataModel? promotedBadge,
    PromotionSheetDataModel? promotionSheet,
  }) =>
      PromotionDataModel(
        promotionBadge: promotionBadge ?? this.promotionBadge,
        promotedBadge: promotedBadge ?? this.promotedBadge,
        promotionSheet: promotionSheet ?? this.promotionSheet,
      );

  Map<String, dynamic> toJson() => {
        'promotion_badge': promotionBadge.toJson(),
        'promoted_badge': promotedBadge.toJson(actionKey: 'status_text'),
        'promotion_sheet': promotionSheet.toJson(),
      };

  @override
  List<Object?> get props => [
        promotionBadge,
        promotedBadge,
        promotionSheet,
      ];
}

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

  factory PromotionBadgeDataModel.fromJson(Map<String, dynamic> json) =>
      PromotionBadgeDataModel(
        title: _readString(json, ['title']),
        subtitle: _readString(json, ['subtitle']),
        actionText: _readString(
          json,
          ['action_text', 'status_text', 'action', 'status'],
        ),
      );

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

  Map<String, dynamic> toJson({String actionKey = 'action_text'}) => {
        'title': title,
        'subtitle': subtitle,
        actionKey: actionText,
      };

  @override
  List<Object?> get props => [title, subtitle, actionText];
}

class PromotionSheetDataModel extends Equatable {
  final String title;
  final String subtitle;
  final String featureIntro;
  final String subscribeButtonTemplate;
  final String subscribedSuccessText;
  final String cancelAnytimeText;
  final PromotionPlansModel plansData;

  const PromotionSheetDataModel({
    required this.title,
    required this.subtitle,
    required this.featureIntro,
    required this.subscribeButtonTemplate,
    required this.subscribedSuccessText,
    required this.cancelAnytimeText,
    required this.plansData,
  });

  factory PromotionSheetDataModel.initial() => PromotionSheetDataModel(
        title: '',
        subtitle: '',
        featureIntro: '',
        subscribeButtonTemplate: '',
        subscribedSuccessText: '',
        cancelAnytimeText: '',
        plansData: PromotionPlansModel.initial(),
      );

  factory PromotionSheetDataModel.fromJson(Map<String, dynamic> json) =>
      PromotionSheetDataModel(
        title: _readString(json, ['title']),
        subtitle: _readString(json, ['subtitle']),
        featureIntro: _readString(json, ['feature_intro']),
        subscribeButtonTemplate: _readString(
          json,
          ['subscribe_button_template', 'subscribe_template'],
        ),
        subscribedSuccessText: _readString(
          json,
          ['subscribed_success_text', 'subscribed_success'],
        ),
        cancelAnytimeText: _readString(
          json,
          ['cancel_anytime_text', 'cancel_anytime'],
        ),
        plansData: PromotionPlansModel.fromJson(json),
      );

  PromotionSheetDataModel copyWith({
    String? title,
    String? subtitle,
    String? featureIntro,
    String? subscribeButtonTemplate,
    String? subscribedSuccessText,
    String? cancelAnytimeText,
    PromotionPlansModel? plansData,
  }) =>
      PromotionSheetDataModel(
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        featureIntro: featureIntro ?? this.featureIntro,
        subscribeButtonTemplate:
            subscribeButtonTemplate ?? this.subscribeButtonTemplate,
        subscribedSuccessText:
            subscribedSuccessText ?? this.subscribedSuccessText,
        cancelAnytimeText: cancelAnytimeText ?? this.cancelAnytimeText,
        plansData: plansData ?? this.plansData,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'subtitle': subtitle,
        'feature_intro': featureIntro,
        'subscribe_button_template': subscribeButtonTemplate,
        'subscribed_success_text': subscribedSuccessText,
        'cancel_anytime_text': cancelAnytimeText,
        ...plansData.toJson(),
      };

  @override
  List<Object?> get props => [
        title,
        subtitle,
        featureIntro,
        subscribeButtonTemplate,
        subscribedSuccessText,
        cancelAnytimeText,
        plansData,
      ];
}

Map<String, dynamic> _asMap(dynamic json) {
  if (json is Map<String, dynamic>) return json;
  if (json is Map) return Map<String, dynamic>.from(json);
  return {};
}

Map<String, dynamic> _readMap(
  Map<String, dynamic> json,
  List<String> keys,
) {
  for (final String key in keys) {
    final dynamic value = json[key];
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
  }
  return {};
}

String _readString(Map<String, dynamic> json, List<String> keys) {
  for (final String key in keys) {
    final dynamic value = json[key];
    if (value != null && value.toString().trim().isNotEmpty) {
      return value.toString();
    }
  }
  return '';
}
