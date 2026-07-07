class PromotionPlansModel {
  final List<PromotionPlanModel> plans;
  final List<PromotionFeatureModel> features;

  const PromotionPlansModel({
    required this.plans,
    required this.features,
  });

  factory PromotionPlansModel.initial() => const PromotionPlansModel(
        plans: [],
        features: [],
      );

  factory PromotionPlansModel.fromJson(dynamic json) {
    final Map<String, dynamic> map = _asMap(json);
    final List<dynamic> plansJson =
        _readList(map, ['plans', 'promotion_plans', 'packages']);
    final List<dynamic> featuresJson =
        _readList(map, ['features', 'promotion_features', 'benefits']);
    final List<PromotionPlanModel> plans = plansJson
        .map(PromotionPlanModel.fromDynamic)
        .where((plan) => plan.duration.isNotEmpty)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    final List<PromotionFeatureModel> features = featuresJson
        .map(PromotionFeatureModel.fromDynamic)
        .where((feature) => feature.title.isNotEmpty)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return PromotionPlansModel(
      plans: plans,
      features: features,
    );
  }

  PromotionPlanModel get defaultPlan => plans.firstWhere(
        (plan) => plan.isDefault,
        orElse: () => plans.firstWhere(
          (plan) => plan.isHighlighted,
          orElse: () => plans.first,
        ),
      );

  Map<String, dynamic> toJson() => {
        'plans': plans.map((plan) => plan.toJson()).toList(),
        'features': features.map((feature) => feature.toJson()).toList(),
      };
}

class PromotionPlanModel {
  final int id;
  final String code;
  final String duration;
  final num price;
  final String currency;
  final String period;
  final String description;
  final String? badge;
  final bool isHighlighted;
  final bool isDefault;
  final int sortOrder;

  const PromotionPlanModel({
    required this.id,
    required this.code,
    required this.duration,
    required this.price,
    required this.currency,
    required this.period,
    required this.description,
    this.badge,
    this.isHighlighted = false,
    this.isDefault = false,
    this.sortOrder = 0,
  });

  factory PromotionPlanModel.fromDynamic(dynamic json) =>
      PromotionPlanModel.fromJson(_asMap(json));

  factory PromotionPlanModel.fromJson(Map<String, dynamic> json) {
    return PromotionPlanModel(
      id: _readInt(json['id'] ?? json['plan_id'] ?? json['package_id']),
      code: _readString(json, ['code', 'slug', 'key']),
      duration: _readString(json, ['duration', 'title', 'name']),
      price: _readNum(json['price'] ?? json['amount']),
      currency: _readString(json, ['currency']),
      period: _readString(json, ['period', 'per', 'billing_period']),
      description: _readString(json, ['description', 'desc', 'subtitle']),
      badge: _readNullableString(json, ['badge', 'label', 'tag']),
      isHighlighted: _readBool(
        json['is_highlighted'] ?? json['highlight'] ?? json['is_popular'],
      ),
      isDefault: _readBool(
        json['is_default'] ?? json['default'] ?? json['selected_by_default'],
      ),
      sortOrder: _readInt(json['sort_order'] ?? json['order']),
    );
  }

  String get priceText {
    if (price % 1 == 0) {
      return price.toInt().toString();
    }
    return price.toString();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'duration': duration,
        'price': price,
        'currency': currency,
        'period': period,
        'description': description,
        'badge': badge,
        'is_highlighted': isHighlighted,
        'is_default': isDefault,
        'sort_order': sortOrder,
      };
}

class PromotionFeatureModel {
  final int id;
  final String code;
  final String title;
  final int sortOrder;

  const PromotionFeatureModel({
    required this.id,
    required this.code,
    required this.title,
    this.sortOrder = 0,
  });

  factory PromotionFeatureModel.fromDynamic(dynamic json) {
    if (json is String) {
      return PromotionFeatureModel(id: 0, code: '', title: json);
    }
    return PromotionFeatureModel.fromJson(_asMap(json));
  }

  factory PromotionFeatureModel.fromJson(Map<String, dynamic> json) {
    return PromotionFeatureModel(
      id: _readInt(json['id'] ?? json['feature_id']),
      code: _readString(json, ['code', 'slug', 'key']),
      title: _readString(json, ['title', 'name', 'description']),
      sortOrder: _readInt(json['sort_order'] ?? json['order']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'title': title,
        'sort_order': sortOrder,
      };
}

Map<String, dynamic> _asMap(dynamic json) {
  if (json is Map<String, dynamic>) return json;
  if (json is Map) return Map<String, dynamic>.from(json);
  return {};
}

List<dynamic> _readList(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final dynamic value = json[key];
    if (value is List) return value;
  }
  return [];
}

String _readString(Map<String, dynamic> json, List<String> keys) {
  return _readNullableString(json, keys) ?? '';
}

String? _readNullableString(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final dynamic value = json[key];
    if (value != null && value.toString().trim().isNotEmpty) {
      return value.toString();
    }
  }
  return null;
}

int _readInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

num _readNum(dynamic value) {
  if (value is num) return value;
  return num.tryParse(value?.toString() ?? '') ?? 0;
}

bool _readBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value == 1;
  final String normalized = value?.toString().toLowerCase().trim() ?? '';
  return normalized == 'true' || normalized == '1' || normalized == 'yes';
}
