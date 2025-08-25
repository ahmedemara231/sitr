import 'package:flutter_base/src/core/shared/base_model.dart';
import 'package:flutter_base/src/core/shared/models/user_model.dart';

abstract interface class AuthDataSource {
  Future<BaseModel<UserModel>> login();
}
