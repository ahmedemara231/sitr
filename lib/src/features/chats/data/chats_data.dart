import 'dart:async';
import '../../../config/res/config_imports.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_request.dart';
import '../../../core/network/network_service.dart';

import 'models/chat_model.dart';
import 'models/request_model.dart';

class ChatsData{
  static Future<ChatModel> getChatMessages({
    required RequestModel requestModel
  })async{
    return (await injector<NetworkService>().callApi(
          NetworkRequest(
            method: RequestMethod.post,
            path: ApiConstants.startChat,
            body: requestModel.toJson()
          ),
          mapper: (data) => ChatModel.fromJson(data)
      )).data;
  }
}