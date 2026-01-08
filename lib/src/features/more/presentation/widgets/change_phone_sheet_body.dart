import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/helpers/validators.dart';
import '../../../../core/navigation/named_routes.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../chats/data/chat_sheet_manager.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../core/widgets/buttons/custom_app_buttons/loading_button.dart';
import '../../../../core/widgets/sheets/success_sheet.dart';
import '../../../../core/widgets/text_fields/default_text_field.dart';
import '../cubit/change_phone_manager.dart';

class ChangePhoneSheetBody extends StatefulWidget {
  const ChangePhoneSheetBody({super.key});

  @override
  State<ChangePhoneSheetBody> createState() => _ChangePhoneSheetBodyState();
}

class _ChangePhoneSheetBodyState extends State<ChangePhoneSheetBody> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController phoneController;

  @override
  void initState() {
    phoneController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10.h,
        children: [
          AppText(LocaleKeys.pleaseEnterANewMobileNumber, fontWeight: FontWeight.w500, fontSize: 18.sp,),
          AppText(LocaleKeys.enterANewMobileNumberToChangeYourCurrentOne, fontSize: 12.sp, color: Colors.black54,),
          Form(
            key: formKey,
            child: DefaultTextField.withTitle(
              validator: Validators.validatePhone,
              upperTitle: LocaleKeys.phoneNumber,
              inputType: TextInputType.phone,
              title: LocaleKeys.pleaseEnterYourPhone,
              fillColor: AppColors.whiteGreyColorProMax,
              borderColor: Colors.transparent,
              controller: phoneController,
            ),
          ),
          AppLoadingButton(
            title: LocaleKeys.confirm,
            height: 45.h,
            borderRadius: ConstantManager.buttonBorderRadiusNumber,
            asyncCall: (context)async => formKey.currentState!.validate()? context.read<ChangePhoneManagerCubit>().manage(
                phase: Phase.sendNew,
                phone: phoneController.text,
                onSuccess: (data) => Go.offNamed(
                  context,
                  NamedRoutes.newPhoneOtpScreen,
                    arguments: {
                      'phone' : phoneController.text,
                      'title' : LocaleKeys.changePhoneNumber,
                      'onEnterScreen': (BuildContext context) =>
                          context.read<ChangePhoneManagerCubit>().manage(
                            phase: Phase.sendNew,
                            phone: phoneController.text,
                          ),
                      'onConfirmCode': (BuildContext context, code) => context.read<ChangePhoneManagerCubit>().manage(
                        phase: Phase.checkNew,
                        code: code,
                          phone: phoneController.text,
                          onSuccess: (msg) async{
                            Go.back();
                            final newUser = UserCubit.instance.user.copyWith(phone: phoneController.text);
                            await UserCubit.instance.updateUser(newUser);
                            ChatSheetManager.show(child: SuccessSheet(
                                isInAuth: false,
                              onTap: () => Go.back(),
                              upperText: AppText(
                                msg,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ));
                          }
                      )
                  }
                )
              ) : null,
          ),
        ],
      ).defaultScreenPadding(),
    ).paddingBottom(MediaQuery.of(context).viewInsets.bottom);
  }
}
