import 'package:pagify/helpers/data_and_pagination_data.dart';

import '../../../config/res/config_imports.dart';
import '../../../core/extensions/object.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_request.dart';
import '../../../core/network/network_service.dart';
import 'models/home_model.dart';

class HomeData{
  static Future<(List<Opportunity>, PaginationData)> getParentChildren(int? parentId)async{
    return (await injector<NetworkService>().callApi(
        NetworkRequest(
          method: RequestMethod.get,
          path: parentId.isNull?
          ApiConstants.getChildren :
          ApiConstants.opportunityChildren+parentId.toString(),
        ),
        mapper: (data) => (
            (data['data'] as List)
                .map((e) => Opportunity.fromJson(e))
                .toList(),
        PaginationData(
            perPage: data['pagination']['per_page'],
            totalPages: data['pagination']['total_pages']
        ),
        )
    )).data;
  }
}