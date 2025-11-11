import 'dart:async';
import 'dart:developer' show log;
import 'package:flutter/material.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/base_crud/code/domain/base_domain_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/network/network_service.dart';
import '../../../../../core/shared/base_state.dart';
import '../../../../../core/widgets/custom_messages.dart' show MessageUtils;
import '../../models/complaint_model.dart';

class FetchComplaintCubit extends AsyncCubit<List<ComplaintModel>>{
  FetchComplaintCubit():super([]){

    listenController();
  }


  int currentPage = 1;
  late  int totalPage;
  final ScrollController scrollController = ScrollController();

  Future<void> fetchComplaint() async {
    if (state.isLoading || state.isLoadingMore) return;
    final isFirstPage = currentPage == 1;

    if (isFirstPage) {
      setLoading();
    } else {
      setLoadingMore();
    }

    final result = await baseCrudUseCase<List<ComplaintModel>>(
      CrudBaseParmas(
        api: ApiConstants.complaints,
        queryParameters: {
          'page': currentPage,
          'paginate': 4,
        }..removeWhere((k, v) => v == null || v.toString().isEmpty),
        httpRequestType: HttpRequestType.get,
        mapper: (value) {
          // value contains the data field which has pagination and data
          if (value is Map && value.containsKey('pagination')) {
            totalPage = value['pagination']['total_pages'];
            final consultants = (value['data'] as List)
                .map((item) => ComplaintModel.fromJson(item))
                .toList();
            return consultants;
          } else {
            // Fallback if structure is different
            final consultants = (value as List)
                .map((item) => ComplaintModel.fromJson(item))
                .toList();
            return consultants;
          }
        },
      ),
    );

    result.when(
          (baseModelResponse) {
        // Extract data from BaseModel
        setSuccess(data:isFirstPage? baseModelResponse.data:[...baseModelResponse.data,...state.data]);
        emit(state.copyWith(status: BaseStatus.success));
      },
          (error) {
        MessageUtils.showSnackBar(error.message);
        emit(state.copyWith(status: BaseStatus.error));
      },
    );
  }

  void listenController(){
    log('heelo');
    scrollController.addListener(_onScroll);

  }
  Timer? _debounce;
  void _onScroll() {
    log('_onScroll start work');
    if (_debounce?.isActive ?? false) return;
    _debounce = Timer(const Duration(milliseconds: 300), () {
      log('Fetching more...');
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100) {
        log('Reached near bottom');
        if (!state.isLoadingMore && currentPage <totalPage) {
          log('fetch more');
          currentPage++;
          fetchComplaint();
        }else{
          log('there is no data');

        }
      }
    });
  }
  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }



}