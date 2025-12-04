part of 'notification_service.dart';

class NotificationRoutes {

  static void navigateByType(Map<String, dynamic> data) {
    final String type = data['type'];
    log('the type is ${data['type']}');
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
    log('GoHome');
    Go.offAll(const HomeScreen());
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
    //لازم اعرف هو individual ولا parent
    // Go.to();
    // Go.to((id: data['visitor_id']));
  }
}

// ----------------- Match Requests / Chat -----------------
class MatchRequestNavigation implements NotificationNavigation {
  const MatchRequestNavigation();

  @override
  void navigate({required Map<String, dynamic> data}) {
    // Go.to(
    //     ChatScreen(
    //         requestModel: RequestModel(
    //             receiverId: receiverId,
    //             fromHome: 0.toString()
    //         ),
    //         receiverName: receiverName
    //     )
    // );
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

class PackageExpiredNavigation implements NotificationNavigation {
  const PackageExpiredNavigation();

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


// ----------------- Blocking -----------------
class BlockNavigation implements NotificationNavigation {
  const BlockNavigation();

  @override
  void navigate({required Map<String, dynamic> data}) {
    UserCubit.instance.logout();
    Go.offAll(const LoginScreen());
  }
}

class UserUnblockedYou implements NotificationNavigation {
  const UserUnblockedYou();

  @override
  void navigate({required Map<String, dynamic> data}) {
    //لازم اعرف هو individual ولا parent
    // Go.to();
  }
}

