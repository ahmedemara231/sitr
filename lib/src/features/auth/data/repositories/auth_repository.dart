import 'package:flutter_base/src/core/error/failure.dart';
import 'package:flutter_base/src/core/shared/base_model.dart';
import 'package:flutter_base/src/core/shared/models/user_model.dart';
import 'package:multiple_result/multiple_result.dart';

abstract interface class AuthRepository {
  Future<Result<BaseModel<UserModel>, Failure>> getAuth();
}
