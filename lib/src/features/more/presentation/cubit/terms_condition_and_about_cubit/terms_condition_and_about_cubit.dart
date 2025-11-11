import '../../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/network/api_endpoints.dart';

class TermsConditionAndAboutCubit  extends AsyncCubit<String>  {
  TermsConditionAndAboutCubit():super('');

  Future<void>fetchTermsAndConditions({required StaticPageType staticPageType})async{
    await executeAsyncWithBaseModel(
        operation: () async => await baseCrudUseCase.call<String>(
              CrudBaseParmas(
                  api:staticPageType.name,
                  httpRequestType: HttpRequestType.get,
                  mapper: (data)=>data
              )
          )
    );
  }

}


enum StaticPageType { terms, about }
