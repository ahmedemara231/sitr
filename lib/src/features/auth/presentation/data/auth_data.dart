import 'package:flutter/cupertino.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/network_request.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../models/kinship.dart';

class AuthData{
  static UserType currentUser = UserType.unknown;
  static Future<List<CityModel>> getCities()async{
    List<CityModel> citiesList = [];
    await injector<NetworkService>().callApi(
        NetworkRequest(
            method: RequestMethod.get,
            path: ApiConstants.cities,
        ),
        mapper: (data) {
          citiesList =  (data as List)
              .map((e) => CityModel.fromJson(e))
              .toList();
        }
    );
    return citiesList;
  }

  static Future<List<Kinship>> getKinships()async{
    List<Kinship> kinshipsList = [];
    await injector<NetworkService>().callApi(
        NetworkRequest(
          method: RequestMethod.get,
          path: ApiConstants.relations,
        ),
        mapper: (data) {
          kinshipsList =  (data as List)
              .map((e) => Kinship.fromJson(e))
              .toList();
        }
    );

    return kinshipsList;
  }

  static ValueNotifier<ChildrenNumber> childrenNumber = ValueNotifier(ChildrenNumber());
}

class ChildrenNumber {
  int maleNumbers;
  int femaleNumbers;

  void increment(UserType user){
    if(user.isFemale){
      femaleNumbers++;
    }else{
      maleNumbers++;
    }
  }

  int get total => maleNumbers + femaleNumbers;

  ChildrenNumber({
    this.maleNumbers = 0,
    this.femaleNumbers = 0,
  });
}
