import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/shared/base_state.dart';
import '../../data/models/auth_model.dart';
import '../../data/repositories/auth_repository.dart';
import './auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repo;

  AuthCubit(this.repo) : super(AuthState.initial()) {
    loadAuth();
  }

  Future<void> loadAuth() async {
    emit(state.copyWith(baseStatus: BaseStatus.loading));
      final result = await repo.getAuth();
      result.when((data) => emit(
              state.copyWith(
                  baseStatus: BaseStatus.success,
              )),
              (error) => emit(
                  state.copyWith(
                      baseStatus: BaseStatus.error,
                      msg: error.message
                  ))
          );
  }
}
