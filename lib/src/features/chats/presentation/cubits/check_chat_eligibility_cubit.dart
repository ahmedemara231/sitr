import 'dart:async';

import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/shared/models/user_models/individual/individual_user_model.dart';
import '../../../../core/widgets/custom_messages.dart';
import '../../data/models/request_model.dart';

class CheckChatEligibilityCubit extends AsyncCubit<CanChat> {
  CheckChatEligibilityCubit({required CanChat initialCanChat})
      : super(initialCanChat);

  Future<void> checkEligibility({
    required RequestModel requestModel,
    required FutureOr<void> Function() onRequestSent,
  }) async {
    await executeAsyncWithBaseModel(
      operation: () => baseCrudUseCase.call<CanChat>(
        CrudBaseParmas<CanChat>(
          api: ApiConstants.checkChatEligibility,
          httpRequestType: HttpRequestType.post,
          body: requestModel.toJson(),
          mapper: (json) => CanChat.fromJson(json),
        ),
      ),
    );
    if (state.isError || !state.data.canChat) return;
    await _sendMessageRequest(
      requestModel: requestModel,
      onRequestSent: onRequestSent,
    );
  }

  Future<void> _sendMessageRequest({
    required RequestModel requestModel,
    required FutureOr<void> Function() onRequestSent,
  }) async {
    setLoading();
    final result = await baseCrudUseCase.call<CanChat>(
      CrudBaseParmas<CanChat>(
        api: ApiConstants.sendMessageRequest,
        httpRequestType: HttpRequestType.post,
        body: requestModel.toMessageRequestJson(),
        mapper: (json) => CanChat.fromJson(json),
      ),
    );

    final failure = result.tryGetError();
    if (failure != null) {
      MessageUtils.showTopMsg(failure.message);
      setError(errorMessage: failure.message);
      return;
    }

    final success = result.tryGetSuccess();
    if (success == null) return;
    setSuccess(success);
    await onRequestSent();
  }
}
