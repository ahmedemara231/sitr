part of 'notification_service.dart';

class NotificationRoutes {

  static void navigateByType(Map<String, dynamic> data) {
    final String type = data['type'];
    log('the type is ${data['type']}');
    final NotificationType notificationType = type.getType;
    log('the type is $notificationType');
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

class WalletNavigation implements NotificationNavigation {
  const WalletNavigation();

  @override
  void navigate({required Map<String, dynamic> data}) {
    Go.toOrOff(const WalletScreen());
  }
}
class NoNavigation implements NotificationNavigation {
  const NoNavigation();

  @override
  void navigate({required Map<String, dynamic> data}) {}
}

// class FinishedChatNavigation implements NotificationNavigation {
//   const FinishedChatNavigation();
//
//   @override
//   void navigate({required Map<String, dynamic> data}) {
//     Go.toOrOff(PreviousChatScreen(
//         chatType: (data['chat_status'] as String).getChatType,
//         requestModel: RequestModel(
//             receiverId: (_getUserId(data)).toString(),
//             fromHome: 0.toString()
//         )
//     ));
//   }
// }

class ProfileNavigation implements NotificationNavigation {
  const ProfileNavigation();

  @override
  void navigate({required Map<String, dynamic> data}) {
    Go.toOrOff(const ProfileScreen());
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

class ContactUsNavigation implements NotificationNavigation {
  const ContactUsNavigation();

  @override
  void navigate({required Map<String, dynamic> data}) {
    Go.toOrOff(const ContactUsChatScreen());
  }
}

// ----------------- Complaints -----------------
class ComplaintNavigation implements NotificationNavigation {
  const ComplaintNavigation();

  @override
  void navigate({required Map<String, dynamic> data}) {
    Go.toOrOff(ComplaintDetailsScreen(
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
    final UserType type = (data['visitor_type'] as String).toUserType();
    final userId = data['visitor_id'];

    _routeToProfile(type: type, userId: userId.toString());
  }
}

// ----------------- Match Requests / Chat -----------------
String _getUserName(Map<String, dynamic> data) => data['user_name'] ?? data['sender_name'];
String _getUserId(Map<String, dynamic> data) => (data['user_id'] ?? data['sender_id']).toString();
class MatchRequestNavigation implements NotificationNavigation {
  const MatchRequestNavigation();

  @override
  void navigate({required Map<String, dynamic> data}) {
    final chatType = (data['chat_status'] as String).getChatType;
    if(chatType.isCurrent){
      Go.toOrOff(
          ChatScreen(
              requestModel: RequestModel(
                  receiverId: (_getUserId(data)).toString(),
                  fromHome: 0.toString()
              ),
              receiverName: _getUserName(data)
          )
      );

    }else{
      Go.toOrOff(PreviousChatScreen(
          chatType: (data['chat_status'] as String).getChatType,
          requestModel: RequestModel(
              receiverId: (_getUserId(data)).toString(),
              fromHome: 0.toString()
          )
      ));
    }
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
    Go.toOrOff(const MyPackagesScreen());
  }
}

class PackageExpiredNavigation implements NotificationNavigation {
  const PackageExpiredNavigation();

  @override
  void navigate({required Map<String, dynamic> data}) {
    Go.toOrOff(const MyPackagesScreen());
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
    final UserType type = (data['user_type'] as String).toUserType();
    final userId = _getUserId(data);

    _routeToProfile(type: type, userId: userId.toString());
  }
}

class AdminActionWithChild implements NotificationNavigation {
  const AdminActionWithChild();

  @override
  void navigate({required Map<String, dynamic> data}) {
    Go.toOrOff(const ParentChildrenView());
  }
}


void _routeToProfile({
  required UserType type,
  required String userId,
}){
  if(type!.isParent){
    Go.toOrOff(ParentDetailsScreen(id: int.parse(userId)));
  }else{
    Go.toOrOff(
        IndividualDetailsScreen.opportunity(id: int.parse(userId))
    );
  }
}