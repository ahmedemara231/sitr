part of '../../imports.dart';

enum ComesFrom { signUpAsPartner, signUpAsParent }

class EnterMaleOrFemaleOrChildDataScreen extends StatelessWidget {
  final ComesFrom from;
  final UserType? type;
  final UserType? secondaryType;

  EnterMaleOrFemaleOrChildDataScreen.signUpAsPartner({
    super.key,
    required this.type,
  })  : from = ComesFrom.signUpAsPartner,
        secondaryType = null;

  EnterMaleOrFemaleOrChildDataScreen.signUpAsParent({
    super.key,
  })  : from = ComesFrom.signUpAsParent,
        type = null,
        secondaryType = UserType.parent;

  late ValueNotifier<UserType> _mainType;

  void _init() {
    _mainType = ValueNotifier(type ?? UserType.male);
  }

  SharedFormFieldModel sharedFormFieldModel = SharedFormFieldModel.initial();

  @override
  Widget build(BuildContext context) {
    _init();
    return CenterCardScaffold(
        upperWidget: const SignUpUpperWidget(),
        body: BlocProvider(
          create: (context) => CompleteProfileCubit(),
          child: Column(
            spacing: 10.h,
            children: [
              if (type.isNull)
                ChooseGenderWidget(
                  onSelectGender: (selectedGender) =>
                      _mainType.value = selectedGender,
                  genders: const [
                    UserType.male,
                    UserType.female,
                  ],
                ),
              ValueListenableBuilder(
                valueListenable: _mainType,
                builder: (context, value, child) => value.isFemale
                    ? FemaleFields(
                        secondaryUserType: secondaryType,
                        onFinishFemaleData: (data) {
                          log('data in big screen ${data.toJson()}');
                          sharedFormFieldModel = data;
                          log(sharedFormFieldModel.toJson().toString());
                        })
                    : MaleFields(
                        secondaryType: secondaryType,
                        onFinishMaleData: (data) => sharedFormFieldModel = data),
              ),
              const ConditionsTermsAcceptance(),
              Builder(builder: (ctx) {
                return DefaultButton(
                  onTap: () async {
                    log('message : ${sharedFormFieldModel.toJson()}');
                    await ctx
                        .read<CompleteProfileCubit>()
                        .completeProfile(sharedFormFieldModel);
                  },
                );
              }),
              if (from == ComesFrom.signUpAsPartner)
                const AlreadyHaveAccWidget()
            ],
          ),
        ));
  }
}
