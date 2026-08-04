import 'package:equatable/equatable.dart';

class PromotionPlansPageModel extends Equatable {
  final PromotionPlansModel data;
  final PromotionPaginationModel pagination;

  const PromotionPlansPageModel({
    required this.data,
    required this.pagination,
  });

  factory PromotionPlansPageModel.initial() => PromotionPlansPageModel(
        data: PromotionPlansModel.initial(),
        pagination: const PromotionPaginationModel.initial(),
      );

  factory PromotionPlansPageModel.fromJson(dynamic json) {
    final Map<String, dynamic> map = _asMap(json);
    final Map<String, dynamic> plansContainer = _asMap(map['plans']);

    return PromotionPlansPageModel(
      data: PromotionPlansModel.fromJson({
        'plans': plansContainer['data'],
        'features': map['features'],
      }),
      pagination: PromotionPaginationModel.fromJson(
        plansContainer['pagination'],
      ),
    );
  }

  PromotionPlansPageModel copyWith({
    PromotionPlansModel? data,
    PromotionPaginationModel? pagination,
  }) =>
      PromotionPlansPageModel(
        data: data ?? this.data,
        pagination: pagination ?? this.pagination,
      );

  Map<String, dynamic> toJson() => {
        'plans': {
          'data': data.plans.map((plan) => plan.toJson()).toList(),
          'pagination': pagination.toJson(),
        },
        'features': data.features.map((feature) => feature.toJson()).toList(),
      };

  @override
  List<Object?> get props => [data, pagination];
}

class PromotionPlansModel extends Equatable {
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
    final List<PromotionPlanModel> plans = _asList(map['plans'])
        .map(PromotionPlanModel.fromJson)
        .where((plan) => plan.duration.isNotEmpty)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    final List<PromotionFeatureModel> features = _asList(map['features'])
        .map(PromotionFeatureModel.fromJson)
        .where((feature) => feature.title.isNotEmpty)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return PromotionPlansModel(plans: plans, features: features);
  }

  PromotionPlanModel get defaultPlan => plans.firstWhere(
        (plan) => plan.isDefault,
        orElse: () => plans.firstWhere(
          (plan) => plan.isHighlighted,
          orElse: () => plans.first,
        ),
      );

  PromotionPlansModel copyWith({
    List<PromotionPlanModel>? plans,
    List<PromotionFeatureModel>? features,
  }) =>
      PromotionPlansModel(
        plans: plans ?? this.plans,
        features: features ?? this.features,
      );

  Map<String, dynamic> toJson() => {
        'plans': plans.map((plan) => plan.toJson()).toList(),
        'features': features.map((feature) => feature.toJson()).toList(),
      };

  @override
  List<Object?> get props => [plans, features];
}

class PromotionPlanModel extends Equatable {
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

  const PromotionPlanModel.initial()
      : id = 0,
        code = '',
        duration = '',
        price = 0,
        currency = '',
        period = '',
        description = '',
        badge = null,
        isHighlighted = false,
        isDefault = false,
        sortOrder = 0;

  factory PromotionPlanModel.fromJson(dynamic json) {
    final Map<String, dynamic> map = _asMap(json);

    return PromotionPlanModel(
      id: _readInt(map['id']),
      code: map['code']?.toString() ?? '',
      duration: map['duration']?.toString() ?? '',
      price: _readNum(map['price']),
      currency: map['currency']?.toString() ?? '',
      period: map['period']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      badge: _readNullableString(map['badge']),
      isHighlighted: _readBool(map['is_highlighted']),
      isDefault: _readBool(map['is_default']),
      sortOrder: _readInt(map['sort_order']),
    );
  }

  String get priceText {
    if (price % 1 == 0) return price.toInt().toString();
    return price.toString();
  }

  PromotionPlanModel copyWith({
    int? id,
    String? code,
    String? duration,
    num? price,
    String? currency,
    String? period,
    String? description,
    String? badge,
    bool clearBadge = false,
    bool? isHighlighted,
    bool? isDefault,
    int? sortOrder,
  }) =>
      PromotionPlanModel(
        id: id ?? this.id,
        code: code ?? this.code,
        duration: duration ?? this.duration,
        price: price ?? this.price,
        currency: currency ?? this.currency,
        period: period ?? this.period,
        description: description ?? this.description,
        badge: clearBadge ? null : badge ?? this.badge,
        isHighlighted: isHighlighted ?? this.isHighlighted,
        isDefault: isDefault ?? this.isDefault,
        sortOrder: sortOrder ?? this.sortOrder,
      );

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

