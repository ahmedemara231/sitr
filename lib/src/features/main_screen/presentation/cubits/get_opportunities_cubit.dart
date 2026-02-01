import 'package:pagify/helpers/data_and_pagination_data.dart';
import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../data/models/home_model.dart';

class GetOpportunitiesCubit extends AsyncCubit<(List<OpportunityModel>, PaginationData)>{
  GetOpportunitiesCubit() : super(([], PaginationData(perPage: 0, totalPages: 0)));

  int _currentPage = 0;
  bool _isFetching = false;

  bool get canLoadMore => _currentPage < state.data.$2.totalPages;

  Future<void> getOpportunities({required UserGender type, required int page}) async {
    if (_isFetching) return;
    _isFetching = true;

    final isFirstPage = page == 1;
    if (isFirstPage) {
      _currentPage = 0;
      setLoading();
    } else {
      setLoadingMore();
    }

    final result = await baseCrudUseCase.call(
      CrudBaseParmas(
        api: ApiConstants.opportunities,
        httpRequestType: HttpRequestType.get,
        queryParameters: {
          'type': type,
          'page': page,
        },
        mapper: (data) {
          final String selectedType = type == UserGender.unknown ? 'parent' : type.name;
          return (
            (data[selectedType]['data'] as List)
                .map((e) => OpportunityModel.fromJson(e))
                .toList(),
            PaginationData(
              perPage: data[selectedType]['pagination']['per_page'],
              totalPages: data[selectedType]['pagination']['total_pages'],
            ),
          );
        },
      ),
    );

    result.when(
      (success) {
        _currentPage = page;
        final previousItems = isFirstPage ? <OpportunityModel>[] : state.data.$1;
        setSuccess(data: ([...previousItems, ...success.data.$1], success.data.$2));
      },
      (failure) {
        setError(errorMessage: failure.message);
      },
    );

    _isFetching = false;
  }

  void resetPagination() {
    _currentPage = 0;
    _isFetching = false;
  }
}