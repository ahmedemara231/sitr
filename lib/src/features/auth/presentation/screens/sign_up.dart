part of '../../imports.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController _maleNameCont;
  late TextEditingController _malePhoneCont;
  late TextEditingController _maleAgeCont;
  late TextEditingController _maleIdentifyNumberCont;
  late TextEditingController _maleCodeCont;

  late TextEditingController _femaleNameCont;
  late TextEditingController _femalePhoneCont;
  late TextEditingController _femaleAgeCont;
  late TextEditingController _femaleIdentifyNumberCont;
  late TextEditingController _femaleCodeCont;

  late TextEditingController _emailCont;
  late TextEditingController _childrenNumberCont;
  late String kinship;
  late String childGender;

  @override
  void initState() {
    _initSignupBody(type);
    _maleNameCont = TextEditingController();
    _malePhoneCont = TextEditingController();
    _maleAgeCont = TextEditingController();
    _maleIdentifyNumberCont = TextEditingController();
    _maleCodeCont = TextEditingController();

    _femaleNameCont = TextEditingController();
    _femalePhoneCont = TextEditingController();
    _femaleAgeCont = TextEditingController();
    _femaleIdentifyNumberCont = TextEditingController();
    _femaleCodeCont = TextEditingController();

    _emailCont = TextEditingController();
    _childrenNumberCont = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _maleNameCont.dispose();
    _malePhoneCont.dispose();
    _maleAgeCont.dispose();
    _maleIdentifyNumberCont.dispose();
    _maleCodeCont.dispose();

    _femaleNameCont.dispose();
    _femalePhoneCont.dispose();
    _femaleAgeCont.dispose();
    _femaleIdentifyNumberCont.dispose();
    _femaleCodeCont.dispose();

    _emailCont.dispose();
    _childrenNumberCont.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();
  UserType type = UserType.male;
  File? image;

  late SignUpBody signUpBody;
  void _initSignupBody(UserType newType){
    if(newType.isParent){
      signUpBody = ParentSignUp.initial();

    }else{
      signUpBody = MaleAndFemaleSignUp.initial();
    }
  }

  TextEditingController _getContBasedUserType({
    required TextEditingController whenMale,
    required TextEditingController whenFemale,
  }) {
    switch (type) {
      case UserType.male:
        return whenMale;

      case UserType.female:
        return whenFemale;

      default:
        return TextEditingController();
    }
  }

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
                  onSelectGender: (selectedGender) {
                    _initSignupBody(selectedGender);
                    setState(() => type = selectedGender);
                  },
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
                  controller: _getContBasedUserType(whenMale: _maleNameCont, whenFemale: _femaleNameCont),
                  // validator: Validators.validateEmpty,
                ),
                SignUpTextField(
                  upperTitle: LocaleKeys.phoneNumber,
                  title: LocaleKeys.pleaseEnterTheNumber,
                  controller: _getContBasedUserType(whenMale: _malePhoneCont, whenFemale: _femalePhoneCont),
                  // validator: Validators.validatePhone,
                  inputType: TextInputType.number,
                ),

                if (type.isParent)
                  SignUpTextField(
                    upperTitle: LocaleKeys.email,
                    title: LocaleKeys.pleaseEnterTheEmail,
                    controller: _emailCont,
                    inputType: TextInputType.emailAddress,
                    // validator: Validators.validateEmpty,
                  )
                else
                  SignUpTextField(
                    upperTitle: LocaleKeys.age,
                    title: LocaleKeys.pleaseEnterYourAge,
                    controller: _getContBasedUserType(whenMale: _maleAgeCont, whenFemale: _femaleAgeCont),
                    inputType: TextInputType.number,
                    // validator: Validators.validateEmpty,
                  ),

                SignUpTextField(
                  upperTitle: LocaleKeys.identifyNumber,
                  title: LocaleKeys.pleaseEnterTheNumber,
                  controller: _getContBasedUserType(whenMale: _maleIdentifyNumberCont, whenFemale: _femaleIdentifyNumberCont),
                  inputType: TextInputType.number,
                  // validator: Validators.validateEmpty,
                ),

                if (type.isParent) ...[
                  DropDownTextField<Kinship>.withApiRequest(
                      hint: LocaleKeys.pleaseEnterTheKinship,
                      request: (ctx) async => AuthData.getKinships(),
                      itemBuilder: (val) => AppText(val.value),
                      title: LocaleKeys.kinship, onChanged: (val) => kinship = val?.value?? ''
                  ),
                  SignUpTextField(
                    upperTitle: LocaleKeys.childrenNumber,
                    title: LocaleKeys.pleaseEnterTheNumber,
                    controller: _childrenNumberCont,
                    inputType: TextInputType.number,
                    // validator: Validators.validateEmpty,
                  ),
                  DropDownTextField<String>(
                      hint: LocaleKeys.pleaseEnterTheGender,
                      values: [UserType.male.translate, UserType.female.translate],
                      title: LocaleKeys.gender, onChanged: (val) => childGender = val?? ''),
                ],

                SignUpTextField(
                  upperTitle: LocaleKeys.code,
                  title: LocaleKeys.pleaseEnterYourCode,
                  controller: _getContBasedUserType(whenMale: _maleCodeCont, whenFemale: _femaleCodeCont),
                  inputType: TextInputType.number,
                  // validator: Validators.validateEmpty,
                ),
                10.szH,
                BlocListener<SignUpCubit, AsyncState>(
                  listener: (context, state) => Helpers.manageBlocListener(
                      state.status,
                      onSuccess: () => type.isParent
                          ? Go.to(EnterMaleOrFemaleOrChildDataScreen
                              .signUpAsParent())
                          : Go.to(BlocProvider(
                              create: (context) => OtpCubit(),
                              child: OtpScreen(
                                title: LocaleKeys.activationCode,
                                phone: _malePhoneCont.text,
                                onConfirmCode: (ctx, code) => ctx
                                    .read<OtpCubit>()
                                    .sendOtp(
                                        type: OtpType.afterRegister,
                                        body: OtpBody(
                                            phone: _malePhoneCont.text, code: code),
                                        onSuccess: (data) async {
                                          await UserCubit.instance
                                              .setUserLoggedIn(
                                                  user: data,
                                                  token: data.token ?? '');
                                          Go.to(const PackagesScreen.view());
                                        }),
                              ),
                            ))),
                  child: AppLoadingButton(
                    asyncCall: (ctx) async {
                      if (formKey.currentState!.validate()) {
                        if(signUpBody is MaleAndFemaleSignUp){
                          signUpBody = MaleAndFemaleSignUp(
                              age: _maleAgeCont.text,
                              name: _maleNameCont.text,
                              phone: _malePhoneCont.text,
                              identityNumber: _maleIdentifyNumberCont.text,
                              image: image,
                              gender: type.translate,
                              code: _maleCodeCont.text
                          );

                        }else{
                          signUpBody = ParentSignUp(
                              email: _emailCont.text,
                              kinship: kinship,
                              childrenNumber: _childrenNumberCont.text,
                              childGender: childGender,
                              name: _maleNameCont.text,
                              phone: _malePhoneCont.text,
                              identityNumber: _maleIdentifyNumberCont.text,
                              image: image,
                              gender: childGender,
                              code: _maleCodeCont.text
                          );
                        }

                        await ctx.read<SignUpCubit>().signUp(signUpBody);
                      }
                    },
                    title: LocaleKeys.confirm,
                  ),
                ),
                const AlreadyHaveAccWidget()
              ],
            ),
          )),
    );
  }
}
