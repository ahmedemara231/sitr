import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/network/api_endpoints.dart';

class OathCubit extends AsyncCubit<String>{
  OathCubit() : super('');

  Future<void> getOath()async{
    await executeAsyncWithBaseModel(
        operation: () async => await baseCrudUseCase.call(
          CrudBaseParmas(
            api: ApiConstants.oath,
            httpRequestType: HttpRequestType.get,
          ),
        ),
    );
  }
}