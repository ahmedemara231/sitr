import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/shared/models/title_value_shape.dart';

class PersonalDataCubit extends AsyncCubit<List<TitleValueShape>>{
  PersonalDataCubit() : super([]);

  Future<void> getData(String path)async{
    await executeAsyncWithBaseModel(
      operation: () async => await baseCrudUseCase.call(
        CrudBaseParmas(
          api: path,
          httpRequestType: HttpRequestType.get,
          mapper: (json) => (json as List)
              .map((e) => TitleValueShape.fromJson(e))
              .toList()
        ),
      ),
    );
  }
}