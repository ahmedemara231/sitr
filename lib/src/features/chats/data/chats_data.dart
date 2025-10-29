import 'dart:developer';

import '../../../config/res/config_imports.dart';
import '../../../core/extensions/string_extension.dart';
import '../../../core/network/network_request.dart';
import '../../../core/network/network_service.dart';
import '../enums.dart';
import 'models/chat_model.dart';

class ChatsData{
  static ChatModel? chatModel;
  static Future<ChatModel> startChat(String path, {
    required int receiverId,
    required int fromHome,
    required void Function(ChatStages chatCurrentStage) onSuccess
  })async{
    chatModel = (await injector<NetworkService>().callApi(
          NetworkRequest(
            method: RequestMethod.post,
            path: path,
            body: {
              "receiver_id": receiverId.toString(),
              "from_home": fromHome.toString(),
            },
          ),
          mapper: (data) => ChatModel.fromJson(data)
      )).data;

    onSuccess.call(chatModel!.matchRequest!.stage!.value!.getCurrentStageAsStagesEnum);
    return chatModel!;
  }
}