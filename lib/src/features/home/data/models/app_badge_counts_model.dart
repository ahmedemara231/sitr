import 'package:equatable/equatable.dart';

class AppBadgeCountsModel extends Equatable {
  final int notificationsCount;
  final int unreadMessagesCount;
  final int messageRequestsCount;

  const AppBadgeCountsModel({
    required this.notificationsCount,
    required this.unreadMessagesCount,
    required this.messageRequestsCount,
  });

  const AppBadgeCountsModel.initial()
      : notificationsCount = 1,
        unreadMessagesCount = 1,
        messageRequestsCount = 1;

  factory AppBadgeCountsModel.fromJson(Map<String, dynamic> json) {
    return AppBadgeCountsModel(
      notificationsCount: _parseCount(json['notifications_count']),
      unreadMessagesCount: _parseCount(json['unread_messages_count']),
      messageRequestsCount: _parseCount(json['message_requests_count']),
    );
  }

  AppBadgeCountsModel copyWith({
    int? notificationsCount,
    int? unreadMessagesCount,
    int? messageRequestsCount,
  }) {
    return AppBadgeCountsModel(
      notificationsCount: notificationsCount ?? this.notificationsCount,
      unreadMessagesCount: unreadMessagesCount ?? this.unreadMessagesCount,
      messageRequestsCount: messageRequestsCount ?? this.messageRequestsCount,
    );
  }

  Map<String, dynamic> toJson() => {
        'notifications_count': notificationsCount,
        'unread_messages_count': unreadMessagesCount,
        'message_requests_count': messageRequestsCount,
      };

  static int _parseCount(dynamic value) {
    final int count = int.tryParse(value?.toString() ?? '') ?? 0;
    return count < 0 ? 0 : count;
  }

  @override
  List<Object?> get props => [
        notificationsCount,
        unreadMessagesCount,
        messageRequestsCount,
      ];
}
