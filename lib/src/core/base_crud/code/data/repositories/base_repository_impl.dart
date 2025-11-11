part of '../base_data_imports.dart';

@LazySingleton(as: BaseRepository)
class BaseRepositoryImpl implements BaseRepository {
  final BaseRemoteDataSource baseRemoteDataSource;

  BaseRepositoryImpl({required this.baseRemoteDataSource});
  @override
  Future<Result<List<T>, Failure>> getBaseIdAndNameEntity<T extends BaseEntity>(
      GetBaseEntityParams? param) async {
    return await baseRemoteDataSource
        .getData<T>(param)
        .handleCallbackWithFailure();
  }

  @override
  Future<Result<BaseModel<T>, Failure>> crudCall<T>(CrudBaseParmas<T> params) async {
    return await baseRemoteDataSource
        .crudCall<T>(params)
        .handleCallbackWithFailure();
  }
}
