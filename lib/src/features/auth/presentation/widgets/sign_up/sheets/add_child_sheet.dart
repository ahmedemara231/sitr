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
    return Builder(
      builder: (context) {
        return AppBottomSheet.large(
            asyncCall: (context) {
              // AuthData.inc(AuthData.childrenList[0].runtimeType == MaleModel? UserType.male : UserType.female);
              Go.off(const EnterMaleOrFemaleOrChildDataScreen.signUpAsParent());
            },
            btnTitle: LocaleKeys.addAnotherChild,
            cancelBackgroundColor: Colors.black,
            cancelBtnTitle: LocaleKeys.back,
            cancelOnTap: () async => Go.off(const LoginScreen()),
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
    );
  }
}
