import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart' show Lottie;
import '../../../../../../../generated/assets.dart';
import '../../../../../../config/language/locale_keys.g.dart';
import '../../../../../../core/helpers/user_type_enum.dart';
import '../../../../../../core/navigation/navigator.dart';
import '../../../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../../../core/widgets/app_text.dart';
import '../../../../../../core/widgets/default_bottom_sheet.dart';
import '../../../../imports.dart';
import '../../../cubits/add_child.dart';
import '../../../data/auth_data.dart';

class AddChildSheet extends StatelessWidget {
  const AddChildSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return AppBottomSheet.large(
            asyncCall: (context) {
              Go.off( EnterMaleOrFemaleOrChildDataScreen.withParent(
                  scaffoldType: ScaffoldType.centerCard,
                  showConditionsAndTerms: true,
                  onClick: (context, user) => context.read<AddChildCubit>().addChild(
                      body: user,
                      onSuccess: () {
                        AuthData.childrenNumber.value.increment(user.gender!.userType!);
                        showDefaultBottomSheet(child: const AddChildSheet());
                      }
                  )
              ));
            },
            btnTitle: LocaleKeys.addAnotherChild,
            cancelBackgroundColor: Colors.black,
            cancelBtnTitle: LocaleKeys.sendOrder,
            cancelOnTap: () async => Go.offAll(const LoginScreen()),
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
