import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/notification/notification_service.dart';
import '../models/delete_account_reason.dart';
import '../models/delete_account_safety.dart';

class DeleteAccountReasonsCubit extends AsyncCubit<List<DeleteAccountReason>> {
  DeleteAccountReasonsCubit() : super([]);

  Future<void> getReasons() async {
    await executeAsyncWithBaseModel(
      operation: () => baseCrudUseCase.call(
        CrudBaseParmas(
          api: ApiConstants.showDeleteAccReasons,
          httpRequestType: HttpRequestType.get,
          mapper: (json) => _mapReasons(json),
        ),
      ),
    );
  }

  List<DeleteAccountReason> _mapReasons(dynamic json) {
    final dynamic list;
    if (json is List) {
      list = json;
    } else if (json is Map) {
      final map = Map<String, dynamic>.from(json);
      list = map['data'];
    } else {
      list = [];
    }

    return (list as List? ?? [])
        .whereType<Map>()
        .map((reason) => DeleteAccountReason.fromJson(
              Map<String, dynamic>.from(reason),
            ))
        .where((reason) => reason.id > 0 && reason.title.isNotEmpty)
        .toList();
  }
}

class DeleteAccountCubit extends AsyncCubit<dynamic> {
  DeleteAccountCubit() : super(null);

  Future<void> checkSafetyAndDeleteAccount({
    required void Function(String msg) onSuccess,
    required void Function(String reason) onUnsafe,
    DeleteAccountReason? reason,
    String? customReason,
  }) async {
    DeleteAccountSafety? safety;
    await executeAsyncWithBaseModel(
      operation: () => baseCrudUseCase.call<DeleteAccountSafety>(
        CrudBaseParmas<DeleteAccountSafety>(
          api: ApiConstants.deleteSafety,
          httpRequestType: HttpRequestType.get,
          mapper: (json) => DeleteAccountSafety.fromJson(
            Map<String, dynamic>.from(json as Map),
          ),
        ),
      ),
      onSuccess: (data) => safety = data.data,
    );

    if (safety == null) return;
    if (!safety!.value) {
      onUnsafe(safety!.reason ?? '');
      return;
    }

    await _deleteAccount(
      onSuccess: onSuccess,
      reason: reason,
      customReason: customReason,
    );
  }

  Future<void> _deleteAccount({
    required void Function(String msg) onSuccess,
    DeleteAccountReason? reason,
    String? customReason,
  }) async {
    final String? reasonText =
        customReason?.trim().isEmpty == true ? null : customReason?.trim();
    await executeAsyncWithBaseModel(
        operation: () => baseCrudUseCase.call(CrudBaseParmas(
                api: ApiConstants.deleteAccount,
                httpRequestType: HttpRequestType.post,
                body: {
                  'device_id': NotificationService.deviceToken,
                  if (reasonText != null)
                    'reason': reasonText
                  else if (reason != null)
                    'reason_id': reason.id,
                })),
        onSuccess: (data) => onSuccess.call(data.msg));
  }
}
