import '../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../core/network/api_endpoints.dart';
import 'models/intro_model.dart';

class IntroCubit extends AsyncCubit<List<IntroModel>>{
  IntroCubit() : super([]);

  Future<void> getIntros()async{
    await executeAsyncWithBaseModel(
        operation: () async => await baseCrudUseCase.call(
            CrudBaseParmas(
                api: ApiConstants.introPages,
                httpRequestType: HttpRequestType.get,
                mapper: (data) => (data as List)
                    .map((e) => IntroModel.fromJson(e))
                    .toList()
            )
        ),
    );
  }
}