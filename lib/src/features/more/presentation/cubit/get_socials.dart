import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/social.dart';

class GetSocialsCubit extends AsyncCubit<List<Social>>{
  GetSocialsCubit() : super([]);

  Future<void> getSocials()async{
    executeAsyncWithBaseModel(
        operation: () => baseCrudUseCase.call(
          CrudBaseParmas(
            api: ApiConstants.socials,
            httpRequestType: HttpRequestType.get,
            mapper: (json) => (json as List)
                .map((e) => Social.fromJson(e))
                .toList()
          ),
        ),
    );
  }
}