import '../../../../config/language/languages.dart';
import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../data/models/promotion_sheet_model.dart';

class PromotionSheetCubit extends AsyncCubit<PromotionSheetDataModel> {
  PromotionSheetCubit() : super(const PromotionSheetDataModel.initial());

  Future<void> getPromotionSheet() async {
    if (!UserModel.isAuthenticated) return;

    await executeAsyncWithBaseModel(
      operation: () => baseCrudUseCase.call(
        CrudBaseParmas(
          api: ApiConstants.promotionSheet,
          httpRequestType: HttpRequestType.get,
          cacheKey:
              '${ApiConstants.promotionSheet}_${Languages.currentLanguage.languageCode}',
          mapper: PromotionSheetDataModel.fromJson,
          fromCacheJson: PromotionSheetDataModel.fromJson,
          toJson: (model) => model.toJson(),
        ),
      ),
    );
  }
}
