import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:pagify/helpers/data_and_pagination_data.dart';
import 'package:pagify/helpers/errors.dart';
import 'package:pagify/pagify.dart';
import 'package:pagify/widgets/text.dart';

import '../app_text.dart';
import 'custom_drop_down.dart';
class ExampleModel{
  List<String> items;
  int totalPages;

  ExampleModel({
    required this.items,
    required this.totalPages
  });
}


class CustomDropdownTest extends StatefulWidget {

  const CustomDropdownTest({super.key});

  @override
  State<CustomDropdownTest> createState() => _CustomDropdownTestState();
}

class _CustomDropdownTestState extends State<CustomDropdownTest> {
  Future<ExampleModel> _fetchData(int currentPage) async {
    await Future.delayed(const Duration(seconds: 2)); // simulate api call with current page
    final items = List.generate(25, (index) => 'Item $index');
    return ExampleModel(items: items, totalPages: 4);
  }

  //
  late PagifyController<String> _pagifyController;

  @override
  void initState() {
    _pagifyController = PagifyController<String>();
    super.initState();
  }

  @override
  void dispose() {
    _pagifyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomDropDownButton<ExampleModel, String>.withSearch(
        // onSearch: (pattern, data) => data.where(test),

        onSearch: (pattern, e) => e!.contains(pattern??''),
          customDropDownButtonPagifyData: CustomDropDownButtonPagifyData(
            controller: _pagifyController,
            asyncCall: (context, page)async => await _fetchData(page),
            mapper: (response) => PagifyData(
                data: response.items,
                paginationData: PaginationData(
                  totalPages: response.totalPages,
                  perPage: 10,
                )
            ),
            errorMapper: PagifyErrorMapper(
                errorWhenDio: (e) {
                  String? msg = '';
                  switch (e.type) {
                    case DioExceptionType.connectionTimeout:
                      msg = 'Connection timeout. Please try again.';

                    case DioExceptionType.receiveTimeout:
                      msg = 'Server response timeout.';

                    case DioExceptionType.badResponse:
                      msg = 'Server returned ${e.response?.statusCode}';

                    default:
                      msg = e.response?.data.toString();
                  }

                  return PagifyApiRequestException(
                    msg ?? 'network error occur',
                    pagifyFailure: RequestFailureData(
                      statusCode: e.response?.statusCode,
                      statusMsg: e.response?.statusMessage,
                    ),
                  );
                } // if you using Dio

              // errorWhenHttp: (e) => PagifyApiRequestException(), // if you using Http
            ),
            itemBuilder: (context, data, index, element) => AppText(element, textAlign: TextAlign.start),
          ),
        initialValue: 'test',
        selectedItemWidget: (e) => AppText(e),
      )
    );
  }
}
