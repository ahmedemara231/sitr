import '../../../config/language/languages.dart';
import '../../../core/notification/notification_service.dart';

class OtpBody{
  final String phone;
  final String code;

  OtpBody({
    required this.phone,
    required this.code,
  });

  Map<String, dynamic> toJson() => {
    'iso' : 'SA',
    'country_code' : '+966',
    'device_type' : 'ios',
    'device_id' : NotificationService.deviceToken,
    'lang' : Languages.currentLanguage.languageCode,
    'phone' : phone,
    'code' : code
  };
}