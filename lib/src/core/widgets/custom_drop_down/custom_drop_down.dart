import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/pagify.dart';
import '../../extensions/context_extension.dart';
import '../../extensions/object.dart';
import '../../extensions/padding_extension.dart';
import '../app_text.dart';
import '../text_fields/default_text_field.dart';
import 'dart:async';
import 'package:pagify/helpers/data_and_pagination_data.dart';
import 'package:pagify/helpers/errors.dart';
import 'package:pagify/helpers/status_stream.dart';

part 'models/main_button.dart';
part 'models/pagify_list.dart';
part 'models/text_field.dart';
part 'models/values_data.dart';

enum _DropdownType{withRequest, none}
class SearchableDropdown<FullResponse, Model> extends StatelessWidget {
  final double? listHeight;
  final _DropdownType _dropdownType;
  final ButtonData buttonData;
  final TextFieldData<Model> textFieldData;

  final SearchableDropdownPagifyData<FullResponse, Model>? pagifyData;

  final List<Model>? values;
  final ValuesData<Model>? valuesData;

  SearchableDropdown.withApiRequest({
    super.key,
    this.listHeight,
    required this.buttonData,
    required this.textFieldData,
    required this.pagifyData,
  }) : values = null,
        valuesData = null,
        _dropdownType = _DropdownType.withRequest;

  SearchableDropdown({
    super.key,
    this.listHeight,
    required this.buttonData,
    required this.textFieldData,
    required this.values,
    required this.valuesData,
  }) : pagifyData = null,
        _dropdownType = _DropdownType.none;


  Model? selectedValue;

  void _selectNewElement(Model element){
    selectedValue = element;
    _changePagifyVisibility();
  }

  late List<Model> _fullValuesData;
  late ValueNotifier<List<Model>> _localValues;

  void _init(){
    if(_dropdownType == _DropdownType.none){
      _fullValuesData = List.from(values!);
      _localValues = ValueNotifier(List.from(values!));
    }
  }

  void _executeSearchLogic(String pattern) {
    if(pattern.isEmpty){
      _localValues.value = List.from(_fullValuesData);

    }else{
      _localValues.value = _fullValuesData.where(
              (e) => textFieldData.onSearch.call(pattern, e)
      ).toList();
    }
  }

