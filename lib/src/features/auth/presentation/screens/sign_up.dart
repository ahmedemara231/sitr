part of '../../imports.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignUpBody signUpBody = SignUpBody.initial();
  final formKey = GlobalKey<FormState>();
  final ValueNotifier<(UserType, UserGender)> userTypeAndGender =
      ValueNotifier((UserType.individual, UserGender.male));

  void _init(String val){
    final UserGender gender = val.toUserGender();
    final UserType type = gender.isMale || gender.isFemale?
    UserType.individual : UserType.parent;

    log('the data is ${UserGender.male.name == LocaleKeys.male}');
    log('the data is $type $gender');
    userTypeAndGender.value = (type, gender);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: CenterCardScaffold(
          upperWidget: const SignUpUpperWidget(),
          bodyColor: AppColors.white,
          body: Column(
            spacing: 10.h,
            children: [
              BlocBuilder<SignUpCubit, AsyncState>(
                builder: (context, state) => ChooseFromOptionsWidget(
                  height: 50.h,
                  canChoose: !state.isLoading,
                  onSelectOption: (val) => _init(val),
                  titles: [
                    LocaleKeys.male,
                    LocaleKeys.female,
                    LocaleKeys.parent,
                  ],
                )
              ),
              10.szH,

              ValueListenableBuilder<(UserType, UserGender)>(
                valueListenable: userTypeAndGender,
                builder: (context, value, child) => Form(
                  key: formKey,
                  child: SignUpFields(
                    type: userTypeAndGender.value.$1,
                      gender: userTypeAndGender.value.$2,
                      onFinish: (data) async => signUpBody = data,
                  ),
                )
              ),

              AppLoadingButton(
                asyncCall: (ctx) async {
                  if(formKey.currentState?.validate() ?? false){
                    await ctx.read<SignUpCubit>().signUp(
                        signUpBody,
                        onSuccess: (data) {
                          MessageUtils.showSnackBar(data.msg);
                          Go.to(BlocProvider(
                            create: (context) => OtpCubit(),
                            child: OtpScreen(
                              title: LocaleKeys.activationCode,
                              phone: signUpBody.phone,
                              onConfirmCode: (ctx, code) => ctx.read<OtpCubit>().sendOtp(
                                type: OtpType.afterRegister,
                                body: OtpBody(
                                    phone: signUpBody.phone,
                                    code: code
                                ),
                                onSuccess: (user) async {
                                  user.completeRegistration!.manageNavigationBasedCompleteRegisterStatus(user);

                                  // await UserCubit.instance.setUserLoggedIn(
                                  //     user: user,
                                  //     token: user.token ?? ''
                                  // );

                                  // Go.to(const PackagesScreen.subscription(
                                  //     paymentMethods: [PaymentMethod.online],
                                  //     isInAuth: true
                                  // ));
                                },
                              ),
                            ),
                          ));
                        }
                    );
                  }
                },
                title: LocaleKeys.confirm,
              ),
              const AlreadyHaveAccWidget()
            ],
          )),
    );
  }
}