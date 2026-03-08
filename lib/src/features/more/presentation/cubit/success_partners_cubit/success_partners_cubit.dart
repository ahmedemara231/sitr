import '../../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../models/success_partners_model.dart';

class SuccessPartnersCubit extends AsyncCubit<List<SuccessPartnersModel>> {
  SuccessPartnersCubit() : super([]);

  Future<void> fetchSuccessPartners() async {
    await executeAsyncWithBaseModel(
        operation: () async => await baseCrudUseCase
                .call(CrudBaseParmas(
              api: ApiConstants.successPartners,
              httpRequestType: HttpRequestType.get,
              cacheKey: 'success_partners',
              mapper: (data) => (data as List)
                  .map<SuccessPartnersModel>((e) => SuccessPartnersModel.fromJson(e))
                  .toList(),
              fromCacheJson: (json) => (json['data'] as List)
                  .map<SuccessPartnersModel>((e) => SuccessPartnersModel.fromJson(e))
                  .toList(),
              toJson: (data) => {'data': data.map((e) => e.toJson()).toList()},
            )));
  }
}
