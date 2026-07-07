import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../data/models/promotion_plans_model.dart';

class PromotionPlansCubit extends AsyncCubit<PromotionPlansModel> {
  PromotionPlansCubit() : super(PromotionPlansModel.initial());

  Future<void> getPromotionPlans() async {
    await executeAsyncWithBaseModel(
      operation: () => baseCrudUseCase.call(
        CrudBaseParmas(
          api: ApiConstants.profilePromotionPlans,
          httpRequestType: HttpRequestType.get,
          mapper: PromotionPlansModel.fromJson,
        ),
      ),
    );
  }
}
