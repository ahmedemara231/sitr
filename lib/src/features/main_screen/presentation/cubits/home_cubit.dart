import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../data/models/home_model.dart';

class MainViewCubit extends AsyncCubit<HomeModel>{
  MainViewCubit() : super(HomeModel());
  
  Future<void> getHomeData()async{
    await executeAsyncWithBaseModel(
      // enableInternetInterceptor: true,
      operation: () => baseCrudUseCase.call(
          CrudBaseParmas(
            api: ApiConstants.home,
            httpRequestType: HttpRequestType.get,
            mapper: (json) => HomeModel.fromJson(json),
          )
        ),
    );
  }
}