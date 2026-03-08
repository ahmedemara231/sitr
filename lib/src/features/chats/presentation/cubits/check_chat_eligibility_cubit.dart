import 'package:flutter/material.dart';

import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../data/models/request_model.dart';

class CheckChatEligibilityCubit extends AsyncCubit<bool> {
  CheckChatEligibilityCubit() : super(false);

  Future<void> checkEligibility({
    required RequestModel requestModel,
    required VoidCallback onEligible,
  }) async {
    await executeAsyncWithBaseModel(
      operation: () => baseCrudUseCase.call(
        CrudBaseParmas(
          api: ApiConstants.checkChatEligibility,
          httpRequestType: HttpRequestType.post,
          body: requestModel.toJson(),
          mapper: (json) => json['can_start_chat'],
        ),
      ),
      onSuccess: (data) {
        if (data.data) onEligible();
      },
    );
  }
}
