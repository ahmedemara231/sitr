part of '../../imports.dart';

enum ComesFrom { signUpAsPartner, signUpAsParent, editProfile }

class EnterMaleOrFemaleOrChildDataScreen extends StatefulWidget {
  final ComesFrom from;
  final UserType? type;
  final UserType? secondaryType;

  const EnterMaleOrFemaleOrChildDataScreen.signUpAsPartner({
    super.key,
    required this.type
  })  : from = ComesFrom.signUpAsPartner,
        secondaryType = null;

  const EnterMaleOrFemaleOrChildDataScreen.signUpAsParent({
    super.key,
  })  : from = ComesFrom.signUpAsParent,
        type = null,
        secondaryType = UserType.parent;

  EnterMaleOrFemaleOrChildDataScreen.editProfile({
    super.key,
  }) : type = UserModel.currentUser.gender?.userType,
        from = ComesFrom.editProfile,
        secondaryType = null;

  @override
  State<EnterMaleOrFemaleOrChildDataScreen> createState() => _EnterMaleOrFemaleOrChildDataScreenState();
}

class _EnterMaleOrFemaleOrChildDataScreenState extends State<EnterMaleOrFemaleOrChildDataScreen> {
  late final ValueNotifier<UserType> _mainType;

  void _init() {
    _mainType = ValueNotifier(widget.type ?? UserType.male);
  }

  SharedFormFieldModel sharedFormFieldModel = SharedFormFieldModel.initial();

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CenterCardScaffold(
        upperWidget: const SignUpUpperWidget(),
        body: BlocProvider(
          create: (context) => CompleteProfileCubit(),
          child: Column(
            spacing: 10.h,
            children: [
              if (widget.type.isNull)
                BlocBuilder<CompleteProfileCubit, AsyncState>(
                  builder: (context, state) => ChooseGenderWidget(
                    canChoose: !state.isLoading,
                    onSelectGender: (selectedGender) => _mainType.value = selectedGender,
                    genders: const [
                      UserType.male,
                      UserType.female,
                    ],
                  ),
                ),

              ValueListenableBuilder(
                valueListenable: _mainType,
                builder: (context, value, child) => value.isFemale
                    ? FemaleFields(
                        secondaryUserType: widget.secondaryType,
                        onFinishFemaleData: (data) => sharedFormFieldModel = data
                ) : MaleFields(
                        secondaryType: widget.secondaryType,
                        onFinishMaleData: (data) => sharedFormFieldModel = data
                ),
              ),

              const ConditionsTermsAcceptance(),
              Builder(builder: (ctx) {
                return DefaultButton(
                  onTap: () async => await ctx.read<CompleteProfileCubit>().completeProfile(
                      isParent: widget.secondaryType.isNotNull,
                      body: sharedFormFieldModel,
                      onSuccess: () {
                        Go.offAll(const LoginScreen());
                        // MessageUtils.showSnackBar();
                      }
                    )
                );
              }),
              if (widget.from == ComesFrom.signUpAsPartner)
                const AlreadyHaveAccWidget()
            ],
          ),
        ));
  }
}
