import '../../../../config/language/locale_keys.g.dart';

enum DeleteAccountUnsafeReason {
  hasActivePackage('has_active_package'),
  hasLiveChat('has_live_chat');

  final String value;

  const DeleteAccountUnsafeReason(this.value);

  static DeleteAccountUnsafeReason fromValue(String value) =>
      DeleteAccountUnsafeReason.values.firstWhere(
        (reason) => reason.value == value,
        orElse: () => DeleteAccountUnsafeReason.hasActivePackage,
      );
}

extension DeleteAccountUnsafeReasonMessage on DeleteAccountUnsafeReason {
  String get message {
    switch (this) {
      case DeleteAccountUnsafeReason.hasActivePackage:
        return LocaleKeys.cannotDeleteAccountWithBalance;
      case DeleteAccountUnsafeReason.hasLiveChat:
        return LocaleKeys.cannotDeleteAccountWithLiveChat;
    }
  }
}

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
      value: safety['value'] ?? false,
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
