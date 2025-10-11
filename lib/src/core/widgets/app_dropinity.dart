import 'dart:async';
import 'package:dropinity/custom_drop_down/dropinity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/helpers/data_and_pagination_data.dart';
import 'package:pagify/helpers/errors.dart';
import 'package:pagify/pagify.dart';
import '../../../generated/assets.dart';
import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../extensions/object.dart';
import '../extensions/padding_extension.dart';
import 'app_text.dart';
import 'svg_pic.dart';

typedef AppDropinityLocal<Model> = AppDropinity<void, Model>;

enum DropinityType{local, api}
class AppDropinity<FullResponse, Model> extends StatelessWidget {
  final double? listHeight;
  final DropinityType type;
  final String? hint;
  final String title;
  final String placeHolder;
  final List<Model>? values;
  final FutureOr<void> Function(Model value) onChanged;
  final Future<FullResponse> Function(BuildContext context, int page)? asyncCall;
  final String Function(Model element) getLabel;

  const AppDropinity({super.key,
    this.hint,
    this.listHeight,
    required this.placeHolder,
    required this.title,
    required this.values,
    required this.getLabel,
    required this.onChanged,
  }) : asyncCall = null, type = DropinityType.local;

  const AppDropinity.withApiRequest({
    super.key,
    this.hint,
    this.listHeight,
    required this.placeHolder,
    required this.title,
    required this.asyncCall,
    required this.getLabel,
    required this.onChanged,
}) : values = null, type = DropinityType.api;

  @override
  Widget build(BuildContext context) {
    switch(type){
      case DropinityType.local:
        return Dropinity<void, Model>(
          listHeight: listHeight,
          dropdownTitle: AppText(title, fontWeight: FontWeight.bold, fontSize: 11.sp),
          buttonData: ButtonData(
              hint: AppText(hint?? placeHolder, color: hint.isNull? Colors.grey : null, fontSize: 12.sp,),
              color: Colors.grey[50],
              buttonBorderRadius: ConstantManager.buttonBorderRadius,
              selectedItemWidget: (e) => AppText(getLabel.call(e!)),
              collapsedListIcon: const SvgPic(assetName: Assets.svgArrowDown)
          ),
          textFieldData: TextFieldData(
            onSearch: (pattern, e) => getLabel.call(e!).contains(pattern??''),
            suffixIcon: const Icon(Icons.search),
            title: LocaleKeys.search,
          ),
          onChanged: onChanged,
          values: values,
          valuesData: ValuesData(itemBuilder: (context, i, e) => AppText(
              getLabel.call(e),
              textAlign: TextAlign.start
          ).paddingBottom(5.h)),
        );

      default:
        return Dropinity<FullResponse, Model>.withApiRequest(
          listHeight: listHeight,
          dropdownTitle: AppText(title, fontWeight: FontWeight.bold, fontSize: 11.sp),
          buttonData: ButtonData(
              hint: AppText(hint?? placeHolder, color: hint.isNull? Colors.grey : null, fontSize: 12.sp,),
              color: Colors.grey[50],
              buttonBorderRadius: ConstantManager.buttonBorderRadius,
              selectedItemWidget: (e) => AppText(getLabel.call(e!)),
              collapsedListIcon: const SvgPic(assetName: Assets.svgArrowDown)
          ),
          textFieldData: TextFieldData(
            onSearch: (pattern, e) => getLabel.call(e!).contains(pattern??''),
            suffixIcon: const Icon(Icons.search),
            title: LocaleKeys.search,
          ),
          onChanged: onChanged,
          pagifyData: SearchableDropdownPagifyData(
            controller: PagifyController(),
            asyncCall: asyncCall!,
            mapper: (response) => PagifyData(
                data: response as List<Model>,
                paginationData: PaginationData(
                  totalPages: 1,
                  perPage: 10,
                )
            ),
            errorMapper: PagifyErrorMapper(
                errorWhenDio: (e) {
                  final String? msg = e.response?.data['msg'];
                  return PagifyApiRequestException(
                    msg ?? 'network error occur',
                    pagifyFailure: RequestFailureData(
                      statusCode: e.response?.statusCode,
                      statusMsg: e.response?.statusMessage,
                    ),
                  );
                } // if you using Dio

            ),
            itemBuilder: (context, data, index, element) => AppText(
                getLabel.call(element),
                textAlign: TextAlign.start
            ).paddingBottom(5.h),
          ),
        );
    }
  }
}
