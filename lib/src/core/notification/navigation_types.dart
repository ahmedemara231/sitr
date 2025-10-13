part of 'notification_service.dart';

enum NotificationType {
  none('0', navigation: HomeNavigation()),
  // message(1, navigation: MessageNavigation()),
  update('unblocked', navigation: UpdateNavigation());
  // warning(3, navigation: HomeNavigation()),
  // error(4, navigation: HomeNavigation()),
  // success(5, navigation: HomeNavigation());

  final String type;
  final NotificationNavigation navigation;
  const NotificationType(this.type, {required this.navigation});
}
