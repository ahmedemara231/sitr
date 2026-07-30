import 'package:multiple_result/multiple_result.dart';
import 'package:pagify/helpers/data_and_pagination_data.dart';
import '../../../config/res/config_imports.dart';
import '../../../core/base_crud/code/domain/usecases/pagination_response.dart';
import '../../../core/error/failure.dart';
import '../../../core/extensions/error_handler_extension.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_request.dart';
import '../../../core/network/network_service.dart';
import 'models/notification_model.dart';

class NotificationsData{
  static Future<(List<NotificationModel>, PaginationData)> getNotifications(int page)async{
    return (await injector<NetworkService>().callApi(
        NetworkRequest(
          method: RequestMethod.get,
          path: ApiConstants.getNotifications,
          queryParameters: {'page' : page},
        ),
      mapper: (json) => (
          (json['notifications']['data'] as List)
              .map((e) => NotificationModel.fromJson(e))
              .where(
                (notification) =>
                    FeatureFlags.isWalletAvailable ||
                    notification.type != 'wallet_charged',
              )
              .toList(),
          PaginationData(
              perPage: json['notifications']['pagination']['per_page'],
              totalPages: json['notifications']['pagination']['total_pages']
          ),
      )
    )).data;
  }

  static Future<Result<BaseModel, Failure>> deleteNotification(String id)async{
   return await injector<NetworkService>().callApi(
        NetworkRequest(
            method: RequestMethod.delete,
            path: ApiConstants.deleteNotification+id,
        ),
    ).handleCallbackWithFailure();
  }

  static Future<Result<BaseModel, Failure>> deleteAllNotification()async{
   return await injector<NetworkService>().callApi(
      NetworkRequest(
          method: RequestMethod.delete,
          path: ApiConstants.deleteAllNotification
      ),
    ).handleCallbackWithFailure();
  }
}
