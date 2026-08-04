import 'package:equatable/equatable.dart';

class PromotionSheetDataModel extends Equatable {
  final String title;
  final String subtitle;
  final String featureIntro;
  final String subscribeButtonTemplate;
  final String subscribedSuccessText;
  final String cancelAnytimeText;

  const PromotionSheetDataModel({
    required this.title,
    required this.subtitle,
    required this.featureIntro,
    required this.subscribeButtonTemplate,
    required this.subscribedSuccessText,
    required this.cancelAnytimeText,
  });

  const PromotionSheetDataModel.initial()
      : title = '',
        subtitle = '',
        featureIntro = '',
        subscribeButtonTemplate = '',
        subscribedSuccessText = '',
        cancelAnytimeText = '';

  factory PromotionSheetDataModel.fromJson(dynamic json) {
    final Map<String, dynamic> map = _asMap(json);

    return PromotionSheetDataModel(
      title: map['title']?.toString() ?? '',
      subtitle: map['subtitle']?.toString() ?? '',
      featureIntro: map['feature_intro']?.toString() ?? '',
      subscribeButtonTemplate:
          map['subscribe_button_template']?.toString() ?? '',
      subscribedSuccessText: map['subscribed_success_text']?.toString() ?? '',
      cancelAnytimeText: map['cancel_anytime_text']?.toString() ?? '',
    );
  }

  PromotionSheetDataModel copyWith({
    String? title,
    String? subtitle,
    String? featureIntro,
    String? subscribeButtonTemplate,
    String? subscribedSuccessText,
    String? cancelAnytimeText,
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
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'subtitle': subtitle,
        'feature_intro': featureIntro,
        'subscribe_button_template': subscribeButtonTemplate,
        'subscribed_success_text': subscribedSuccessText,
        'cancel_anytime_text': cancelAnytimeText,
      };

  @override
  List<Object?> get props => [
        title,
        subtitle,
        featureIntro,
        subscribeButtonTemplate,
        subscribedSuccessText,
        cancelAnytimeText,
      ];
}

Map<String, dynamic> _asMap(dynamic json) {
  if (json is Map<String, dynamic>) return json;
  if (json is Map) return Map<String, dynamic>.from(json);
  return {};
}
