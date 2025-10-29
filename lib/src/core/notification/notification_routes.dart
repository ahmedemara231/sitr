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

// ----------------- Home -----------------
class HomeNavigation implements NotificationNavigation {
  const HomeNavigation();

  @override
  void navigate({required Map<String, dynamic> data}) {
    // TODO: Replace with actual home navigation logic
  }
}

// ----------------- Update / Profile Approval -----------------
class UpdateNavigation implements NotificationNavigation {
  const UpdateNavigation();

  @override
  void navigate({required Map<String, dynamic> data}) {
    // TODO: e.g. open profile update, account review, etc.
  }
}

// ----------------- Complaints -----------------
class ComplaintNavigation implements NotificationNavigation {
  const ComplaintNavigation();

  @override
  void navigate({required Map<String, dynamic> data}) {
    Go.to(ComplaintDetailsScreen(
        complaintId: data['complaint_id']
    ));
  }
}

// ----------------- User Profile -----------------
class UserProfileNavigation implements NotificationNavigation {
  const UserProfileNavigation();

  @override
  void navigate({required Map<String, dynamic> data}) {
    Go.to(ParentDetailsScreen(id: data['visitor_id']));
  }
}

// ----------------- Match Requests -----------------
class MatchRequestNavigation implements NotificationNavigation {
  const MatchRequestNavigation();

  @override
  void navigate({required Map<String, dynamic> data}) {
    // TODO: Navigate to specific match request or chat details
    // final requestId = data['request_id'];
  }
}

// ----------------- Packages -----------------
class PackagesNavigation implements NotificationNavigation {
  const PackagesNavigation();

  @override
  void navigate({required Map<String, dynamic> data}) {
    Go.to(const MyPackagesScreen());
  }
}

// ----------------- Setr Code (Invitation / Access Code) -----------------
class SetrCodeNavigation implements NotificationNavigation {
  const SetrCodeNavigation();

  @override
  void navigate({required Map<String, dynamic> data}) {
    // TODO: Navigate to Setr code screen or renewal page
    final codeId = data['code_id'];
  }
}

