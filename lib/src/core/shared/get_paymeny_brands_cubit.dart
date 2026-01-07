import 'dart:async';

import '../base_crud/code/domain/base_domain_imports.dart';
import '../base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../extensions/num.dart';
import '../network/api_endpoints.dart';
import 'models/payment_brand.dart';

class PaymentBrands extends AsyncCubit<List<PaymentBrand>>{
  PaymentBrands() : super([]);

  Future<void> get({required void Function(List<PaymentBrand> data) onSuccess})async{
    await executeAsyncWithBaseModel(
        operation: () async => await baseCrudUseCase.call(
            CrudBaseParmas(
              api: ApiConstants.getPaymentBrands,
              httpRequestType: HttpRequestType.get,
              mapper: (json) => (json as List).map((e) => PaymentBrand.fromJson(e)).toList()
            )
        ),

      onSuccess: (data) => onSuccess.call(data.data)
    );
  }
}