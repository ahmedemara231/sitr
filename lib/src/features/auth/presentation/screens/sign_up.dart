part of '../../imports.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final PageController _pageController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirstValidationErrorFieldKeys _validationFieldKeys =
      FirstValidationErrorFieldKeys();
  final ValueNotifier<_SignUpAccountType?> _accountType =
      ValueNotifier<_SignUpAccountType?>(null);

  SignUpBody _signUpBody = SignUpBody.initial();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _accountType.dispose();
    super.dispose();
  }

  double _pageHeight(BuildContext context) =>
      _currentPage == 0 ? 340.h : context.height * .72;

  void _selectAccountType(_SignUpAccountType accountType) {
    _accountType.value = accountType;
    _signUpBody = SignUpBody.fromSelectedGender(accountType.gender);
  }

  Future<void> _goToFieldsPage() async {
    if (_accountType.value == null) {
      MessageUtils.show(
        LocaleKeys.pleaseEnterTheGender,
        state: MsgState.info,
      );
      return;
    }

    context.hideKeyboard();
    await _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  Future<void> _goToGenderPage() async {
    context.hideKeyboard();
    await _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  Future<void> _submitSignUp(BuildContext ctx) async {
    await ctx.read<SignUpCubit>().signUp(
          _signUpBody,
          onSuccess: _onSignUpSuccess,
        );
  }

  void _onSignUpSuccess(BaseModel<dynamic> data) {
    MessageUtils.show(data.msg, state: MsgState.success);
    Go.to(
      BlocProvider(
        create: (context) => OtpCubit(),
        child: OtpScreen(
          title: LocaleKeys.activationCode,
          phone: _signUpBody.phone,
          onConfirmCode: (ctx, code) => ctx.read<OtpCubit>().sendOtp(
                type: OtpType.afterRegister,
                body: OtpBody(
                  phone: _signUpBody.phone,
                  code: code,
                ),
                onSuccess: (user) async {
                  await AppyFlyerHelper.logEvent(FlyerEvents.register);
                  user.completeRegistration!
                      .manageNavigationBasedCompleteRegisterStatus(user);
                },
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: CenterCardScaffold(
        upperWidget: const SignUpUpperWidget(),
        bodyColor: AppColors.white,
        body: BlocBuilder<SignUpCubit, AsyncState>(
          builder: (context, state) => Column(
            spacing: 10.h,
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                child: SizedBox(
                  height: _pageHeight(context),
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (int page) =>
                        setState(() => _currentPage = page),
                    children: [
                      SingleChildScrollView(
                        child: ValueListenableBuilder<_SignUpAccountType?>(
                          valueListenable: _accountType,
                          builder: (context, accountType, child) =>
                              _SignUpGenderStep(
                            selectedAccountType: accountType,
                            canChoose: !state.isLoading,
                            onAccountTypeSelected: _selectAccountType,
                            onContinuePressed: _goToFieldsPage,
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: ValueListenableBuilder<_SignUpAccountType?>(
                          valueListenable: _accountType,
                          builder: (context, accountType, child) =>
                              _SignUpFieldsStep(
                            accountType: accountType,
                            formKey: _formKey,
                            validationFieldKeys: _validationFieldKeys,
                            validationFields: () =>
                                _signUpBody.firstValidationErrorFields(
                              _validationFieldKeys,
                            ),
                            canSubmit: !state.isLoading,
                            onBackPressed: _goToGenderPage,
                            onSubmitPressed: _submitSignUp,
                            onSignUpBodyChanged: (SignUpBody body) =>
                                _signUpBody = body,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const AlreadyHaveAccWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
