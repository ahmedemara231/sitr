import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/navigation/named_routes.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/buttons/custom_app_buttons/loading_button.dart';
import '../../../../core/widgets/default_bottom_sheet.dart';
import '../../../../core/widgets/sheets/success_sheet.dart';
import '../../../../core/widgets/text_fields/default_text_field.dart';
import '../cubit/change_phone_manager.dart';

class ChangePhoneSheetBody extends StatelessWidget {
  const ChangePhoneSheetBody({super.key});

  @override
  Widget build(BuildContext context) {
    String phone = '';
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10.h,
        children: [
          AppText(LocaleKeys.pleaseEnterANewMobileNumber, fontWeight: FontWeight.w500, fontSize: 18.sp,),
          AppText(LocaleKeys.enterANewMobileNumberToChangeYourCurrentOne, fontSize: 12.sp, color: Colors.black54,),
          DefaultTextField.withTitle(
            upperTitle: LocaleKeys.phoneNumber,
            inputType: TextInputType.phone,
            title: LocaleKeys.pleaseEnterYourPhone,
            fillColor: AppColors.whiteGreyColorProMax,
            borderColor: Colors.transparent,
            onChanged: (val) => phone = val ?? '',
          ),
          LoadingButton(
            idleWidget: AppText(LocaleKeys.confirm, color: Colors.white, fontWeight: FontWeight.bold),
            height: 45.h,
            borderRadius: ConstantManager.buttonBorderRadiusNumber,
            call: (context)async => context.read<ChangePhoneManagerCubit>().manage(
                phase: Phase.sendNew,
                phone: phone,
                onSuccess: (data) => Go.offNamed(
                  context,
                  NamedRoutes.newPhoneOtpScreen,
                    arguments: {
                      'phone' : phone,
                      'title' : LocaleKeys.changePhoneNumber,
                      'onEnterScreen': (BuildContext context) =>
                          context.read<ChangePhoneManagerCubit>().manage(
                            phase: Phase.sendNew,
                            phone: phone,
                          ),
                      'onConfirmCode': (BuildContext context, code) => context.read<ChangePhoneManagerCubit>().manage(
                        phase: Phase.checkNew,
                        code: code,
                          phone: phone,
                          onSuccess: (data) async{
                            Go.back();
                            final newUser = UserCubit.instance.user.copyWith(phone: phone);
                            await UserCubit.instance.updateUser(newUser);
                            showDefaultBottomSheet(child: SuccessSheet(
                                isInAuth: false,
                              upperText: AppText(
                                LocaleKeys.phoneChangedSuccessfully,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ));
                          }
                      )
                  }
                    // OtpScreen(
                    //   phone: phone,
                    //   title: LocaleKeys.changePhoneNumber,
                    //   onConfirmCode: (context, code) => context.read<ChangePhoneManagerCubit>().manage(
                    //       phase: Phase.checkNew,
                    //       code: code,
                    //       onSuccess: (data) {
                    //         final newUser = UserCubit.instance.user.copyWith(phone: phone);
                    //         UserCubit.instance.updateUser(newUser);
                    //       }
                    //   ),
                    // )
                )

                // onSuccess: (data) => Go.off(
                //     OtpScreen(
                //         phone: phone,
                //         title: LocaleKeys.changePhoneNumber,
                //         onConfirmCode: (context, code) => context.read<ChangePhoneManagerCubit>().manage(
                //             phase: Phase.checkNew,
                //             code: code,
                //             onSuccess: (data) {
                //               final newUser = UserCubit.instance.user.copyWith(phone: phone);
                //               UserCubit.instance.updateUser(newUser);
                //             }
                //         ),
                //     )
                // )
              ),
          ),
        ],
      ).defaultScreenPadding(),
    );
  }
}
