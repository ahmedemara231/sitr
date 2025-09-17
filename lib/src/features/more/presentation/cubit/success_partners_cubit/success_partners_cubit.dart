import '../../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../models/success_partners_model.dart';

class SuccessPartnersCubit extends AsyncCubit<List<SuccessPartnersModel>> {
  SuccessPartnersCubit() : super([]);

  Future<void> fetchSuccessPartners() async {
    await executeAsync(
        operation: () async => await baseCrudUseCase
                .call<List<SuccessPartnersModel>>(CrudBaseParmas(
              api: ApiConstants.successPartners,
              httpRequestType: HttpRequestType.get,
              mapper: (data) {
                final list = data
                    .map<SuccessPartnersModel>(
                        (e) => SuccessPartnersModel.fromJson(e))
                    .toList();
                return list;
              },
            )));
  }
}
