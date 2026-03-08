import '../base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import 'models/user_models/individual/individual_user_model.dart';
import 'models/user_models/user_model.dart';

abstract class GetUserModelCubit extends AsyncCubit<UserModel>{
  GetUserModelCubit() : super(IndividualUserModel.initial());

  Future<void> getProfile({required void Function(UserModel data) onSuccess});
}