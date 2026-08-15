import 'package:equatable/equatable.dart';

class ProfileDetailItemModel extends Equatable {
  final String icon;
  final String label;
  final String? value;

  const ProfileDetailItemModel({
    required this.icon,
    required this.label,
    required this.value,
  });

  factory ProfileDetailItemModel.initial() =>
      const ProfileDetailItemModel(icon: '', label: '', value: null);

  factory ProfileDetailItemModel.fromJson(Map<String, dynamic> json) =>
      ProfileDetailItemModel(
        icon: json['icon'] ?? '',
        label: json['label'] ?? '',
        value: json['value'],
      );

  Map<String, dynamic> toJson() => {
        'icon': icon,
        'label': label,
        'value': value,
      };

  ProfileDetailItemModel copyWith({
    String? icon,
    String? label,
    String? value,
  }) =>
      ProfileDetailItemModel(
        icon: icon ?? this.icon,
        label: label ?? this.label,
        value: value ?? this.value,
      );

  @override
  List<Object?> get props => [icon, label, value];
}
