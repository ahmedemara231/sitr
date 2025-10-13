part of 'notification_service.dart';

class NotificationRoutes {
  static void navigateByType(Map<String, dynamic> data) {
    final String type = data['type'];
    final notificationType = type.getType;
    notificationType.navigation.navigate(data: data);
  }
}

extension GetNotificationTypeById on String {
  NotificationType get getType {
    return NotificationType.values.firstWhere((element) => element.type == this);
  }
}

abstract interface class NotificationNavigation {
  void navigate({required Map<String, dynamic> data});
}

class HomeNavigation implements NotificationNavigation {
  const HomeNavigation();
  @override
  void navigate({required Map<String, dynamic> data}) {
    // Navigate to message screen with logic
  }
}

class MessageNavigation implements NotificationNavigation {
  const MessageNavigation();
  @override
  void navigate({required Map<String, dynamic> data}) {
    // Navigate to message screen with logic
  }
}

class UpdateNavigation implements NotificationNavigation {
  const UpdateNavigation();
  @override
  void navigate({required Map<String, dynamic> data}) {
    // Navigate to update screen
  }
}
