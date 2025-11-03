// import 'dart:async';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// import '../../../core/extensions/string_extension.dart';
// import '../enums.dart';
//
// class ChatSheetManager{
//   static FutureOr<void> showBased(RemoteMessage notification){
//     final ChatStages stage = (notification.data['stage'] as String).getCurrentStageAsStagesEnum;
//
//     if(stage.isShariaComplaintMeeting){
//       // showDefaultBottomSheet(
//       //     child: TipsSheet(
//       //         title: LocaleKeys.tipsForShariaComplaintMeeting,
//       //         path: ApiConstants.shariaComplaintMeetingTips,
//       //         onConfirm: (context){}
//       //     )
//     }
//
//     _makeRequestSheet(
//       matchReqId: state.notification!.data[''],
//     );
//   }
// }