import 'package:flutter_base/src/features/home/data/models/app_badge_counts_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps all aggregate badge counts', () {
    final AppBadgeCountsModel counts = AppBadgeCountsModel.fromJson(const {
      'notifications_count': 4,
      'unread_messages_count': 7,
      'message_requests_count': 2,
    });

    expect(counts.notificationsCount, 4);
    expect(counts.unreadMessagesCount, 7);
    expect(counts.messageRequestsCount, 2);
    expect(counts.toJson(), const {
      'notifications_count': 4,
      'unread_messages_count': 7,
      'message_requests_count': 2,
    });
  });

  test('normalizes missing, string, and negative counts', () {
    final AppBadgeCountsModel counts = AppBadgeCountsModel.fromJson(const {
      'notifications_count': '3',
      'unread_messages_count': -1,
    });

    expect(counts.notificationsCount, 3);
    expect(counts.unreadMessagesCount, 0);
    expect(counts.messageRequestsCount, 0);
  });

  test('copyWith updates only the selected badge', () {
    const AppBadgeCountsModel counts = AppBadgeCountsModel(
      notificationsCount: 4,
      unreadMessagesCount: 7,
      messageRequestsCount: 2,
    );

    final AppBadgeCountsModel updated = counts.copyWith(
      messageRequestsCount: 1,
    );

    expect(updated.notificationsCount, 4);
    expect(updated.unreadMessagesCount, 7);
    expect(updated.messageRequestsCount, 1);
  });
}
