import '../../../core/notification/notification_service.dart';
import 'auth_body_static_data.dart';

class LoginBody{
  final String phone;

  LoginBody({required this.phone});

  Map<String, dynamic> toJson() => AuthBodyStaticData().toJson()..addAll({
    'device_id' : NotificationService.deviceToken,
    'phone' : phone,
  });
}