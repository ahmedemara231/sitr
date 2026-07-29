import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/shared/models/user_models/user_model.dart';
import '../data/models/app_badge_counts_model.dart';

class AppBadgeCountsCubit extends AsyncCubit<AppBadgeCountsModel> {
  StreamSubscription<RemoteMessage>? _notificationSubscription;

  AppBadgeCountsCubit() : super(const AppBadgeCountsModel.initial());

  Future<void> loadCounts() async {
    if (!UserModel.isAuthenticated) return;
    await executeAsyncWithBaseModel(
      operation: () => baseCrudUseCase.call<AppBadgeCountsModel>(
        CrudBaseParmas<AppBadgeCountsModel>(
          api: ApiConstants.appBadgeCounts,
          httpRequestType: HttpRequestType.get,
          mapper: (json) => AppBadgeCountsModel.fromJson(json),
        ),
      ),
    );
  }

  void startNotificationInterceptor() {
    if (!UserModel.isAuthenticated || _notificationSubscription != null) {
      return;
    }
    _notificationSubscription =
        FirebaseMessaging.onMessage.listen(_onNotificationReceived);
  }

  void clearNotificationsCount() {
    updateData(state.data.copyWith(notificationsCount: 0));
  }

  void clearUnreadMessagesCount() {
    updateData(state.data.copyWith(unreadMessagesCount: 0));
  }

  void clearUnreadMessageRequestsCount() {
    updateData(state.data.copyWith(messageRequestsCount: 0));
  }

  void _onNotificationReceived(RemoteMessage message) {
    final Map<String, dynamic> data = message.data;
    final bool hasChatReference = data['match_request_id'] != null;
    final bool hasMessageRequest = _hasMessageRequest(data);
    final bool isPendingMessageRequest =
        (data['message_request_status']?.toString() ?? 'pending') == 'pending';
    final bool isFinishedMessageRequest =
        hasMessageRequest && !isPendingMessageRequest;
    final AppBadgeCountsModel counts = state.data;

    updateData(
      counts.copyWith(
        notificationsCount: counts.notificationsCount + 1,
        unreadMessagesCount: hasChatReference
            ? counts.unreadMessagesCount + 1
            : counts.unreadMessagesCount,
        messageRequestsCount: isPendingMessageRequest && hasMessageRequest
            ? counts.messageRequestsCount + 1
            : isFinishedMessageRequest
                ? _decrement(counts.messageRequestsCount)
                : counts.messageRequestsCount,
      ),
    );
  }

  bool _hasMessageRequest(Map<String, dynamic> data) {
    final String type = data['type']?.toString() ?? '';
    return data['message_request_id'] != null ||
        type == 'message_request' ||
        type == 'new_chat_request';
  }

  int _decrement(int value) => value > 0 ? value - 1 : 0;

  @override
  Future<void> close() async {
    await _notificationSubscription?.cancel();
    return super.close();
  }
}
