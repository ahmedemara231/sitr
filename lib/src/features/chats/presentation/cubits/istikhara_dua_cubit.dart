import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../data/models/tip_model.dart';

class IstikharaDuaCubit extends AsyncCubit<TipModel>{
  IstikharaDuaCubit() : super(TipModel(title: 'title', tips: 'tips'));

  Future<void> get()async{
    await executeAsyncWithBaseModel(
      operation: () => baseCrudUseCase.call(
        CrudBaseParmas(
            api: ApiConstants.istikharaDua,
            httpRequestType: HttpRequestType.get,
            mapper: (json) => TipModel.fromJson(json)
        ),
      ),
    );
  }
}