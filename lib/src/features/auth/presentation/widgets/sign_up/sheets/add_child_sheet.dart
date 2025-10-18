import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart' show Lottie;

import '../../../../../../../generated/assets.dart';
import '../../../../../../config/language/locale_keys.g.dart';
import '../../../../../../core/navigation/navigator.dart';
import '../../../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../../../core/widgets/app_text.dart';
import '../../../../imports.dart';

class AddChildSheet extends StatelessWidget {
  const AddChildSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet.large(
        asyncCall: (context) => Go.offAll(const LoginScreen()),
        btnTitle: LocaleKeys.back,
        cancelBackgroundColor: Colors.black,
        cancelBtnTitle: LocaleKeys.sendOrder,
        upperWidget: Column(
          spacing: 12.h,
          children: [
            Lottie.asset(Assets.successDone),
            AppText(LocaleKeys.childDataHasBeenAddedSuccessfully, fontSize: 16.sp, fontWeight: FontWeight.w500),
            AppText(LocaleKeys.doYouWantToAddAnotherChildOrSendARequestToTheAdministrationForReview, fontSize: 12.sp, color: Colors.black54),
          ],
        )
    );
  }
}
