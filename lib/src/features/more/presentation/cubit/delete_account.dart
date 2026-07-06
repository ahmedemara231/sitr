import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/notification/notification_service.dart';

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
        _readString(json, ['title', 'name', 'reason', 'value', 'text']) ?? '';
    return DeleteAccountReason(
      id: _readInt(json['id'] ?? json['value']) ?? 0,
      title: title,
      description:
          _readString(json, ['description', 'desc', 'body', 'subtitle']),
      isOther: json['is_other'] == true ||
          json['type'] == 'other' ||
          title.toLowerCase().contains('other') ||
          title.contains('تاني') ||
          title.contains('آخر'),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
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
        .where((reason) => reason.title.isNotEmpty)
        .toList();
  }
}

class DeleteAccountCubit extends AsyncCubit<dynamic> {
  DeleteAccountCubit() : super(null);

  Future<void> deleteAccount({
    required void Function(String msg) onSuccess,
    DeleteAccountReason? reason,
    String? customReason,
  }) async {
    final String? reasonText =
        customReason?.trim().isEmpty == true ? null : customReason?.trim();
    await executeAsyncWithBaseModel(
        operation: () async => await baseCrudUseCase.call(CrudBaseParmas(
                api: ApiConstants.deleteAccount,
                httpRequestType: HttpRequestType.post,
                body: {
                  'device_id': NotificationService.deviceToken,
                  if (reason != null) 'reason_id': reason.id,
                  if (reasonText != null) 'reason': reasonText,
                })),
        onSuccess: (data) => onSuccess.call(data.msg));
  }
}
