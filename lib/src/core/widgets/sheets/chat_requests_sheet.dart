import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/language/locale_keys.g.dart';
import '../../network/api_endpoints.dart';
import '../app_text.dart';
import '../buttons/app_loading_button.dart';
import '../choose_from_options.dart';


class ChooseRequestSheet extends StatelessWidget {

  final List<String> titles;
  final void Function(String)? onSelectOption;
  final Future<void> Function(BuildContext, String) onConfirm;

  const ChooseRequestSheet({super.key,
    required this.titles,
    this.onSelectOption,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    String selectedVal = titles.first;
    return Column(
      spacing: 10.h,
      children: [
        AppText(LocaleKeys.pleaseSelectOption, fontSize: 22.sp, fontWeight: FontWeight.w500),
        AppText(LocaleKeys.pleaseSelectTheSuitableOption, fontSize: 14.sp, color: Colors.black87),

        ChooseFromOptionsWidget(
            onSelectOption: (val) {
              onSelectOption?.call(val);
              selectedVal = val;
            },
            titles: titles,
            fontSize: 16.sp,
            childPadding: EdgeInsets.all(20.r),
            ranking: OptionsRanking.vertical
        ),

        AppLoadingButton(
            asyncCall: (context)async => await onConfirm.call(context, selectedVal),
            title: LocaleKeys.confirm
        )
      ],
    );
  }
}
