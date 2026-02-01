import 'package:pagify/helpers/data_and_pagination_data.dart';

import '../../../config/res/config_imports.dart';
import '../../../core/extensions/object.dart';
import '../../../core/helpers/user_type_enum.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_request.dart';
import '../../../core/network/network_service.dart';
import 'models/filter_model.dart';
import 'models/home_model.dart';

class HomeData{
  static Future<(List<Opportunity>, PaginationData)> filter(FilterModel filter, int page)async{
    return (await injector<NetworkService>().callApi(
        NetworkRequest(
          method: RequestMethod.get,
          path: ApiConstants.filter,
          queryParameters: filter.toJson()..addAll({
            'page' : page
          })
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

  static Future<(List<Opportunity>, PaginationData)> getParentChildren(int? parentId, page)async{
    return (await injector<NetworkService>().callApi(
        NetworkRequest(
            method: RequestMethod.get,
            path: parentId.isNull?
            ApiConstants.getChildren :
            ApiConstants.opportunityChildren+parentId.toString(),
            queryParameters: {'page' : page}
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

// Opportunities? opportunities
//   static Future<(List<OpportunityModel>, PaginationData)> getOpportunities(UserGender type, int page)async{
//     return (await injector<NetworkService>().callApi(
//         NetworkRequest(
//             method: RequestMethod.get,
//             path: ApiConstants.opportunities,
//             queryParameters: {
//               'type' : type,
//               'page' : page
//             }
//         ),
//         mapper: (data) {
//           final String selectedType = type == UserGender.unknown? 'parent' : type.name;
//           return (
//           (data[selectedType]['data'] as List)
//               .map((e) => OpportunityModel.fromJson(e))
//               .toList(),
//           PaginationData(
//               perPage: data[selectedType]['pagination']['per_page'],
//               totalPages: data[selectedType]['pagination']['total_pages']
//           ));
//         }
//     )).data;
//   }
}