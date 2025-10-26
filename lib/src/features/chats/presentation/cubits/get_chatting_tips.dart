import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';

class ChattingTipsCubit extends AsyncCubit<List<String>>{
  ChattingTipsCubit() : super([]);

  Future<void> getChattingTips()async{
    await executeAsync(
      operation: () => baseCrudUseCase.call(
        CrudBaseParmas(
            api: ApiConstants.chattingStageTips,
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