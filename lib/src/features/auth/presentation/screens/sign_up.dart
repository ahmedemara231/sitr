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


  late TextEditingController _parentNameCont;
  late TextEditingController _parentPhoneCont;
  late TextEditingController _parentIdentifyNumberCont;
  late TextEditingController _parentCodeCont;

  late TextEditingController _emailCont;
  late TextEditingController _childrenNumberCont;
  late Kinship kinship;
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

    _parentNameCont = TextEditingController();
    _parentPhoneCont = TextEditingController();
    _parentIdentifyNumberCont = TextEditingController();
    _parentCodeCont = TextEditingController();

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

    _parentNameCont.dispose();
    _parentPhoneCont.dispose();
    _parentIdentifyNumberCont.dispose();
    _parentCodeCont.dispose();

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
    TextEditingController? whenParent,
  }) {
    switch (type) {
      case UserType.male:
        return whenMale;

      case UserType.female:
        return whenFemale;

      case UserType.parent:
        return whenParent?? TextEditingController();

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
                  controller: _getContBasedUserType(whenMale: _maleNameCont, whenFemale: _femaleNameCont, whenParent: _parentNameCont),
                  // validator: Validators.validateEmpty,
                ),
                SignUpTextField(
                  upperTitle: LocaleKeys.phoneNumber,
                  title: LocaleKeys.pleaseEnterTheNumber,
                  controller: _getContBasedUserType(whenMale: _malePhoneCont, whenFemale: _femalePhoneCont, whenParent: _parentPhoneCont),
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
                  controller: _getContBasedUserType(whenMale: _maleIdentifyNumberCont, whenFemale: _femaleIdentifyNumberCont, whenParent: _parentIdentifyNumberCont),
                  inputType: TextInputType.number,
                  // validator: Validators.validateEmpty,
                ),

                if (type.isParent) ...[
                  DropDownTextField<Kinship>.withApiRequest(
                      hint: LocaleKeys.pleaseEnterTheKinship,
                      request: (ctx) async => AuthData.getKinships(),
                      itemBuilder: (val) => AppText(val.value),
                      title: LocaleKeys.kinship, onChanged: (val) => kinship = val!
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
                  controller: _getContBasedUserType(whenMale: _maleCodeCont, whenFemale: _femaleCodeCont, whenParent: _parentCodeCont),
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
                                phone: _getContBasedUserType(whenMale: _malePhoneCont, whenFemale: _femalePhoneCont, whenParent: _parentPhoneCont).text,
                                onConfirmCode: (ctx, code) => ctx.read<OtpCubit>().sendOtp(
                                    type: OtpType.afterRegister,
                                    body: OtpBody(
                                        phone: _getContBasedUserType(whenMale: _malePhoneCont, whenFemale: _femalePhoneCont, whenParent: _parentPhoneCont).text,
                                        code: code
                                    ),
                                    onSuccess: (data) async {
                                      log('the runType is ${data.runtimeType}');

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
                    asyncCall: (ctx) async {
                      if (formKey.currentState!.validate()) {
                        if(signUpBody is MaleAndFemaleSignUp){
                          signUpBody = MaleAndFemaleSignUp(
                            age: _getContBasedUserType(whenMale: _maleAgeCont, whenFemale: _femaleAgeCont).text,
                            name: _getContBasedUserType(whenMale: _maleNameCont, whenFemale: _femaleNameCont).text,
                            phone: _getContBasedUserType(whenMale: _malePhoneCont, whenFemale: _femalePhoneCont).text,
                            identityNumber: _getContBasedUserType(whenMale: _maleIdentifyNumberCont, whenFemale: _femaleIdentifyNumberCont).text,
                            code: _getContBasedUserType(whenMale: _maleCodeCont, whenFemale: _femaleCodeCont).text,
                            image: image,
                            gender: type.name,
                          );

                        }else{
                          signUpBody = ParentSignUp(
                              email: _emailCont.text,
                              kinship: kinship.id,
                              childrenNumber: _childrenNumberCont.text,
                              childGender: childGender,
                              name: _parentNameCont.text,
                              phone: _parentPhoneCont.text,
                              identityNumber: _parentIdentifyNumberCont.text,
                              image: image,
                              gender: childGender.toUserType().name,
                              code: _parentCodeCont.text
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
