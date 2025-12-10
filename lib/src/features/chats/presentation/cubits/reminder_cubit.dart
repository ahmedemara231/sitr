import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../data/models/tip_model.dart';

class ReminderCubit extends AsyncCubit<TipModel>{
  ReminderCubit() : super(TipModel(title: 'title', tips: 'tips'));

  Future<void> getReminder()async{
    await executeAsyncWithBaseModel(
        operation: () => baseCrudUseCase.call(
          CrudBaseParmas(
            api: ApiConstants.istikharaReminder,
            httpRequestType: HttpRequestType.get,
            mapper: (json) => TipModel.fromJson(json),
          ),
        ),
    );
  }
}
