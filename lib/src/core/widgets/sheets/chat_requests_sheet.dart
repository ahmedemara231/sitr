import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/language/locale_keys.g.dart';
import '../app_text.dart';
import '../buttons/app_loading_button.dart';
import '../choose_from_options.dart';

class ChatRequestsSheet extends StatelessWidget {
  const ChatRequestsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10.h,
      children: [
        AppText(LocaleKeys.pleaseSelectOption, fontSize: 22.sp, fontWeight: FontWeight.w500),
        AppText(LocaleKeys.pleaseSelectTheSuitableOption, fontSize: 14.sp, color: Colors.black87),

        ChooseFromOptionsWidget(
            onSelectOption: (option) {},
            titles: [
              LocaleKeys.moveToNextStage,
              LocaleKeys.refuseMoveToNextStage,
              LocaleKeys.requestForExtensionOfPeriod
            ],
            fontSize: 16.sp,
            childPadding: EdgeInsets.all(20.r),
            ranking: OptionsRanking.vertical
        ),

        AppLoadingButton(asyncCall: (context)async{}, title: LocaleKeys.confirm)
      ],
    );
  }
}
