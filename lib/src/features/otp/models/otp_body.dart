import '../../../config/language/languages.dart';
import '../../../core/notification/notification_service.dart';
import '../../auth/models/auth_body_static_data.dart';

class OtpBody{
  final String phone;
  final String code;

  OtpBody({
    required this.phone,
    required this.code,
  });

  Map<String, dynamic> toJson() => AuthBodyStaticData().toJson()..addAll({
    'lang' : Languages.currentLanguage.languageCode,
    'phone' : phone,
    'code' : code,
    'device_id' : '1111'
    // 'device_id' : NotificationService.deviceToken
  });
}