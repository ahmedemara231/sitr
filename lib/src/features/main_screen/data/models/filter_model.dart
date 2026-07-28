import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../auth/models/dowry.dart';

class FilterModel {
  final String? maritalStatus;
  final int? age;
  final String? currentJob;
  final Dowry? dowry;
  final String? educationLevel;
  final String? skinColor;
  final int? wantChildren;
  final String? hijab;
  final String? chatLang;
  final int? isSmoker;
  final int? isPrayer;
  final String? weddingType;
  final String? religiousCommitment;
  final String? type;
  final int? cityId;
  final double? weight;
  final double? height;

  factory FilterModel.initial() => FilterModel();
  FilterModel({
    this.maritalStatus,
    this.age,
    this.currentJob,
    this.dowry,
    this.educationLevel,
    this.skinColor,
    this.wantChildren,
    this.hijab,
    this.chatLang,
    this.isSmoker,
    this.isPrayer,
    this.weddingType,
    this.religiousCommitment,
    this.type,
    this.cityId,
    this.weight,
    this.height,
  });

  // Convert FilterModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'marital_status': maritalStatus,
      'age': age,
      'current_job': currentJob,
      'dowry_min': dowry?.from,
      'dowry_max': dowry?.to,
      'education_level': educationLevel,
      'skin_color': skinColor,
      'want_children': wantChildren,
      'hijab': hijab,
      'chat_lang': chatLang,
      'is_smoker': isSmoker,
      'is_prayer': isPrayer,
      'wedding_type': weddingType,
      'religious_commitment': religiousCommitment,
      'type': UserModel.isFemale? 'male' : 'female',
      'city_id': cityId,
      'weight': weight,
      'height': height,
    }..removeWhere((key, value) => value == null);
  }

  // Create a copy with updated fields
  FilterModel copyWith({
    String? maritalStatus,
    int? age,
    String? currentJob,
    Dowry? dowry,
    String? educationLevel,
    String? skinColor,
    int? wantChildren,
    String? hijab,
    String? chatLang,
    int? isSmoker,
    int? isPrayer,
    String? weddingType,
    String? religiousCommitment,
    String? type,
    int? cityId,
    double? weight,
    double? height,
  }) {
    return FilterModel(
      maritalStatus: maritalStatus ?? this.maritalStatus,
      age: age ?? this.age,
      currentJob: currentJob ?? this.currentJob,
      dowry: dowry ?? this.dowry,
      educationLevel: educationLevel ?? this.educationLevel,
      skinColor: skinColor ?? this.skinColor,
      wantChildren: wantChildren ?? this.wantChildren,
      hijab: hijab ?? this.hijab,
      chatLang: chatLang ?? this.chatLang,
      isSmoker: isSmoker ?? this.isSmoker,
      isPrayer: isPrayer ?? this.isPrayer,
      weddingType: weddingType ?? this.weddingType,
      religiousCommitment: religiousCommitment ?? this.religiousCommitment,
      type: type ?? this.type,
      cityId: cityId ?? this.cityId,
      weight: weight ?? this.weight,
      height: height ?? this.height,
    );
  }

  // Create FilterModel from JSON
  factory FilterModel.fromJson(Map<String, dynamic> json) {
    return FilterModel(
      maritalStatus: json['marital_status'] as String?,
      age: json['age'] as int?,
      currentJob: json['current_job'] as String?,
      dowry: Dowry(from: json['dowry_min'], to: json['dowry_max']),
      educationLevel: json['education_level'] as String?,
      skinColor: json['skin_color'] as String?,
      wantChildren: json['want_children'] as int?,
      hijab: json['hijab'] as String?,
      chatLang: json['chat_lang'] as String?,
      isSmoker: json['is_smoker'] as int?,
      isPrayer: json['is_prayer'] as int?,
      weddingType: json['wedding_type'] as String?,
      religiousCommitment: json['religious_commitment'] as String?,
      type: json['type'] as String?,
      cityId: json['city_id'] as int?,
      weight: (json['weight'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
    );
  }
}