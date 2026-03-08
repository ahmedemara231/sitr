part of '../../../imports.dart';

class SignUpFields extends StatefulWidget {
  final UserGender gender;
  final UserType type;
  final Future<void> Function(SignUpBody body) onFinish;
  const SignUpFields({
    super.key,
    required this.gender,
    required this.type,
    required this.onFinish,
  });

  @override
  State<SignUpFields> createState() => _SignUpFieldsState();
}

class _SignUpFieldsState extends State<SignUpFields> {
  late TextEditingController _maleNameCont;
  late TextEditingController _malePhoneCont;
  late TextEditingController _maleAgeCont;
  // late TextEditingController _maleIdentifyNumberCont;
  late TextEditingController _maleCodeCont;

  late TextEditingController _femaleNameCont;
  late TextEditingController _femalePhoneCont;
  late TextEditingController _femaleAgeCont;
  // late TextEditingController _femaleIdentifyNumberCont;
  late TextEditingController _femaleCodeCont;

  late TextEditingController _parentNameCont;
  late TextEditingController _parentPhoneCont;
  // late TextEditingController _parentIdentifyNumberCont;
  late TextEditingController _parentCodeCont;

  late TextEditingController _emailCont;
  late TextEditingController _childrenNumberCont;

  @override
  void initState() {
    _maleNameCont = TextEditingController();
    _malePhoneCont = TextEditingController();
    _maleAgeCont = TextEditingController();
    // _maleIdentifyNumberCont = TextEditingController();
    _maleCodeCont = TextEditingController();

    _femaleNameCont = TextEditingController();
    _femalePhoneCont = TextEditingController();
    _femaleAgeCont = TextEditingController();
    // _femaleIdentifyNumberCont = TextEditingController();
    _femaleCodeCont = TextEditingController();

    _parentNameCont = TextEditingController();
    _parentPhoneCont = TextEditingController();
    // _parentIdentifyNumberCont = TextEditingController();
    _parentCodeCont = TextEditingController();

    _emailCont = TextEditingController();
    _childrenNumberCont = TextEditingController();

    _initSignupBody(widget.type);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SignUpFields oldWidget) {
    log('rebuild test');
    _initSignupBody(widget.type);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _maleNameCont.dispose();
    _malePhoneCont.dispose();
    _maleAgeCont.dispose();
    // _maleIdentifyNumberCont.dispose();
    _maleCodeCont.dispose();

    _femaleNameCont.dispose();
    _femalePhoneCont.dispose();
    _femaleAgeCont.dispose();
    // _femaleIdentifyNumberCont.dispose();
    _femaleCodeCont.dispose();

    _parentNameCont.dispose();
    _parentPhoneCont.dispose();
    // _parentIdentifyNumberCont.dispose();
    _parentCodeCont.dispose();

    _emailCont.dispose();
    _childrenNumberCont.dispose();
    super.dispose();
  }

  File? _image;
  File? _maleImage;
  File? _femaleImage;

  UserGender? _gender;
  Kinship? _kinship;

  File? get _getImageBasedGender {
    if (widget.gender.isMale) {
      return _maleImage;
    } else if (widget.gender.isFemale) {
      return _femaleImage;
    }

    return null;
  }

  late SignUpBody signUpBody;
  final DropinityController controller = DropinityController();

  void _initSignupBody(UserType newType) {
    if (newType.isParent) {
      signUpBody = ParentSignUp.initial().copyWith(
        image: _image,
        name: _parentNameCont.text,
        phone: _parentPhoneCont.text,
        email: _emailCont.text,
        // identityNumber: _parentIdentifyNumberCont.text,
        childrenNumber: _childrenNumberCont.text,
        kinship: _kinship?.id,
        gender: _gender?.name,
        code: _parentCodeCont.text,
      );
    } else {
      signUpBody = MaleAndFemaleSignUp.initial().copyWith(
        image: _getImageBasedGender,
        name: _getContBasedUserType(whenMale: _maleNameCont, whenFemale: _femaleNameCont).text,
        phone: _getContBasedUserType(whenMale: _malePhoneCont, whenFemale: _femalePhoneCont).text,
        age: _getContBasedUserType(whenMale: _maleAgeCont, whenFemale: _femaleAgeCont).text,
        code: _getContBasedUserType(whenMale: _maleCodeCont, whenFemale: _femaleCodeCont).text,
        // identityNumber: _getContBasedUserType(
        //         whenMale: _maleIdentifyNumberCont,
        //         whenFemale: _femaleIdentifyNumberCont)
        //     .text,
      );
    }

    _listenToData(signUpBody);
    if (widget.type.isIndividual) {
      _listenToData(signUpBody.copyWith(gender: widget.gender.name));
    }
  }

  TextEditingController _getContBasedUserType({
    required TextEditingController whenMale,
    required TextEditingController whenFemale,
    TextEditingController? whenParent,
  }) {
    if(widget.type.isIndividual){
      switch (widget.gender) {
        case UserGender.male:
          return whenMale;

        case UserGender.female:
          return whenFemale;

        default:
          return TextEditingController();
      }
    }else if(widget.type.isParent){
      return whenParent ?? TextEditingController();

    }else{
      return TextEditingController();
    }
  }

