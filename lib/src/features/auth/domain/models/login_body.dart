import '../../../../core/notification/notification_service.dart';

class LoginBody{
  final String phone;
  final String countryCode;
  final String iso;

  LoginBody({
    required this.phone,
    required this.countryCode,
    required this.iso,
  });

  Map<String, dynamic> toJson() => {
    'device_id' : NotificationService.deviceToken,
    'device_type' : 'ios',
    'phone' : phone,
    'iso' : iso,
    'country_code' : countryCode,
  };
}