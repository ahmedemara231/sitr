import 'package:pagify/helpers/data_and_pagination_data.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../config/res/config_imports.dart';
import '../../../core/base_crud/code/domain/usecases/pagination_response.dart';
import '../../../core/error/failure.dart';
import '../../../core/extensions/error_handler_extension.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_request.dart';
import '../../../core/network/network_service.dart';
import '../../chats/data/models/chat_model.dart';
import 'models/message_request_model.dart';

class MessageRequestsData {
  static Future<(List<MessageRequestModel>, PaginationData)> getMessageRequests(
      int page) async {
    return (await injector<NetworkService>().callApi(
      NetworkRequest(
        method: RequestMethod.get,
        path: ApiConstants.messageRequests,
        queryParameters: {'page': page},
      ),
      mapper: (json) {
        final Map<String, dynamic> requests = Map<String, dynamic>.from(
          json['message_requests'] as Map? ?? <String, dynamic>{},
        );
        final List<dynamic> items =
            requests['data'] as List<dynamic>? ?? <dynamic>[];
        final Map<String, dynamic> pagination = Map<String, dynamic>.from(
          requests['pagination'] as Map? ?? <String, dynamic>{},
        );

        return (
          items
              .map(
                (item) => MessageRequestModel.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList(),
          PaginationData(
            perPage: _toInt(pagination['per_page'], fallback: 10),
            totalPages: _toInt(pagination['total_pages'], fallback: 1),
          ),
        );
      },
    ))
        .data;
  }

  static Future<Result<BaseModel<ChatModel>, Failure>> acceptMessageRequest(
    MessageRequestModel request,
  ) =>
      acceptMessageRequestFromSender(
        senderId: request.sender.id,
        messageRequestId: request.id,
      );

  static Future<Result<BaseModel<ChatModel>, Failure>>
      acceptMessageRequestFromSender({
    required int senderId,
    int? messageRequestId,
  }) async {
    return injector<NetworkService>()
        .callApi<ChatModel>(
          NetworkRequest(
            method: RequestMethod.post,
            path: ApiConstants.acceptMessageRequest,
            body: _actionBody(
              senderId: senderId,
              messageRequestId: messageRequestId,
            ),
          ),
          mapper: (json) => ChatModel.fromJson(json),
        )
        .handleCallbackWithFailure();
  }

  static Future<Result<BaseModel<bool>, Failure>> rejectMessageRequest(
    MessageRequestModel request,
  ) =>
      rejectMessageRequestFromSender(
        senderId: request.sender.id,
        messageRequestId: request.id,
      );

  static Future<Result<BaseModel<bool>, Failure>>
      rejectMessageRequestFromSender({
    required int senderId,
    int? messageRequestId,
  }) async {
    return injector<NetworkService>()
        .callApi<bool>(
          NetworkRequest(
            method: RequestMethod.post,
            path: ApiConstants.rejectMessageRequest,
            body: _actionBody(
              senderId: senderId,
              messageRequestId: messageRequestId,
            ),
          ),
          mapper: (_) => true,
        )
        .handleCallbackWithFailure();
  }

  static Map<String, dynamic> _actionBody({
    required int senderId,
    int? messageRequestId,
  }) =>
      {
        if (messageRequestId != null) 'message_request_id': messageRequestId,
        'sender_id': senderId,
      };

  static int _toInt(dynamic value, {required int fallback}) {
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
