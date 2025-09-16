import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/icon_widget.dart';
import 'add_complaint_and_suggestion.dart';
import 'widgets/complaints_and_suggestions_item.dart';

class ComplaintsAndSuggestionsScreen extends StatelessWidget {
  const ComplaintsAndSuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(appBarTitle: LocaleKeys.complaintsAndSuggestions),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) => const ComplaintsAndSuggestionsItem(),
                separatorBuilder: (context, index) => 10.szH,
                itemCount: 5),
          )
        ],
      ).paddingAll(16),
      bottomNavigationBar: AppLoadingButton(
              asyncCall: (context) async {
                Go.to(const AddComplaintAndSuggestion());
              },
              title: LocaleKeys.attachNewComplaint)
          .paddingAll(16.r),
    );
  }
}

