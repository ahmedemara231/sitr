import '../../../config/res/config_imports.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_request.dart';
import '../../../core/network/network_service.dart';
import 'models/chat_model.dart';

class ChatsData{
  static Future<ChatModel> getChatMessages({
    required int receiverId,
    required int fromHome,
  })async{
    return (await injector<NetworkService>().callApi(
          NetworkRequest(
            method: RequestMethod.post,
            path: ApiConstants.startChat,
            body: {
              "receiver_id": receiverId.toString(),
              "from_home": fromHome.toString(),
            },
          ),
          mapper: (data) => ChatModel.fromJson(data)
      )).data;
  }
}