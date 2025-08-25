import 'package:equatable/equatable.dart';

import '../../../../core/shared/base_state.dart';

final class AuthState extends Equatable {
  final BaseStatus baseStatus;
  final String msg;

  const AuthState({
    required this.baseStatus,
    this.msg = '',
  });

  factory AuthState.initial() => const AuthState(
    baseStatus: BaseStatus.initial,
  );

  AuthState copyWith({
    BaseStatus? baseStatus,
    String? msg,
  }) => AuthState(
    baseStatus: baseStatus ?? this.baseStatus,
    msg: msg ?? this.msg,
  );

  @override
  List<Object?> get props => [
    baseStatus,
    msg,
  ];
}
