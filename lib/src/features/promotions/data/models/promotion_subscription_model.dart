class PromotionSubscriptionModel {
  final String link;

  const PromotionSubscriptionModel({
    required this.link,
  });

  factory PromotionSubscriptionModel.fromJson(dynamic json) {
    final Map<String, dynamic> map = _asMap(json);
    return PromotionSubscriptionModel(
      link: _readString(map, ['link', 'redirect_url', 'url']),
    );
  }

  Map<String, dynamic> toJson() => {
        'link': link,
      };
}

Map<String, dynamic> _asMap(dynamic json) {
  if (json is Map<String, dynamic>) return json;
  if (json is Map) return Map<String, dynamic>.from(json);
  return {};
}

String _readString(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final dynamic value = json[key];
    if (value != null && value.toString().trim().isNotEmpty) {
      return value.toString();
    }
  }
  return '';
}
