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

  late SharedFormFieldModel sharedFormFieldModel;

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
                          sharedFormFieldModel = data.copyWith();
                        })
                    : MaleFields(
                        secondaryType: secondaryType,
                        onFinishMaleData: (data) =>
                            sharedFormFieldModel = data.copyWith()),
              ),

              const ConditionsTermsAcceptance(),
              Builder(builder: (ctx) {
                return DefaultButton(
                  onTap: () async {
                    await ctx
                        .read<CompleteProfileCubit>()
                        .completeProfile(sharedFormFieldModel);

                    // if(_formKey.currentState!.validate()){
                    //   final CompleteProfileModel model = CompleteProfileModel(
                    //     sharedFormFieldModel: sharedFormFieldModel,
                    //     dowryMin: _dowryMinCont.text,
                    //     dowryMax: _dowryMaxCont.text,
                    //     parentName: _parentNameCont.text,
                    //     parentRelationId: _kinshipCont.text,
                    //     parentPhone: _parentNumberCont.text,
                    //     liveAfterMarry: _liveAfterMarryCont.text,
                    //   );
                    //
                    //   await ctx.read<CompleteProfileCubit>().completeProfile(model);
                    // }
                  },
                );
              }),
              // AppLoadingButton(
              //   asyncCall: (ctx) async{
              //     if(_formKey.currentState!.validate()){
              //       final CompleteProfileModel model = CompleteProfileModel(
              //           nickName: sharedFormFieldModel.nickName,
              //           maritalStatus: sharedFormFieldModel.maritalStatus,
              //           height: sharedFormFieldModel.tall,
              //           weight: sharedFormFieldModel.weight,
              //           currentJob: sharedFormFieldModel.currentJob,
              //           bio: sharedFormFieldModel.quickBrief,  // drop down
              //           hasChildren: sharedFormFieldModel.childrenExists,
              //           numOfChildren: sharedFormFieldModel.childrenNumber,
              //           childCustody: sharedFormFieldModel.nursery?.name,  // drop down
              //           wantChildren: sharedFormFieldModel.wantToHaveChildren,
              //           prohibitedThings: sharedFormFieldModel.thingsIAcceptOrWant,
              //           dowryMin: _dowryMinCont.text,
              //           dowryMax: _dowryMaxCont.text,
              //           weddingType: sharedFormFieldModel.typeOfWeddingParty,
              //           city: sharedFormFieldModel.city,
              //           educationLevel: sharedFormFieldModel.educationalQualification,
              //           isPrayer: sharedFormFieldModel.pray,
              //           healthConditions: sharedFormFieldModel.diseasesIfExists,
              //           chatLang: sharedFormFieldModel.inChatYouPrefer?.title,
              //           isSmoker: sharedFormFieldModel.smoke,
              //           tribeAffiliation: sharedFormFieldModel.belongToATribe,
              //           skinColor: sharedFormFieldModel.skinColor,
              //           religiousCommitment: degreeOfCommitment,
              //           preferredResidenceAfterMarriage: _liveAfterMarryCont.text,
              //           hijabWearing: wearingHijab, // answer
              //           acceptsPolygamy: acceptsPolygamy,
              //           parentName: _parentNameCont.text,
              //           parentRelationId: _kinshipCont.text,
              //           parentPhone: _parentNumberCont.text,
              //       );
              //
              //       ctx.read<CompleteProfileCubit>().completeProfile(sharedFormFieldModel);
              //     }
              //   },
              //   title: LocaleKeys.confirm,
              // ),
              if (from == ComesFrom.signUpAsPartner)
                const AlreadyHaveAccWidget()
            ],
          ),
        ));
  }
}
