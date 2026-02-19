part of 'notification_service.dart';

class NotificationRoutes {

  static void navigateByType(Map<String, dynamic> data) {
    final String type = data['type'];
    log('the type is ${data['type']}');
    final NotificationType notificationType = type.getType;
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

class NoNavigation implements NotificationNavigation {
  const NoNavigation();

  @override
  void navigate({required Map<String, dynamic> data}) {}
}


class HomeNavigation implements NotificationNavigation {
  const HomeNavigation();

  @override
  void navigate({required Map<String, dynamic> data}) {
    Go.offAll(const HomeScreen());
  }
}

class FinishedChatNavigation implements NotificationNavigation {
  const FinishedChatNavigation();

  @override
  void navigate({required Map<String, dynamic> data}) {
    final tabIndex = (data['chat_status'] as String).getChatType.index;
    Go.off(ChatsScreen(key: chatsKey));
    chatsKey.currentState!..changeChatsType(LocaleKeys.previousChats)
      ..tabController.animateTo(tabIndex);
  }
}

class ProfileNavigation implements NotificationNavigation {
  const ProfileNavigation();

  @override
  void navigate({required Map<String, dynamic> data}) {
    Go.to(const ProfileScreen());
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
        complaintId: (data['complaint_id']) is String?
        int.parse(data['complaint_id']) : data['complaint_id']
    ));
  }
}

// ----------------- User Profile -----------------
class UserProfileNavigation implements NotificationNavigation {
  const UserProfileNavigation();

  @override
  void navigate({required Map<String, dynamic> data}) {
    final UserType type = (data['visitor_type'] as String).toUserType()!;
    final userId = data['visitor_id'];

    _routeToProfile(type: type, userId: userId.toString());
  }
}

// ----------------- Match Requests / Chat -----------------
class MatchRequestNavigation implements NotificationNavigation {
  const MatchRequestNavigation();

  @override
  void navigate({required Map<String, dynamic> data}) {
    Go.to(
        ChatScreen(
          // showFullChat: ,
            requestModel: RequestModel(
                receiverId: (data['sender_id']).toString(),
                fromHome: 0.toString()
            ),
            receiverName: data['user_name']
        )
    );
  }
}

class NotificationsNavigation implements NotificationNavigation {
  const NotificationsNavigation();

  @override
  void navigate({required Map<String, dynamic> data}) {
    return;
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
class LoginNavigation implements NotificationNavigation {
  const LoginNavigation();

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
    final UserType type = (data['user_type'] as String).toUserType()!;
    final userId = data['user_id'];

    _routeToProfile(type: type, userId: userId.toString());
  }
}

class AdminActionWithChild implements NotificationNavigation {
  const AdminActionWithChild();

  @override
  void navigate({required Map<String, dynamic> data}) {
    Go.to(const ParentChildrenView());
  }
}


void _routeToProfile({
  required UserType type,
  required String userId,
}){
  if(type!.isParent){
    Go.to(ParentDetailsScreen(id: int.parse(userId)));

  }else{
    Go.to(
        IndividualDetailsScreen.opportunity(id: int.parse(userId))
    );
  }
}