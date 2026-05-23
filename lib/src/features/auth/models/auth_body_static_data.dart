import '../../../core/helpers/helpers.dart';

class AuthBodyStaticData{
  Map<String, dynamic> toJson() => {
    'iso' : 'SA',
    'country_code' : '+966',
    'device_type' : Helpers.deviceType,
  };
}