  @override
  List<Object?> get props => [
        id,
        code,
        duration,
        price,
        currency,
        period,
        description,
        badge,
        isHighlighted,
        isDefault,
        sortOrder,
      ];
}

class PromotionFeatureModel extends Equatable {
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

  const PromotionFeatureModel.initial()
      : id = 0,
        code = '',
        title = '',
        sortOrder = 0;

  factory PromotionFeatureModel.fromJson(dynamic json) {
    if (json is String) {
      return PromotionFeatureModel(id: 0, code: '', title: json);
    }
    final Map<String, dynamic> map = _asMap(json);

    return PromotionFeatureModel(
      id: _readInt(map['id']),
      code: map['code']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      sortOrder: _readInt(map['sort_order']),
    );
  }

  PromotionFeatureModel copyWith({
    int? id,
    String? code,
    String? title,
    int? sortOrder,
  }) =>
      PromotionFeatureModel(
        id: id ?? this.id,
        code: code ?? this.code,
        title: title ?? this.title,
        sortOrder: sortOrder ?? this.sortOrder,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'title': title,
        'sort_order': sortOrder,
      };

  @override
  List<Object?> get props => [id, code, title, sortOrder];
}

class PromotionPaginationModel extends Equatable {
  final int totalItems;
  final int countItems;
  final int perPage;
  final int totalPages;
  final int currentPage;
  final String? nextPageUrl;
  final String? previousPageUrl;

  const PromotionPaginationModel({
    required this.totalItems,
    required this.countItems,
    required this.perPage,
    required this.totalPages,
    required this.currentPage,
    required this.nextPageUrl,
    required this.previousPageUrl,
  });

  const PromotionPaginationModel.initial()
      : totalItems = 0,
        countItems = 0,
        perPage = 0,
        totalPages = 0,
        currentPage = 0,
        nextPageUrl = null,
        previousPageUrl = null;

  factory PromotionPaginationModel.fromJson(dynamic json) {
    final Map<String, dynamic> map = _asMap(json);

    return PromotionPaginationModel(
      totalItems: _readInt(map['total_items']),
      countItems: _readInt(map['count_items']),
      perPage: _readInt(map['per_page']),
      totalPages: _readInt(map['total_pages']),
      currentPage: _readInt(map['current_page']),
      nextPageUrl: _readNullableString(map['next_page_url']),
      previousPageUrl: _readNullableString(
        map['prev_page_url'] ?? map['perv_page_url'],
      ),
    );
  }

  PromotionPaginationModel copyWith({
    int? totalItems,
    int? countItems,
    int? perPage,
    int? totalPages,
    int? currentPage,
    String? nextPageUrl,
    bool clearNextPageUrl = false,
    String? previousPageUrl,
    bool clearPreviousPageUrl = false,
  }) =>
      PromotionPaginationModel(
        totalItems: totalItems ?? this.totalItems,
        countItems: countItems ?? this.countItems,
        perPage: perPage ?? this.perPage,
        totalPages: totalPages ?? this.totalPages,
        currentPage: currentPage ?? this.currentPage,
        nextPageUrl: clearNextPageUrl ? null : nextPageUrl ?? this.nextPageUrl,
        previousPageUrl: clearPreviousPageUrl
            ? null
            : previousPageUrl ?? this.previousPageUrl,
      );

  Map<String, dynamic> toJson() => {
        'total_items': totalItems,
        'count_items': countItems,
        'per_page': perPage,
        'total_pages': totalPages,
        'current_page': currentPage,
        'next_page_url': nextPageUrl,
        'prev_page_url': previousPageUrl,
      };

  @override
  List<Object?> get props => [
        totalItems,
        countItems,
        perPage,
        totalPages,
        currentPage,
        nextPageUrl,
        previousPageUrl,
      ];
}

Map<String, dynamic> _asMap(dynamic json) {
  if (json is Map<String, dynamic>) return json;
  if (json is Map) return Map<String, dynamic>.from(json);
  return {};
}

List<dynamic> _asList(dynamic json) => json is List ? json : [];

String? _readNullableString(dynamic value) {
  final String normalized = value?.toString().trim() ?? '';
  return normalized.isEmpty ? null : normalized;
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
