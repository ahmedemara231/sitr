import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../packages/models/package.dart';

class MyPackageCubit extends AsyncCubit<List<Package>>{
  MyPackageCubit() : super([]);

  Future<void> getMyPackage()async{
    executeAsyncWithBaseModel(
        operation: () => baseCrudUseCase.call(
          CrudBaseParmas(
            api: ApiConstants.myPackage,
            httpRequestType: HttpRequestType.get,
            mapper: (json) => (json as List)
                .map((e) => Package.fromJson(e))
                .toList(),
          ),
        ),
    );
  }
}