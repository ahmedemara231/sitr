import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../data/models/tip_model.dart';

class GetTipsCubit extends AsyncCubit<TipModel>{
  GetTipsCubit() : super(TipModel(title: 'title', tips: 'tips'));

  Future<void> getTips(String path)async{
    await executeAsyncWithBaseModel(
      operation: () => baseCrudUseCase.call(
        CrudBaseParmas(
            api: path,
            httpRequestType: HttpRequestType.get,
            mapper: (json) => TipModel.fromJson(json)
        ),
      ),
    );
  }
}