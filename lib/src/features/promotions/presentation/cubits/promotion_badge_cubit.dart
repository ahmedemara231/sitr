import '../../../../config/language/languages.dart';
import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../data/models/promotion_badge_model.dart';

class PromotionBadgeCubit extends AsyncCubit<PromotionBadgeDataModel> {
  PromotionBadgeCubit() : super(const PromotionBadgeDataModel.initial());

  Future<void> getPromotionBadge({required bool isPromoted}) async {
    if (!UserModel.isAuthenticated) return;

    final String endpoint =
        isPromoted ? ApiConstants.promotedBadge : ApiConstants.promotionBadge;
    await executeAsyncWithBaseModel(
      operation: () => baseCrudUseCase.call(
        CrudBaseParmas(
          api: endpoint,
          httpRequestType: HttpRequestType.get,
          cacheKey: '${endpoint}_${Languages.currentLanguage.languageCode}',
          mapper: PromotionBadgeDataModel.fromJson,
          fromCacheJson: PromotionBadgeDataModel.fromJson,
          toJson: (model) => model.toJson(isPromoted: isPromoted),
        ),
      ),
    );
  }
}
