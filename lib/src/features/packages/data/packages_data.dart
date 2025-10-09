import 'package:pagify/helpers/data_and_pagination_data.dart';

import '../../../config/res/config_imports.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_request.dart';
import '../../../core/network/network_service.dart';
import '../../../core/shared/models/user_models/user_model.dart';
import '../models/package.dart';

class PackagesData{
  static String _getEndPoint(){
    if(UserModel.isParent){
      return ApiConstants.getPackages+ApiConstants.family;

    }else{
      return ApiConstants.getPackages+ApiConstants.individual;
    }
  }

 static Future<(List<Package>, PaginationData)> getPackages()async{
  return (await injector<NetworkService>().callApi(
        NetworkRequest(
            method: RequestMethod.get,
            path: _getEndPoint(),
        ),

      mapper: (json) => (
      (json['data'] as List)
          .map((e) => Package.fromJson(e))
          .toList(),
      PaginationData(
          perPage: json['pagination']['per_page'],
          totalPages: json['pagination']['total_pages']
      )),
    )).data;
  }

}