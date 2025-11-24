part of '../../imports.dart';

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
      child: CenterCardScaffold(
        upperWidget: Column(
          spacing: 12.h,
          children: [
            Row(
              spacing: context.width / 8,
              children: const [
                LangIcon(),
                AppLogoWidget(),
              ],
            ),
            const LoginStaticTexts()
          ],
        ).paddingAll(12.r),
        bodyColor: AppColors.white,
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
                  maxLength: 9,
                  validator: Validators.validatePhone,
                  controller: _phoneCont,
                ),
              ),
              BlocListener<LoginCubit, AsyncState>(
                listener: (context, state) {
                  if(state.isSuccess){
                    Go.to(BlocProvider(
                      create: (context) => OtpCubit(),
                      child: OtpScreen(
                        title: LocaleKeys.confirmCode,
                        phone: _phoneCont.text,
                        onConfirmCode: (ctx, code) => ctx.read<OtpCubit>().sendOtp(
                            type: OtpType.afterLogin,
                            body: OtpBody(phone: _phoneCont.text, code: code),
                            onSuccess: (user)async {
                              showDefaultBottomSheet(
                                  enableDrag: false,
                                  child: BlocProvider(
                                    create: (context) => OathCubit()..getOath(),
                                    child: AppBottomSheet.small(
                                        asyncCall: (context) async {
                                          UserCubit.instance.setUserLoggedIn(user: user, token: user.token??'');
                                          user.completeRegistration?.manageNavigationBasedCompleteRegisterStatus();
                                        },
                                        btnTitle: LocaleKeys.accept,
                                        upperWidget: Column(
                                          children: [
                                            AppText(LocaleKeys.oath, fontWeight: FontWeight.w500),
                                            BlocBuilder<OathCubit, AsyncState<String>>(
                                                builder: (context, state) => StatusBuilder(
                                                    data: state,
                                                    onSuccess: (oath, context) => Html(
                                                      data: oath,
                                                    )
                                                )
                                            ),
                                          ],
                                        )
                                    ),
                                  )
                              );
                            }
                        ),
                      ),
                    ));
                  }
                },
                child: AppLoadingButton(
                  title: LocaleKeys.login,
                  asyncCall: (ctx) async {
                    if(formKey.currentState!.validate()){
                      await ctx.read<LoginCubit>().login(
                        LoginBody(phone: _phoneCont.text),
                        onSuccess: (msg) => MessageUtils.showSnackBar(msg)
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
                onTap: () => Go.offAll(const HomeScreen()),
              )
            ],
          ),
        ),
      ),
    );
  }
}
