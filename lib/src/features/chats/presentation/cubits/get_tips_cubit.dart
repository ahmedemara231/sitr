import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';

class GetTipsCubit extends AsyncCubit<List<String>>{
  GetTipsCubit() : super([]);

  Future<void> getTips(String path)async{
    await executeAsync(
      operation: () => baseCrudUseCase.call(
        CrudBaseParmas(
            api: path,
            httpRequestType: HttpRequestType.get,
            mapper: (data) => (data as String)
                .split('\n\n')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList()
        ),
      ),
    );
  }
}