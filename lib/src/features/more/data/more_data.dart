import 'package:pagify/helpers/data_and_pagination_data.dart';

import '../../../config/res/config_imports.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_request.dart';
import '../../../core/network/network_service.dart';
import '../presentation/models/block_user_model.dart';
import '../presentation/models/complaint_model.dart';

class MoreData {
  static Future<(List<BlockUserModel>, PaginationData)> getBlockedUsers(int page) async {
    return (await injector<NetworkService>().callApi(
      NetworkRequest(
        method: RequestMethod.get,
        path: ApiConstants.blockUser,
        queryParameters: {'page' : page}
      ),
      mapper: (json) => (
      (json['data'] as List)
          .map((e) => BlockUserModel.fromJson(e))
          .toList(),
      PaginationData(
          perPage: json['pagination']['per_page'],
          totalPages: json['pagination']['total_pages']
      )
      )
    )).data;
  }

  static Future<(List<ComplaintModel>, PaginationData)> getComplaints(int page) async {
    return (await injector<NetworkService>().callApi(
        NetworkRequest(
            method: RequestMethod.get,
            path: ApiConstants.complaints,
            queryParameters: {'page' : page}
        ),
        mapper: (json) => (
        (json['data'] as List)
            .map((e) => ComplaintModel.fromJson(e))
            .toList(),
        PaginationData(
            perPage: json['pagination']['per_page'],
            totalPages: json['pagination']['total_pages']
        )
        )
    )).data;
  }
}
