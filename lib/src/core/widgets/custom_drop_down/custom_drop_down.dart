import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/helpers/data_and_pagination_data.dart';
import 'package:pagify/helpers/errors.dart';
import 'package:pagify/helpers/status_stream.dart';
import 'package:pagify/pagify.dart';
import '../../extensions/object.dart';
import '../../extensions/padding_extension.dart';
import '../app_text.dart';
import '../text_fields/default_text_field.dart';

class CustomDropDownButtonPagifyData<FullResponse, Model>{
  final PagifyController<Model> controller;
  Future<FullResponse> Function(BuildContext context, int page) asyncCall;
  PagifyData<Model> Function(FullResponse response) mapper;
  PagifyErrorMapper errorMapper;
  Widget Function(BuildContext context, List<Model> data, int index, Model element) itemBuilder;
  EdgeInsetsGeometry padding = EdgeInsets.zero;
  double? itemExtent;
  FutureOr<void> Function(PagifyAsyncCallStatus)? onUpdateStatus;

  FutureOr<void> Function()? onLoading;
  FutureOr<void> Function(BuildContext, List<dynamic>)? onSuccess;
  FutureOr<void> Function(BuildContext, int,  PagifyException)? onError;

  bool ignoreErrorBuilderWhenErrorOccursAndListIsNotEmpty;
  bool showNoDataAlert = false;
  Widget? loadingBuilder;
  Widget Function(PagifyException)? errorBuilder;
  Widget? emptyListView;
  String? noConnectionText;

  CustomDropDownButtonPagifyData({
    required this.asyncCall,
    required this.mapper,
    required this.errorMapper,
    required this.itemBuilder,
    required this.controller,
    this.padding = const EdgeInsets.all(0),
    this.itemExtent,
    this.onUpdateStatus,
    this.onLoading,
    this.onSuccess,
    this.onError,
    this.ignoreErrorBuilderWhenErrorOccursAndListIsNotEmpty = true,
    this.showNoDataAlert = false,
    this.loadingBuilder,
    this.errorBuilder,
  });
}

class CustomDropDownButton<FullResponse, Model> extends StatelessWidget {
  final CustomDropDownButtonPagifyData<FullResponse, Model> customDropDownButtonPagifyData;
  final double buttonHeight;
  final double buttonWidth;
  final BorderRadius? btnBorderRadius;
  final Color? btnBorderColor;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final String? initialValue;
  final double? listHeight;
  final Widget Function(Model selectedElement) selectedItemWidget;
  final bool Function(String? pattern, Model? data) onSearch;

  // const CustomDropDownButton({super.key});

  CustomDropDownButton.withSearch({
    super.key,
    required this.customDropDownButtonPagifyData,
    required this.selectedItemWidget,
    required this.onSearch,
    this.initialValue,
    this.buttonHeight = 50,
    this.buttonWidth = double.infinity,
    this.padding,
    this.color,
    this.btnBorderColor,
    this.btnBorderRadius,
    this.listHeight = 300,
  });

  List<Model?> fullDataList = [];
  Model? selectedValue;

  final ValueNotifier<bool> openPagify = ValueNotifier(false);
  final ValueNotifier<bool> collapse = ValueNotifier(false);

  void start() {
    collapse.value = false;
    if(fullDataList.isEmpty){
      openPagify.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: start,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: btnBorderRadius?? BorderRadius.circular(12),
              border: Border.all(color: btnBorderColor?? Colors.grey[300]!),
              color: color?? Colors.white,
            ),
            padding: padding?? const EdgeInsets.all(12),
            width: buttonWidth,
            height: buttonHeight,
            child: ValueListenableBuilder(
              valueListenable: collapse,
              builder: (context, val, child) => Row(
                children: [
                  if(selectedValue.isNull)
                    AppText(initialValue?? 'select item')
                  else
                    selectedItemWidget(selectedValue!),

                  const Spacer(),
                  Icon(Icons.arrow_drop_down, color: Colors.grey[400])
                ],
              ),
            ),
          ),
        ),

        ValueListenableBuilder(
            valueListenable: openPagify,
            builder: (context, startNow, child) => startNow? ValueListenableBuilder(
              valueListenable: collapse,
              builder: (context, collapseNow, child) => Visibility(
                visible: !collapseNow,
                maintainState: true,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  color: Colors.white,
                  child: Column(
                    children: [
                      DefaultTextField(
                        onChanged: (v) {
                          if(v.isNull || v!.isEmpty){
                            customDropDownButtonPagifyData.controller.assignToFullData();
                            return;
                          }

                          customDropDownButtonPagifyData.controller.filterAndUpdate(
                                  (e) => onSearch.call(v, e)
                          );
                        }
                      ),
                      SizedBox(
                        height: listHeight,
                        child: Pagify<FullResponse, Model>.listView(
                          shrinkWrap: true,
                          controller: customDropDownButtonPagifyData.controller,
                          asyncCall: customDropDownButtonPagifyData.asyncCall,
                          mapper: customDropDownButtonPagifyData.mapper,
                          errorMapper: customDropDownButtonPagifyData.errorMapper,
                          itemBuilder: (context, data, index, element) => InkWell(
                              onTap: () {
                                selectedValue = element;
                                collapse.value = true;
                              },
                              child: customDropDownButtonPagifyData.itemBuilder(context, data, index, element)
                          ),
                          errorBuilder: customDropDownButtonPagifyData.errorBuilder,
                          loadingBuilder: customDropDownButtonPagifyData.loadingBuilder,
                          padding: customDropDownButtonPagifyData.padding,
                          itemExtent: customDropDownButtonPagifyData.itemExtent,
                          onUpdateStatus: customDropDownButtonPagifyData.onUpdateStatus,
                          onLoading: customDropDownButtonPagifyData.onLoading,
                          onSuccess: (context, data){
                            fullDataList = List.from(data);
                            customDropDownButtonPagifyData.onSuccess?.call(context, data);
                          },
                          onError: customDropDownButtonPagifyData.onError,
                          emptyListView: customDropDownButtonPagifyData.emptyListView,
                          showNoDataAlert: true,
                          ignoreErrorBuilderWhenErrorOccursAndListIsNotEmpty: true,
                          noConnectionText: customDropDownButtonPagifyData.noConnectionText,
                        ).paddingAll(10.r),
                      ),
                    ],
                  ),
                ),
              ),
            ) : const SizedBox.shrink()
        ),
      ],
    );
  }
}