  void _listenToData(SignUpBody body) {
    signUpBody = body;
    widget.onFinish.call(signUpBody);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: [
        SelectImageWidget(
            onSelectImage: (img) => _listenToData(signUpBody.copyWith(image: img))
        ),
        SignUpTextField(
          validator: Validators.validateEmpty,
          upperTitle: LocaleKeys.name,
          title: LocaleKeys.pleaseEnterYourName,
          onChanged: (val) => _listenToData(signUpBody.copyWith(
              name: _getContBasedUserType(
                      whenMale: _maleNameCont,
                      whenFemale: _femaleNameCont,
                      whenParent: _parentNameCont)
                  .text)),
          controller: _getContBasedUserType(
              whenMale: _maleNameCont,
              whenFemale: _femaleNameCont,
              whenParent: _parentNameCont),
          // validator: Validators.validateEmpty,
        ),
        SignUpTextField(
          validator: Validators.validatePhone,
          upperTitle: LocaleKeys.phoneNumber,
          maxLength: 10,
          title: LocaleKeys.pleaseEnterTheNumber,
          controller: _getContBasedUserType(
              whenMale: _malePhoneCont,
              whenFemale: _femalePhoneCont,
              whenParent: _parentPhoneCont),
          onChanged: (val) => _listenToData(signUpBody.copyWith(
              phone: _getContBasedUserType(
                      whenMale: _malePhoneCont,
                      whenFemale: _femalePhoneCont,
                      whenParent: _parentPhoneCont)
                  .text)),
          // validator: Validators.validatePhone,
          inputType: TextInputType.number,
        ),
        Visibility(
          visible: widget.type.isParent,
          child: SignUpTextField(
            validator: Validators.validateEmail,
            upperTitle: LocaleKeys.email,
            title: LocaleKeys.pleaseEnterTheEmail,
            controller: _emailCont,
            onChanged: (val) => _listenToData(
                (signUpBody as ParentSignUp).copyWith(email: _emailCont.text)),
            inputType: TextInputType.emailAddress,
            // validator: Validators.validateEmpty,
          ),
        ),
        Visibility(
          visible: widget.type.isIndividual,
          child: SignUpTextField(
            validator: Validators.validateAge,
            upperTitle: LocaleKeys.age,
            title: LocaleKeys.pleaseEnterYourAge,
            onChanged: (val) => _listenToData(
                (signUpBody as MaleAndFemaleSignUp).copyWith(
                    age: _getContBasedUserType(
                            whenMale: _maleAgeCont, whenFemale: _femaleAgeCont)
                        .text)),
            controller: _getContBasedUserType(
                whenMale: _maleAgeCont, whenFemale: _femaleAgeCont),
            inputType: TextInputType.number,
            // validator: Validators.validateEmpty,
          ),
        ),
        // SignUpTextField(
        //   validator: Validators.validateEmpty,
        //   upperTitle: LocaleKeys.identifyNumber,
        //   title: LocaleKeys.pleaseEnterTheNumber,
        //   controller: _getContBasedUserType(
        //       whenMale: _maleIdentifyNumberCont,
        //       whenFemale: _femaleIdentifyNumberCont,
        //       whenParent: _parentIdentifyNumberCont),
        //   onChanged: (val) => _listenToData(signUpBody.copyWith(
        //       identityNumber: _getContBasedUserType(
        //               whenMale: _maleIdentifyNumberCont,
        //               whenFemale: _femaleIdentifyNumberCont,
        //               whenParent: _parentIdentifyNumberCont)
        //           .text)),
        //   inputType: TextInputType.number,
        //   // validator: Validators.validateEmpty,
        // ),
        if (widget.type.isParent) ...[
          AppDropinity<List<Kinship>, Kinship>.withApiRequest(
            controller: controller,
            initialValue: _kinship,
            asyncCall: (context, page) async => await AuthData.getKinships(),
            getLabel: (e) => e.value,
            hint: LocaleKeys.pleaseEnterTheKinship,
            title: LocaleKeys.kinship,
            onChanged: (val) {
              _kinship = val;
              _listenToData(
                  (signUpBody as ParentSignUp).copyWith(kinship: val.id));
            },
            cacheKey: 'kinships',
            cacheToJson: (e) => e.toJson(),
            cacheFromJson: (json) => Kinship.fromJson(json),
          ),
          SignUpTextField(
            validator: Validators.validateEmpty,
            upperTitle: LocaleKeys.childrenNumber,
            title: LocaleKeys.pleaseEnterTheNumber,
            controller: _childrenNumberCont,
            inputType: TextInputType.number,
            onChanged: (val) => _listenToData((signUpBody as ParentSignUp)
                .copyWith(childrenNumber: _childrenNumberCont.text)),
          ),
          AppDropinityLocal<UserGender>(
              listHeight: 100,
              hint: _gender?.translate ?? LocaleKeys.pleaseEnterTheGender,
              initialValue: _gender,
              title: LocaleKeys.gender,
              values: const [UserGender.male, UserGender.female],
              getLabel: (element) => element.translate,
              onChanged: (val) {
                _gender = val;
                _listenToData(
                    (signUpBody as ParentSignUp).copyWith(gender: val.name));
              }),
        ],
        SignUpTextField(
          upperTitle: LocaleKeys.code,
          // validator: Validators.validateEmpty,
          title: LocaleKeys.pleaseEnterYourCode,
          onChanged: (val) => _listenToData(signUpBody.copyWith(
              code: _getContBasedUserType(
                      whenMale: _maleCodeCont,
                      whenFemale: _femaleCodeCont,
                      whenParent: _parentCodeCont)
                  .text)),
          controller: _getContBasedUserType(
              whenMale: _maleCodeCont,
              whenFemale: _femaleCodeCont,
              whenParent: _parentCodeCont),
          // validator: Validators.validateEmpty,
        ),
      ],
    );
  }
}
