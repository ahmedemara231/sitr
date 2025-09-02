import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/validators.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/widgets/app_logo_widget.dart';
import '../../../../core/widgets/custom_messages.dart';
import '../../../../core/widgets/scaffolds/auth_scaffold.dart';
import '../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../core/widgets/buttons/default_button.dart';
import '../../../../core/widgets/lang_icon.dart';
import '../../../../core/widgets/text_fields/default_text_field.dart';
import '../../../otp/presentation/cubits/otp_cubit.dart';
import '../../models/login_body.dart';
import '../cubits/login_cubit.dart';
import '../widgets/do_not_have_acc.dart';
import '../widgets/login_static_texts.dart';
import '../../../otp/presentation/otp.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController _phoneCont;
  @override
  void initState() {
    _phoneCont = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phoneCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: AuthScaffold(
        upperWidget: Column(
          spacing: 12.h,
          children: [
            Row(
              spacing: context.width / 8,
              children: [
                LangIcon(onSelectLang: (lang){}),
                const AppLogoWidget(),
              ],
            ),
            const LoginStaticTexts()
          ],
        ),
        body: SizedBox(
          height: context.height * .7,
          child: Column(
            spacing: 12.h,
            children: [
              Form(
                key: formKey,
                child: DefaultTextField.withTitle(
                  upperTitle: LocaleKeys.phoneNumber,
                  inputType: TextInputType.phone,
                  title: LocaleKeys.pleaseEnterTheNumber,
                  fillColor: Colors.grey[50],
                  validator: Validators.validatePhone,
                  controller: _phoneCont,
                ),
              ),
              BlocListener<LoginCubit, AsyncState>(
                listener: (context, state) => Helpers.manageBlocListener(
                  state.status,
                  onSuccess: () {
                    Go.to(OtpScreen(
                      title: LocaleKeys.confirmCode,
                      phone: _phoneCont.text,
                      otpType: OtpType.afterLogin,
                  ));
                  MessageUtils.showSnackBar(
                    'دخل الكود يا ادهم يا ظالم',
                    // backgroundColor: AppColors.primary,
                  );
                  }
                ),
                child: AppLoadingButton(
                  title: LocaleKeys.login,
                  asyncCall: (ctx) async {
                    if(formKey.currentState!.validate()){
                      await ctx.read<LoginCubit>().login(
                          LoginBody(phone: _phoneCont.text)
                      );
                    }
                  },
                ),
              ),
              const DoNotHaveAccountWidget(),
              DefaultButton(
                borderRadius: ConstantManager.buttonBorderRadius,
                color: AppColors.thirdColor,
                title: LocaleKeys.signInAsVisitor,
                textColor: AppColors.primary,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                onTap: (){},
              )
            ],
          ),
        ),
      ),
    );
  }
}
