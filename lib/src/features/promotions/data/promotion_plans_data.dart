import '../../../config/res/config_imports.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_request.dart';
import '../../../core/network/network_service.dart';
import 'models/promotion_plans_model.dart';

class PromotionPlansData {
  static Future<PromotionPlansPageModel> getPromotionPlans({
    required int page,
  }) async {
    final response = await injector<NetworkService>().callApi(
      NetworkRequest(
        method: RequestMethod.get,
        path: ApiConstants.promotionPlans,
        queryParameters: {'page': page},
      ),
      mapper: PromotionPlansPageModel.fromJson,
    );

    return response.data;
  }
}
