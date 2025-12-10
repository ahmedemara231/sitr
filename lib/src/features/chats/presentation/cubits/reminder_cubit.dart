import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';

class ReminderCubit extends AsyncCubit<String>{
  ReminderCubit() : super('');

  Future<void> getReminder()async{
    await executeAsyncWithBaseModel(
        operation: () => baseCrudUseCase.call(
          CrudBaseParmas(
            api: ApiConstants.istikharaReminder,
            httpRequestType: HttpRequestType.post,
            mapper: (json) => json,
          ),
        ),
    );
  }
}