import 'package:pagify/helpers/data_and_pagination_data.dart';
import '../../../config/res/config_imports.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_request.dart';
import '../../../core/network/network_service.dart';
import 'models/notification_model.dart';

class NotificationsData{
  static Future<(List<NotificationModel>, PaginationData)> getNotifications(int page)async{
    return (await injector<NetworkService>().callApi(
        NetworkRequest(
            method: RequestMethod.get,
            path: ApiConstants.getNotifications
        ),
      mapper: (json) => (
          (json['notifications']['data'] as List)
              .map((e) => NotificationModel.fromJson(e))
              .toList(),
          PaginationData(
              perPage: json['notifications']['pagination']['per_page'],
              totalPages: json['notifications']['pagination']['total_pages']
          ),
      )
    )).data;
  }
}