import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../data/models/promotion_subscription_model.dart';

class PromotionSubscriptionCubit
    extends AsyncCubit<PromotionSubscriptionModel> {
  PromotionSubscriptionCubit()
      : super(const PromotionSubscriptionModel(link: ''));

  Future<String> subscribe({required int planId}) async {
    String link = '';
    await executeAsyncWithBaseModel(
      operation: () => baseCrudUseCase.call(
        CrudBaseParmas(
          api: ApiConstants.profilePromotionSubscribtion,
          httpRequestType: HttpRequestType.post,
          body: {
            'plan_id': planId,
          },
          mapper: PromotionSubscriptionModel.fromJson,
        ),
      ),
      onSuccess: (data) => link = data.data.link,
    );
    return link;
  }
}
