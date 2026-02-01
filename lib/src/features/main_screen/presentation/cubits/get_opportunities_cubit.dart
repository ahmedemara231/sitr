/*
*   static Future<(List<OpportunityModel>, PaginationData)> getOpportunities(UserGender type, int page)async{
    return (await injector<NetworkService>().callApi(
        NetworkRequest(
            method: RequestMethod.get,
            path: ApiConstants.opportunities,
            queryParameters: {
              'type' : type,
              'page' : page
            }
        ),
        mapper: (data) {
          final String selectedType = type == UserGender.unknown? 'parent' : type.name;
          return (
          (data[selectedType]['data'] as List)
              .map((e) => OpportunityModel.fromJson(e))
              .toList(),
          PaginationData(
              perPage: data[selectedType]['pagination']['per_page'],
              totalPages: data[selectedType]['pagination']['total_pages']
          ));
        }
    )).data;
  }*/

import 'package:pagify/helpers/data_and_pagination_data.dart';
import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../data/models/home_model.dart';

class GetOpportunitiesCubit extends AsyncCubit<(List<OpportunityModel>, PaginationData)>{
  GetOpportunitiesCubit() : super(([], PaginationData(perPage: 0, totalPages: 0)));

  Future<void> getOpportunities({required UserGender type, required int page}) async {
    await executeAsyncWithBaseModel(
        operation: () => baseCrudUseCase.call(
          CrudBaseParmas(
            api: ApiConstants.opportunities,
            httpRequestType: HttpRequestType.get,
              queryParameters: {
                'type' : type,
                'page' : page
              },
              mapper: (data) {
                final String selectedType = type == UserGender.unknown? 'parent' : type.name;
                return (
                (data[selectedType]['data'] as List)
                    .map((e) => OpportunityModel.fromJson(e))
                    .toList(),
                PaginationData(
                    perPage: data[selectedType]['pagination']['per_page'],
                    totalPages: data[selectedType]['pagination']['total_pages']
                ));
              }
          ),
        ),
    );
  }
}