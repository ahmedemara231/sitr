import 'package:pagify/helpers/data_and_pagination_data.dart';
import '../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/widgets/custom_messages.dart';
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

    final String typeKey = type == UserGender.unknown ? 'parent' : type.name;
    // Each page gets its own cache key so offline pagination works per-page.
    final String pageCacheKey = 'opportunities_${typeKey}_$page';

    final result = await baseCrudUseCase.call(
      CrudBaseParmas(
        api: ApiConstants.opportunities,
        cacheKey: pageCacheKey,
        httpRequestType: HttpRequestType.get,
        queryParameters: {
          'type': type,
          'page': page,
        },
        mapper: (data) => (
          (data[typeKey]['data'] as List)
              .map((e) => OpportunityModel.fromJson(e))
              .toList(),
          PaginationData(
            perPage: data[typeKey]['pagination']['per_page'],
            totalPages: data[typeKey]['pagination']['total_pages'],
          ),
        ),
        fromCacheJson: (json) => (
          (json['items'] as List)
              .map((e) => OpportunityModel.fromJson(e as Map<String, dynamic>))
              .toList(),
          PaginationData(
            perPage: json['per_page'] as int,
            totalPages: json['total_pages'] as int,
          ),
        ),
        toJson: (tuple) => {
          'items': tuple.$1.map((e) => e.toJson()).toList(),
          'total_pages': tuple.$2.totalPages,
          'per_page': tuple.$2.perPage,
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
        if (isFirstPage) {
          // handleCallbackWithCache already attempted cache; nothing to fall back to.
          setError(errorMessage: failure.message);
        } else {
          // Page-specific cache was also empty. Keep the already-loaded items
          // visible and inform the user.
          emit(state.success(data: state.data));
          MessageUtils.showTopMsg(failure.message);
        }
      },
    );

    _isFetching = false;
  }
}
