
import 'dart:developer';

import '../../../../../config/res/config_imports.dart';
import '../../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/local_db/objectbox_cache_service.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/network/network_service.dart';

class FetchWalletCubit extends AsyncCubit<num>{
  FetchWalletCubit() : super(0);

  Future<void> fetchWallet()async{
      await executeAsyncWithBaseModel(
          operation: () async => await baseCrudUseCase.call<num>(
              CrudBaseParmas(
                api: ApiConstants.showWallet,
                httpRequestType: HttpRequestType.get,
                mapper: (json) => json['balance'],
                toJson: (data) => {'balance': data}
              )
          ),
      );
  }

}