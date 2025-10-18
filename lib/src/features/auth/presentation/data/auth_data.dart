import 'package:flutter/cupertino.dart';

import '../../../../config/res/config_imports.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/network_request.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../models/kinship.dart';

class ChildrenNumber {
  final int maleNumbers;
  final int femaleNumbers;

  int get total => maleNumbers + femaleNumbers;

  ChildrenNumber({
    this.maleNumbers = 0,
    this.femaleNumbers = 0,
  });

  ChildrenNumber copyWith({
    int? maleNumbers,
    int? femaleNumbers,
  }) => ChildrenNumber(
    maleNumbers: maleNumbers??this.maleNumbers,
    femaleNumbers: femaleNumbers??this.femaleNumbers,
  );
}

class AuthData{
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
  static void inc(UserType user) => childrenNumber.value.copyWith(
    maleNumbers: user.isMale? childrenNumber.value.maleNumbers + 1 : childrenNumber.value.maleNumbers,
    femaleNumbers: user.isFemale? childrenNumber.value.femaleNumbers + 1 : childrenNumber.value.femaleNumbers
  );
}