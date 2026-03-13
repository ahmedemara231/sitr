import 'dart:async';
import '../../../config/res/config_imports.dart';
import '../../../core/extensions/string_extension.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_request.dart';
import '../../../core/network/network_service.dart';
import '../enums.dart';
import 'chat_actions/imports.dart';
import 'chat_actions/no_action.dart';
import 'models/chat_model.dart';
import 'models/request_model.dart';

class ChatsData{
  static ChatModel? data;
  static Future<ChatModel> getChatMessages({
    required RequestModel requestModel
  })async{
    data = (await injector<NetworkService>().callApi(
          NetworkRequest(
            method: RequestMethod.post,
            path: ApiConstants.startChat,
            body: requestModel.toJson()
          ),
          mapper: (data) => ChatModel.fromJson(data)
      )).data;

    final newList = data?.room?.messages?.data?.reversed.toList();

    return data!.copyWith(
      room: data?.room?.copyWith(
        messages: data?.room?.messages?.copyWith(
          data: newList
        ))
    );
  }

  static ChatActions manageSuccessState(ChatModel data, {
    required RequestModel requestModel,
  }) {
    final currentTips = data.matchRequest!.tipsPage!.currentStageTips;
    final userStatus = data.matchRequest!.userRequestStatus!.getUserRequestStatusAsEnum;
    final stage = data.matchRequest!.stage!.value!.getCurrentStageAsStagesEnum;

    if(!currentTips.isNoPage){
      return TipsAction(
          currentTips: currentTips,
          requestModel: requestModel,
      );
    }

    // acceptance - payment
    if(!userStatus.isUndefined){
      return UserStatusAction(
          data: data,
          requestModel: requestModel,
      );
    }

    // based stage
    if(!stage.isNewChat){
      return StageAction(
          data: data,
          requestModel: requestModel,
      );
    }

    return NoAction();
  }

  static Future<void> markRead(int roomId) async {
    await injector<NetworkService>().callApi(
      NetworkRequest(
        method: RequestMethod.post,
        path: 'room/$roomId/${ApiConstants.markRead}',
      ),
      mapper: (data) => data,
    );
  }

}