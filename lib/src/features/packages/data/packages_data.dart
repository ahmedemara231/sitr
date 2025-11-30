import 'dart:developer';

import 'package:pagify/helpers/data_and_pagination_data.dart';

import '../../../config/res/config_imports.dart';
import '../../../core/extensions/object.dart';
import '../../../core/helpers/user_type_enum.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_request.dart';
import '../../../core/network/network_service.dart';
import '../../../core/shared/models/user_models/user_model.dart';
import '../models/package.dart';

class PackagesData{
  static String _selectEndPoint(bool Function() familyCondition){
    if(familyCondition.call()){
      return ApiConstants.getPackages+ApiConstants.family;

    }else{
      return ApiConstants.getPackages+ApiConstants.individual;
    }
  }

  static String _getEndPoint(UserType? userType){
    if(userType.isNull){
      return _selectEndPoint(() => UserModel.isParent);

    }else{
      return _selectEndPoint(() => userType!.isParent);
    }
  }

 static Future<(List<Package>, PaginationData)> getPackages({
   required int page,
   UserType? userType,
 })async{
  return (await injector<NetworkService>().callApi(
        NetworkRequest(
          method: RequestMethod.get,
          path: _getEndPoint(userType),
          queryParameters: {'page' : page}
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