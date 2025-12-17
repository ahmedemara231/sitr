import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart' show Lottie;
import '../../../../../../../generated/assets.dart';
import '../../../../../../config/language/locale_keys.g.dart';
import '../../../../../../core/extensions/num.dart';
import '../../../../../../core/extensions/object.dart';
import '../../../../../../core/navigation/navigator.dart';
import '../../../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../../../core/widgets/app_text.dart';
import '../../../../../../core/widgets/default_bottom_sheet.dart';
import '../../../../imports.dart';
import '../../../cubits/add_child.dart';

class AddChildSheet extends StatelessWidget {
  final FutureOr<void> Function()? cancelOnTap;
  const AddChildSheet({super.key, this.cancelOnTap});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return AppBottomSheet.large(
            asyncCall: (context) {
              2.pop();
              Go.to(EnterMaleOrFemaleOrChildDataScreen.showAll(
                  scaffoldType: ScaffoldType.centerCard,
                  onClick: (context, user) => context.read<AddChildCubit>().addChild(
                      body: user,
                      onSuccess: (data) {
                        showDefaultBottomSheet(child: AddChildSheet(cancelOnTap: cancelOnTap));
                      }
                  )
              ));
            },
            btnTitle: LocaleKeys.addAnotherChild,
            cancelBackgroundColor: Colors.black,
            cancelBtnTitle: LocaleKeys.sendOrder,
            cancelOnTap: () async => cancelOnTap.isNull?
            Go.offAll(const LoginScreen()) :
            await cancelOnTap!(),
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
