// import 'package:pagify/helpers/data_and_pagination_data.dart';
// import '../../../config/res/config_imports.dart';
// import '../../../core/network/network_request.dart';
// import '../../../core/network/network_service.dart';
// import 'models/chat_model.dart';
//
// class ChatsData{
//   static Future<(List<ChatModel>, PaginationData)> getChats(String path)async{
//       List<ChatModel> chats = [];
//       await injector<NetworkService>().callApi(
//           NetworkRequest(
//             method: RequestMethod.get,
//             path: path,
//           ),
//           mapper: (data) {
//             chats =  (data as List)
//                 .map((e) => ChatModel.fromJson(e))
//                 .toList();
//           }
//       );
//       return chats;
//   }
// }