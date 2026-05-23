import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';

class DeleteChildCubit extends AsyncCubit{
  DeleteChildCubit() : super(null);

  Future<void> execute({required int id, required void Function(String msg) onSuccess})async{
    await executeAsyncWithBaseModel(
        operation: () async => await baseCrudUseCase.call(
            CrudBaseParmas(
                api: ApiConstants.deleteChild+id.toString(),
                httpRequestType: HttpRequestType.delete,
            )
        ),
        onSuccess: (data) => onSuccess.call(data.msg)
    );
  }
}