import 'package:equatable/equatable.dart';

import 'profile_detail_item_model.dart';

class ProfileSectionModel extends Equatable {
  final String title;
  final List<List<ProfileDetailItemModel>> rows;

  const ProfileSectionModel({
    required this.title,
    required this.rows,
  });

  factory ProfileSectionModel.initial() =>
      const ProfileSectionModel(title: '', rows: []);

  factory ProfileSectionModel.fromJson(Map<String, dynamic> json) =>
      ProfileSectionModel(
        title: json['title'] ?? '',
        rows: (json['rows'] as List?)
                ?.map(
                  (dynamic row) =>
                      (row as List?)
                          ?.map(
                            (dynamic item) => ProfileDetailItemModel.fromJson(
                              item as Map<String, dynamic>,
                            ),
                          )
                          .toList() ??
                      <ProfileDetailItemModel>[],
                )
                .toList() ??
            <List<ProfileDetailItemModel>>[],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'rows': rows
            .map(
              (List<ProfileDetailItemModel> row) => row
                  .map((ProfileDetailItemModel item) => item.toJson())
                  .toList(),
            )
            .toList(),
      };

  ProfileSectionModel copyWith({
    String? title,
    List<List<ProfileDetailItemModel>>? rows,
  }) =>
      ProfileSectionModel(
        title: title ?? this.title,
        rows: rows ?? this.rows,
      );

  @override
  List<Object?> get props => [title, rows];
}
