import 'dart:async';
import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/network/api_endpoints.dart';

enum Phase{sendOld, sendNew, checkOld, checkNew}

extension Check on Phase{
  bool get isSendCode => this == Phase.sendOld || this == Phase.sendNew;
  bool get isCheckCode => this == Phase.checkOld || this == Phase.checkNew;
}

class ChangePhoneManagerCubit extends AsyncCubit{
  ChangePhoneManagerCubit() : super(null);

  String _getEndPoint(Phase phase){
    switch(phase){
      case Phase.sendOld:
        return ApiConstants.sendCodeToOldPhone;

      case Phase.sendNew:
        return ApiConstants.sendCodeToNewPhone;

        case Phase.checkOld:
        return ApiConstants.checkCodeToOldPhone;

      case Phase.checkNew:
        return ApiConstants.checkCodeToNewPhone;
    }
  }

  Map<String, dynamic> _getBody(Phase phase, {String? phone, String? code}) => phase.isSendCode ?
  {
    'phone' : phone,
  } :
  {
    'code' : code,
    'phone' : phone
  };

  Future<void> manage({
    required Phase phase,
    String? phone, String? code,
    FutureOr<void> Function(String msg)? onSuccess
})async{
    await executeAsyncWithBaseModel(
        operation: () async => await baseCrudUseCase.call(
            CrudBaseParmas(
                api: _getEndPoint(phase),
                httpRequestType: HttpRequestType.post,
                body: _getBody(phase, phone: phone, code: code),
            )
        ),
        onSuccess: (data) => onSuccess?.call(data.msg)
    );
  }
}