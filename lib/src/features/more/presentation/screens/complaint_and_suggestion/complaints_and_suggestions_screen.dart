import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/pagify.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/extensions/widget_extension.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/widgets/app_pagify.dart';
import '../../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../data/more_data.dart';
import '../../models/complaint_model.dart';
import 'add_complaint_and_suggestion.dart';
import 'widgets/complaints_and_suggestions_item.dart';

class ComplaintsAndSuggestionsScreen extends StatelessWidget {
  const ComplaintsAndSuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PagifyController controller = PagifyController();
    return AppScaffold(
      appBarTitle: LocaleKeys.complaintsAndSuggestions,
      body: AppPagify(
          cacheKey: 'complaints',
          cacheToJson: (item) => item.toJson(),
          cacheFromJson: (json) => ComplaintModel.fromJson(json),
          asyncCall: (context, page) => MoreData.getComplaints(page),
          itemBuilder: (context, data, i, element) => ComplaintsAndSuggestionsItem(complaintModel: element),
          pagifyController: controller
      ).withPullRefresher(
        onRefresh: () => controller.refresh()
      ),
        bottomBar: AppLoadingButton(
            asyncCall: (context) async {
              Go.to(const AddComplaintAndSuggestion());
            },
            title: LocaleKeys.attachNewComplaint)
            .paddingAll(16.r),
      );
  }
}

