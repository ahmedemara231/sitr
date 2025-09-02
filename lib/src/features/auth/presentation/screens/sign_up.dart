import 'dart:io';
import 'package:easy_timer_count/extensions/null_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../generated/assets.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/sized_box_helper.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../../core/widgets/app_logo_widget.dart';
import '../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../core/widgets/scaffolds/auth_scaffold.dart';
import '../../../../core/widgets/lang_icon.dart';
import '../../../otp/models/otp_body.dart';
import '../../../otp/presentation/cubits/otp_cubit.dart';
import '../../../otp/presentation/otp.dart';
import '../../../packages/presentation/packages_screen.dart';
import '../../models/sign_up_body.dart';
import '../cubits/sign_up_cubit.dart';
import '../widgets/choose_gender.dart';
import '../widgets/drop_down_text_field.dart';
import '../widgets/sign_up_static_texts.dart';
import '../widgets/text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  late TextEditingController _nameCont;
  late TextEditingController _phoneCont;
  late TextEditingController _ageCont;
  late TextEditingController _identifyNumberCont;
  late TextEditingController _codeCont;
  late TextEditingController _emailCont;

  @override
  void initState() {
    _nameCont = TextEditingController();
    _phoneCont = TextEditingController();
    _ageCont = TextEditingController();
    _identifyNumberCont = TextEditingController();
    _codeCont = TextEditingController();
    _emailCont = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameCont.dispose();
    _phoneCont.dispose();
    _ageCont.dispose();
    _identifyNumberCont.dispose();
    _codeCont.dispose();
    _emailCont.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();
  UserType type = UserType.male;
  ValueNotifier<File?> image = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
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
              const SignUpStaticTexts()
            ],
          ),
          body: Form(
            key: formKey,
            child: Column(
              children: [
                ChooseGenderWidget(
                    onSelectGender: (selectedGender) => setState(() => type = selectedGender)
                ),
                10.szH,
                SignUpTextField(
                  readOnly: true,
                  onTap: () async{
                    final selectedImage = await Helpers.getImageFromCameraOrDevice();
                    image.value = selectedImage;
                  },
                  upperTitle: LocaleKeys.profilePicture,
                  title: LocaleKeys.pleaseEnterYourProfilePicture,
                  suffixIconPath: Assets.svgCamera,
                  controller: TextEditingController(),
                  // validator: Validators.validateEmpty,
                ),
                ValueListenableBuilder(
                    valueListenable: image,
                    builder: (context, value, child) => value.isNotNull? CircleAvatar(
                      radius: 50.sp,
                      backgroundImage: FileImage(value!),
                    ) : const SizedBox.shrink()
                ),

                SignUpTextField(
                  upperTitle: LocaleKeys.name,
                  title: LocaleKeys.pleaseEnterYourName,
                  controller: _nameCont,
                  // validator: Validators.validateEmpty,
                ),
                SignUpTextField(
                  upperTitle: LocaleKeys.phoneNumber,
                  title: LocaleKeys.pleaseEnterTheNumber,
                  controller: _phoneCont,
                  // validator: Validators.validatePhone,
                  inputType: TextInputType.number,
                ),

                if(type.isParent)
                  SignUpTextField(
                    upperTitle: LocaleKeys.email,
                    title: LocaleKeys.pleaseEnterTheEmail,
                    controller: _ageCont,
                    inputType: TextInputType.emailAddress,
                    // validator: Validators.validateEmpty,
                  )
                else
                  SignUpTextField(
                    upperTitle: LocaleKeys.age,
                    title: LocaleKeys.pleaseEnterYourAge,
                    controller: _ageCont,
                    inputType: TextInputType.number,
                    // validator: Validators.validateEmpty,
                  ),

                SignUpTextField(
                    upperTitle: LocaleKeys.identifyNumber,
                    title: LocaleKeys.pleaseEnterTheNumber,
                    controller: _identifyNumberCont,
                  inputType: TextInputType.number,
                  // validator: Validators.validateEmpty,
                ),

                if(type.isParent)
                  ...[
                    DropDownTextField(title: LocaleKeys.pleaseEnterYourCode),
                    DropDownTextField(title: LocaleKeys.childrenNumber),
                    DropDownTextField(title: LocaleKeys.gender),
                  ],
                
                SignUpTextField(
                    upperTitle: LocaleKeys.code,
                    title: LocaleKeys.pleaseEnterYourCode,
                    controller: _codeCont,
                  inputType: TextInputType.number,
                  // validator: Validators.validateEmpty,
                ),

                10.szH,
                BlocListener<SignUpCubit, AsyncState>(
                  listener: (context, state) => Helpers.manageBlocListener(
                    state.status,
                    onSuccess: () => Go.to(BlocProvider(
                      create: (context) => OtpCubit(),
                      child: OtpScreen(
                        title: LocaleKeys.activationCode,
                        phone: _phoneCont.text,
                        onConfirmCode: (ctx, code) => ctx.read<OtpCubit>().sendOtp(
                          type: OtpType.afterRegister,
                          body: OtpBody(phone: _phoneCont.text, code: code),
                          onSuccess: (data) async{
                            await UserCubit.instance.setUserLoggedIn(user: data, token: data.token?? '');
                            Go.to(const PackagesScreen.view());
                          }
                        ),
                      ),
                    ))
                  ),
                  child: AppLoadingButton(
                    asyncCall: (ctx) async{
                      if(formKey.currentState!.validate()){
                        await ctx.read<SignUpCubit>().signUp(
                            SignUpBody(
                                name: _nameCont.text,
                                phone: _phoneCont.text,
                                age: _ageCont.text,
                                identityNumber: _identifyNumberCont.text,
                                image: image.value,
                                gender: type.name
                            )
                        );
                      }
                    },
                      title: LocaleKeys.confirm,
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}
