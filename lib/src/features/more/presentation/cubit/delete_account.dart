import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/notification/notification_service.dart';

class DeleteAccountSafety {
  final bool value;
  final String? reason;

  const DeleteAccountSafety({
    required this.value,
    required this.reason,
  });

  factory DeleteAccountSafety.initial() =>
      const DeleteAccountSafety(value: false, reason: null);

  factory DeleteAccountSafety.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> safety =
        Map<String, dynamic>.from(json['is_safe'] as Map? ?? {});
    return DeleteAccountSafety(
      value: safety['value'] == true,
      reason: safety['reason']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'is_safe': {
          'value': value,
          'reason': reason,
        },
      };

  DeleteAccountSafety copyWith({
    bool? value,
    String? reason,
  }) =>
      DeleteAccountSafety(
        value: value ?? this.value,
        reason: reason ?? this.reason,
      );
}

class DeleteAccountReason {
  final int id;
  final String title;
  final String? description;
  final bool isOther;

  const DeleteAccountReason({
    required this.id,
    required this.title,
    this.description,
    this.isOther = false,
  });

  factory DeleteAccountReason.fromJson(Map<String, dynamic> json) {
    final String title =
        _readString(json, ['text', 'title', 'name', 'reason', 'value']) ?? '';
    return DeleteAccountReason(
      id: _readInt(json['id'] ?? json['value']) ?? 0,
      title: title,
      description:
          _readString(json, ['description', 'desc', 'body', 'subtitle']),
      isOther: json['is_other'] == true || json['type'] == 'other',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': title,
        'description': description,
        'is_other': isOther,
      };

  static int? _readInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  static String? _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }
    return null;
  }
}

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
      list = map['reasons'] ??
          map['delete_account_reasons'] ??
          map['delete_acc_reasons'] ??
          map['data'];
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
