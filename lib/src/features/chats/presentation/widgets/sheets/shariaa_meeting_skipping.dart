import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/choose_from_options.dart';

class ShariaaMeetingSkipping extends StatelessWidget {
  final FutureOr<void> Function(BuildContext context, String val) onSubmit;
  ShariaaMeetingSkipping({super.key,
    required this.onSubmit,
  });

  final List<String> options = [LocaleKeys.moveToNextStage, LocaleKeys.continueTheStage];
  @override
  Widget build(BuildContext context) {
    String selectedVal = options.first;
    return AppBottomSheet.small(
        asyncCall: (context) => onSubmit.call(context, selectedVal),
        btnTitle: LocaleKeys.confirm,
        upperWidget: Column(
          spacing: 10.h,
          children: [
            AppText(LocaleKeys.shariaaMeetingStage),
            AppText(LocaleKeys.optionalStageYouCanSkipThisStage),
            ChooseFromOptionsWidget(
              onSelectOption: (val) => selectedVal = val,
              ranking: OptionsRanking.vertical,
              fontSize: 16,
              childPadding: EdgeInsets.symmetric(vertical: 16.h),
                titles: options,
            ),
          ],
        )
    );
  }
}
