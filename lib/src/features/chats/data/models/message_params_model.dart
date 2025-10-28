import '../../../../config/language/languages.dart';
import '../../../../core/notification/notification_service.dart';
import '../../../../core/shared/models/user_models/user_model.dart';

class MessageParamsModel{
  // final int userId;
  // final String userType;
  // final String lang;
  // final String name;
  // final String deviceType;
  // final String deviceId;
  // final String avatar;
  //
  // MessageParamsModel({
  //   required this.userId,
  //   required this.userType,
  //   required this.lang,
  //   required this.name,
  //   required this.deviceType,
  //   required this.deviceId,
  //   required this.avatar,
  // });

  MessageParamsModel();

// https://str-sa.com:4866/?userId=1&userType=user&lang=ar&name=Adam&deviceType=ios&deviceId=cU0GQb7P_g6Td_Zy6x7nHN:APA91bHfP_H03_7lSMLZWW1w18SSg74XShz_WflZZGOoX7uBkeYuHUWuV53EPBSJ_Sls4nTfTT1bZPMWw9IJybyetPRYUqG2GaSTPT4YoyRWlYie9UdXy2s&avatar=https://res.cloudinary.com/demo/image/upload/w_400,h_300,c_fill/sample.jpg
  Map<String, dynamic> toJson() => {
    'userId' : UserModel.currentUser?.id,
    'userType' : 'user',
    'name' : UserModel.currentUser?.name,
    'lang' : Languages.currentLanguage.languageCode,
    'deviceType' : 'ios',
    'deviceId' : NotificationService.deviceToken,
    'avatar' : UserModel.currentUser?.avatar,
  };
}