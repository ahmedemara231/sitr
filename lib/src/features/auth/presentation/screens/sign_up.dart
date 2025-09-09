import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/extensions/sized_box_helper.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../core/widgets/scaffolds/auth_scaffold.dart';
import '../../../otp/models/otp_body.dart';
import '../../../otp/presentation/cubits/otp_cubit.dart';
import '../../../otp/presentation/otp.dart';
import '../../../packages/presentation/packages_screen.dart';
import '../../models/sign_up_body.dart';
import '../cubits/sign_up_cubit.dart';
import '../widgets/shared/choose_gender.dart';
import '../widgets/shared/text_field.dart';
import '../widgets/sign_up/already_have_acc.dart';
import '../widgets/sign_up/drop_down_text_field.dart';
import '../widgets/sign_up/image_widget.dart';
import '../widgets/sign_up/sign_up_upper_widget.dart';
import 'enter_male_female_child_data.dart';

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
  late TextEditingController _childrenNumberCont;


  @override
  void initState() {
    _nameCont = TextEditingController();
    _phoneCont = TextEditingController();
    _ageCont = TextEditingController();
    _identifyNumberCont = TextEditingController();
    _codeCont = TextEditingController();
    _emailCont = TextEditingController();
    _childrenNumberCont = TextEditingController();
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
    _childrenNumberCont.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();
  UserType type = UserType.male;
  File? image;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: CenterCardScaffold(
          upperWidget: const SignUpUpperWidget(),
          body: Form(
            key: formKey,
            child: Column(
              spacing: 10.h,
              children: [
                ChooseGenderWidget(
                  onSelectGender: (selectedGender) => setState(() => type = selectedGender),
                  genders: const [
                    UserType.male,
                    UserType.female,
                    UserType.parent,
                  ],
                ),
                10.szH,
                SignUpImageWidget(onSelectImage: (img) => image = img),

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

                UserTypeHelper.drowWidget(
                    drow: (current) => type.isParent?
                    SignUpTextField(
                      upperTitle: LocaleKeys.email,
                      title: LocaleKeys.pleaseEnterTheEmail,
                      controller: _ageCont,
                      inputType: TextInputType.emailAddress,
                      // validator: Validators.validateEmpty,
                    ) : SignUpTextField(
                      upperTitle: LocaleKeys.age,
                      title: LocaleKeys.pleaseEnterYourAge,
                      controller: _ageCont,
                      inputType: TextInputType.number,
                      // validator: Validators.validateEmpty,
                    ),
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
                    DropDownTextField(title: LocaleKeys.kinship, onChanged: (val){}),
                    SignUpTextField(
                      upperTitle: LocaleKeys.childrenNumber,
                      title: LocaleKeys.pleaseEnterTheNumber,
                      controller: _childrenNumberCont,
                      inputType: TextInputType.number,
                      // validator: Validators.validateEmpty,
                    ),
                    DropDownTextField(title: LocaleKeys.gender, onChanged: (val){}),
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
                    onSuccess: () => type.isParent?
                    Go.to(const EnterMaleOrFemaleOrChildDataScreen.signUpAsParent()) :
                    Go.to(BlocProvider(
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
                                image: image,
                                gender: type.name
                            )
                        );
                      }
                    },
                      title: LocaleKeys.confirm,
                  ),
                ),
                const AlreadyHaveAccWidget()
              ],
            ),
          )
      ),
    );
  }
}
