import '../../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../models/complaint_details_model.dart';

class ComplaintDetailsCubit extends AsyncCubit<ComplaintDetailsModel?> {
  ComplaintDetailsCubit() : super(null);

  Future<void> fetchComplaintDetails(int complaintId) async {
    await executeAsync(
      operation: () async =>
          await baseCrudUseCase.call<ComplaintDetailsModel>(CrudBaseParmas(
        api: '${ApiConstants.complaintDetails}$complaintId',
        httpRequestType: HttpRequestType.get,
        mapper: (data) => ComplaintDetailsModel.fromJson(data),
      )),
    );
  }
}
