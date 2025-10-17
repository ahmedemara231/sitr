part of '../../imports.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignUpBody signUpBody = SignUpBody.initial();
  final formKey = GlobalKey<FormState>();
  final ValueNotifier<UserType> type = ValueNotifier(UserType.male);

  @override
  Widget build(BuildContext context) {
    // log('the gender is ${UserTypeHelper.currentType}');
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: CenterCardScaffold(
          upperWidget: const SignUpUpperWidget(),
          body: Column(
            spacing: 10.h,
            children: [
              BlocBuilder<SignUpCubit, AsyncState>(
                builder: (context, state) => ChooseGenderWidget(
                  canChoose: !state.isLoading,
                  onSelectGender: (selectedGender) => type.value = selectedGender,
                  genders: const [
                    UserType.male,
                    UserType.female,
                    UserType.parent,
                  ],
                ),
              ),
              10.szH,

              ValueListenableBuilder(
                valueListenable: type,
                builder: (context, value, child) => Form(
                  key: formKey,
                  child: SignUpFields(
                      type: type.value,
                      onFinish: (data) async => signUpBody = data,
                  ),
                )
              ),

              BlocListener<SignUpCubit, AsyncState>(
                listener: (context, state) => Helpers.manageBlocListener(
                    state.status,
                    onSuccess: () => Go.to(BlocProvider(
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
                          onSuccess: (data) async {
                            log(data.runtimeType.toString());
                            log(data.toJson().toString());
                            await UserCubit.instance.setUserLoggedIn(
                                user: data,
                                token: data.token ?? ''
                            );
                            Go.to(const PackagesScreen.view());
                          },
                        ),
                      ),
                    ))
                ),
                child: AppLoadingButton(
                  asyncCall: (ctx) async => await ctx.read<SignUpCubit>().signUp(signUpBody),
                  title: LocaleKeys.confirm,
                ),
              ),
              const AlreadyHaveAccWidget()
            ],
          )),
    );
  }
}