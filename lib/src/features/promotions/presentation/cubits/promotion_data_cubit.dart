import '../../../../config/language/languages.dart';
import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../data/models/promotion_data_model.dart';

class PromotionDataCubit extends AsyncCubit<PromotionDataModel> {
  PromotionDataCubit() : super(PromotionDataModel.initial());

  Future<void> getPromotionData() async {
    if(!UserModel.isAuthenticated) return;
    await executeAsyncWithBaseModel(
      operation: () => baseCrudUseCase.call(
        CrudBaseParmas(
          api: ApiConstants.promotionData,
          httpRequestType: HttpRequestType.get,
          cacheKey:
              '${ApiConstants.promotionData}_${Languages.currentLanguage.languageCode}',
          mapper: PromotionDataModel.fromJson,
          fromCacheJson: PromotionDataModel.fromJson,
          toJson: (model) => model.toJson(),
        ),
      ),
    );
  }
}
