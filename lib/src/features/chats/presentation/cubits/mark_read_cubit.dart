import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';

class MarkReadCubit extends AsyncCubit {
  MarkReadCubit() : super(null);

  Future<void> markRead(int roomId) async {
    await executeAsyncWithBaseModel(
      operation: () => baseCrudUseCase.call(
        CrudBaseParmas(
          api: 'room/$roomId/${ApiConstants.markRead}',
          httpRequestType: HttpRequestType.post,
        ),
      ),
    );
  }
}
