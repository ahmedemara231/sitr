import '../base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import 'models/user_models/user_model.dart';

abstract class GetUserModelCubit extends AsyncCubit<UserModel>{
  GetUserModelCubit() : super(UserModel.initial());

  Future<void> getUserModelData({required void Function(UserModel data) onSuccess});
}