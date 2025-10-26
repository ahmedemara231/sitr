import '../../../config/res/config_imports.dart';
import '../../../core/network/network_request.dart';
import '../../../core/network/network_service.dart';
import 'models/chat_model.dart';

class ChatsData{
  static late final ChatModel chatModel;
  static Future<ChatModel> getChats(String path, {required int receiverId, required int fromHome})async{
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

    return chatModel;
  }
}