  final ValueNotifier<bool> _openDataList = ValueNotifier(false);
  void _changePagifyVisibility() => _openDataList.value = !_openDataList.value;
  ValueNotifier<bool> isInitialized = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    _init();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: (){
            isInitialized.value = true;
            _changePagifyVisibility();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: buttonData.buttonBorderRadius?? BorderRadius.circular(12),
              border: Border.all(color: buttonData.buttonBorderColor?? Colors.grey[300]!),
              color: buttonData.color?? Colors.white,
            ),
            padding: buttonData.padding?? const EdgeInsets.all(12),
            width: buttonData.buttonWidth,
            height: buttonData.buttonHeight,
            child: ValueListenableBuilder(
              valueListenable: _openDataList,
              builder: (context, val, child) => Row(
                children: [
                  if(selectedValue.isNull)
                    AppText(buttonData.initialValue?? 'select item')
                  else
                    buttonData.selectedItemWidget(selectedValue),

                  const Spacer(),

                  if(val)
                    buttonData.expandedListIcon?? Icon(Icons.arrow_drop_up, color: Colors.grey[400])
                  else
                    buttonData.collapsedListIcon?? Icon(Icons.arrow_drop_down, color: Colors.grey[400])
                ],
              ),
            ),
          ),
        ),

        ValueListenableBuilder(
          valueListenable: isInitialized,
          builder: (context, val, child) => val? ValueListenableBuilder(
              valueListenable: _openDataList,
              builder: (context, isOpen, child) => Visibility(
                visible: isOpen,
                maintainState: true,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  color: Colors.white,
                  child: Column(
                    children: [
                      DefaultTextField(
                          title: textFieldData.title,
                          prefixIcon: textFieldData.prefixIcon,
                          suffixIcon: textFieldData.suffixIcon,
                          borderRadius: textFieldData.borderRadius,
                          borderColor: textFieldData.borderColor,
                          contentPadding: textFieldData.contentPadding,
                          controller: textFieldData.controller,
                          fillColor: textFieldData.fillColor,
                          maxLength: textFieldData.maxLength,
                          style: textFieldData.style,
                          onChanged: (v) {
                            if(_dropdownType == _DropdownType.none){
                              _executeSearchLogic(v ?? '');
                              return;
                            }

                            if(v.isNull || v!.isEmpty){
                              pagifyData!.controller.assignToFullData();
                              return;
                            }

                            pagifyData!.controller.filterAndUpdate(
                                    (e) => textFieldData.onSearch.call(v, e)
                            );
                          }
                      ),

                      SizedBox(
                        height: listHeight?? 250,
                        child: _dropdownType == _DropdownType.none?
                        ValueListenableBuilder(
                          valueListenable: _localValues,
                          builder: (context, val, child) => ListView(
                            children: List.generate(
                              val.length,
                                  (i) => InkWell(
                                  onTap: () => _selectNewElement(val[i]),
                                  child: valuesData!.itemBuilder.call(context, i, val[i])
                              ),
                            ),
                          ).paddingAll(10.r),
                        ) :
                        Pagify<FullResponse, Model>.listView(
                          shrinkWrap: true,
                          controller: pagifyData!.controller,
                          asyncCall: pagifyData!.asyncCall,
                          mapper: pagifyData!.mapper,
                          errorMapper: pagifyData!.errorMapper,
                          itemBuilder: (context, data, index, element) => InkWell(
                              onTap: () => _selectNewElement(element),
                              child: pagifyData!.itemBuilder(context, data, index, element)
                          ),
                          errorBuilder: pagifyData!.errorBuilder,
                          loadingBuilder: pagifyData!.loadingBuilder,
                          padding: pagifyData!.padding,
                          itemExtent: pagifyData!.itemExtent,
                          onUpdateStatus: pagifyData!.onUpdateStatus,
                          onLoading: pagifyData!.onLoading,
                          onSuccess: pagifyData!.onSuccess,
                          onError: pagifyData!.onError,
                          emptyListView: pagifyData!.emptyListView,
                          showNoDataAlert: true,
                          ignoreErrorBuilderWhenErrorOccursAndListIsNotEmpty: true,
                          noConnectionText: pagifyData!.noConnectionText,
                        ).paddingAll(10.r),
                      ),
                    ],
                  ),
                ),
              )
          ) : const SizedBox.shrink(),
        )


          // if(_dropdownType == _DropdownType.withRequest)
          //   ValueListenableBuilder(
          //     valueListenable: isInitialized,
          //     builder: (context, val, child) => val? ValueListenableBuilder(
          //         valueListenable: _openDataList,
          //         builder: (context, isOpen, child) => Visibility(
          //           visible: isOpen,
          //           maintainState: true,
          //           child: AnimatedContainer(
          //             duration: const Duration(milliseconds: 250),
          //             curve: Curves.easeInOut,
          //             color: Colors.white,
          //             child: Column(
          //               children: [
          //                 DefaultTextField(
          //                     title: textFieldData.title,
          //                     prefixIcon: textFieldData.prefixIcon,
          //                     suffixIcon: textFieldData.suffixIcon,
          //                     borderRadius: textFieldData.borderRadius,
          //                     borderColor: textFieldData.borderColor,
          //                     contentPadding: textFieldData.contentPadding,
          //                     controller: textFieldData.controller,
          //                     fillColor: textFieldData.fillColor,
          //                     maxLength: textFieldData.maxLength,
          //                     style: textFieldData.style,
          //                     onChanged: (v) {
          //                       if(v.isNull || v!.isEmpty){
          //                         pagifyData!.controller.assignToFullData();
          //                         return;
          //                       }
          //
          //                       pagifyData!.controller.filterAndUpdate(
          //                               (e) => textFieldData.onSearch.call(v, e)
          //                       );
          //                     }
          //                 ),
          //                 SizedBox(
          //                   height: listHeight?? 250,
          //                   child: Pagify<FullResponse, Model>.listView(
          //                     shrinkWrap: true,
          //                     controller: pagifyData!.controller,
          //                     asyncCall: pagifyData!.asyncCall,
          //                     mapper: pagifyData!.mapper,
          //                     errorMapper: pagifyData!.errorMapper,
          //                     itemBuilder: (context, data, index, element) => InkWell(
          //                         onTap: () => _selectNewElement(element),
          //                         child: pagifyData!.itemBuilder(context, data, index, element)
          //                     ),
          //                     errorBuilder: pagifyData!.errorBuilder,
          //                     loadingBuilder: pagifyData!.loadingBuilder,
          //                     padding: pagifyData!.padding,
          //                     itemExtent: pagifyData!.itemExtent,
          //                     onUpdateStatus: pagifyData!.onUpdateStatus,
          //                     onLoading: pagifyData!.onLoading,
          //                     onSuccess: pagifyData!.onSuccess,
          //                     onError: pagifyData!.onError,
          //                     emptyListView: pagifyData!.emptyListView,
          //                     showNoDataAlert: true,
          //                     ignoreErrorBuilderWhenErrorOccursAndListIsNotEmpty: true,
          //                     noConnectionText: pagifyData!.noConnectionText,
          //                   ).paddingAll(10.r),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         )
          //     ) : const SizedBox.shrink(),
          // )
          // else
          //   ValueListenableBuilder(
          //       valueListenable: _openDataList,
          //       builder: (context, isOpen, child) => Visibility(
          //         visible: isOpen,
          //         maintainState: true,
          //         child: AnimatedContainer(
          //           duration: const Duration(milliseconds: 250),
          //           curve: Curves.easeInOut,
          //           color: Colors.white,
          //           child: Column(
          //             children: [
          //               DefaultTextField(
          //                   title: textFieldData.title,
          //                   prefixIcon: textFieldData.prefixIcon,
          //                   suffixIcon: textFieldData.suffixIcon,
          //                   borderRadius: textFieldData.borderRadius,
          //                   borderColor: textFieldData.borderColor,
          //                   contentPadding: textFieldData.contentPadding,
          //                   controller: textFieldData.controller,
          //                   fillColor: textFieldData.fillColor,
          //                   maxLength: textFieldData.maxLength,
          //                   style: textFieldData.style,
          //                   onChanged: (v) {
          //                     if(v.isNull || v!.isEmpty){
          //                       pagifyData!.controller.assignToFullData();
          //                       return;
          //                     }
          //
          //                     pagifyData!.controller.filterAndUpdate(
          //                             (e) => textFieldData.onSearch.call(v, e)
          //                     );
          //                   }
          //               ),
          //               SizedBox(
          //                 height: listHeight?? 250,
          //                 child: ListView(
          //                   children: List.generate(
          //                     values!.length,
          //                         (i) => InkWell(
          //                         onTap: () => _selectNewElement(values![i]),
          //                         child: valuesData!.itemBuilder.call(context, i, values![i])
          //                     ),
          //                   ),
          //                 ).paddingAll(10.r),
          //               ),
          //             ],
          //           ),
          //         ),
          //       )
          //   ),
      ],
    );
  }
}