import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/widgets/text.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/extensions/object.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../core/widgets/scaffolds/auth_scaffold.dart';
import '../../models/complete_profile_body.dart';
import '../../models/shared_form_fields_model.dart';
import '../cubits/complete_profile_cubit.dart';
import '../widgets/shared/choose_gender.dart';
import '../widgets/shared/text_field.dart';
import '../widgets/sign_up/already_have_acc.dart';
import '../widgets/sign_up/conditions_terms_acceptance.dart';
import '../widgets/sign_up/dowry_widget.dart';
import '../widgets/sign_up/drop_down_text_field.dart';
import '../widgets/sign_up/image_widget.dart';
import '../widgets/sign_up/radio_widget.dart';
import '../widgets/sign_up/shared_form_fields.dart';
import '../widgets/sign_up/sign_up_upper_widget.dart';

enum ComesFrom{signUpAsPartner, signUpAsParent}
class EnterMaleOrFemaleOrChildDataScreen extends StatefulWidget {
  final ComesFrom from;
  final UserType? type;
  final UserType? secondaryType;
  const EnterMaleOrFemaleOrChildDataScreen.signUpAsPartner({
    super.key,
    required this.type,
}) : from = ComesFrom.signUpAsPartner, secondaryType = null;

  const EnterMaleOrFemaleOrChildDataScreen.signUpAsParent({
    super.key,
  }) : from = ComesFrom.signUpAsParent, type = null, secondaryType = UserType.parent;

  @override
  State<EnterMaleOrFemaleOrChildDataScreen> createState() => _EnterMaleOrFemaleOrChildDataScreenState();
}

class _EnterMaleOrFemaleOrChildDataScreenState extends State<EnterMaleOrFemaleOrChildDataScreen> {
  UserType mainType = UserType.male;
  late TextEditingController _nameCont;
  late TextEditingController _phoneCont;
  late TextEditingController _identifyNumberCont;
  late TextEditingController _ageCont;
  late TextEditingController _liveAfterMarryCont;
  late TextEditingController _parentNameCont;
  late TextEditingController _parentNumberCont;
  late TextEditingController _kinshipCont;
  late TextEditingController _dowryMinCont;
  late TextEditingController _dowryMaxCont;
  late String wearingHijab;
  late Answer acceptsPolygamy;
  late String degreeOfCommitment;
  late SharedFormFieldModel sharedFormFieldModel;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    mainType = widget.type?? UserType.male;
    sharedFormFieldModel = SharedFormFieldModel.initial();
    _nameCont = TextEditingController();
    _phoneCont = TextEditingController();
    _identifyNumberCont = TextEditingController();
    _ageCont = TextEditingController();
    _liveAfterMarryCont = TextEditingController();
    _parentNameCont = TextEditingController();
    _parentNumberCont = TextEditingController();
    _kinshipCont = TextEditingController();
    _dowryMinCont = TextEditingController();
    _dowryMaxCont = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameCont.dispose();
    _phoneCont.dispose();
    _identifyNumberCont.dispose();
    _ageCont.dispose();
    _liveAfterMarryCont.dispose();
    _parentNameCont.dispose();
    _parentNumberCont.dispose();
    _kinshipCont.dispose();
    _dowryMinCont.dispose();
    _dowryMaxCont.dispose();
    super.dispose();
  }

  File? selectedImage;

  Widget get _getMaleFields{
    switch(widget.secondaryType){
      case null:
        return SharedFormFields(
          onFinished: (data) => sharedFormFieldModel = data.copyWith(),
          onInitData: (List<Widget> children) {},
        );

      default:
        return SharedFormFields(
          onFinished: (data) => sharedFormFieldModel = data.copyWith(),
          onInitData: (List<Widget> children) => children..insert(
              0,
            SignUpTextField(
              upperTitle: LocaleKeys.name,
              title: LocaleKeys.pleaseEnterName,
              controller: _nameCont,
              // validator: Validators.validateEmpty,
            ),
          )..insertAll(
            2,
            [
              SignUpImageWidget(onSelectImage: (image) => selectedImage = image),
              SignUpTextField(
                upperTitle: LocaleKeys.phoneNumber,
                title: LocaleKeys.pleaseEnterTheNumber,
                controller: _phoneCont,
                // validator: Validators.validateEmpty,
              ),
            ],
          ),
        );
    }
  }

  Widget get _getFemaleFields{
    switch(widget.secondaryType){
      case null:
        return SharedFormFields(
          onFinished: (data) => sharedFormFieldModel = data.copyWith(),
          onInitData: (List<Widget> children) => children..insertAll(11, [
            DowryWidget(onSelect: (from, to) {
              _dowryMinCont.text = from;
              _dowryMaxCont.text = to;
            }),
          ])..insertAll(17, [
            SignUpTextField(
              upperTitle: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage,
              title: LocaleKeys.pleaseEnterTheNumber,
              controller: _liveAfterMarryCont,
              // validator: Validators.validateEmpty,
            ),
          ])..insertAll(18, [
            RadioWidget<Answer>(
                title: LocaleKeys.doYouAcceptPolygamy,
                onSubmit: (result) => acceptsPolygamy = result,
                values: Answer.values,
                titles: [AppText(LocaleKeys.yes), AppText(LocaleKeys.no)]
            ),

          ])..insertAll(23, [
            DropDownTextField(title: LocaleKeys.areYouWaringHijab, onChanged: (val) => wearingHijab = val??''),
            DropDownTextField(title: LocaleKeys.degreeOfCommitment, onChanged: (val) => degreeOfCommitment = val ?? ''),
            SignUpTextField(
              upperTitle: LocaleKeys.parentName,
              title: LocaleKeys.pleaseEnterName,
              controller: _parentNameCont,
              // validator: Validators.validateEmpty,
            ),
            SignUpTextField(
              upperTitle: LocaleKeys.parentNumber,
              title: LocaleKeys.pleaseEnterTheNumber,
              controller: _parentNumberCont,
              // validator: Validators.validateEmpty,
            ),
            SignUpTextField(
              upperTitle: LocaleKeys.kinship,
              title: LocaleKeys.pleaseEnterTheKinship,
              controller: _kinshipCont,
              // validator: Validators.validateEmpty,
            ),
          ]),
        );

      default:
        return SharedFormFields(
          onFinished: (data) => sharedFormFieldModel = data.copyWith(),
          onInitData: (List<Widget> children) => children..insertAll(11, [
            DowryWidget(onSelect: (from, to) {
              _dowryMinCont.text = from;
              _dowryMaxCont.text = to;
            }),
          ])..insertAll(17, [
            SignUpTextField(
              upperTitle: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage,
              title: LocaleKeys.pleaseEnterTheNumber,
              controller: _liveAfterMarryCont,
              // validator: Validators.validateEmpty,
            ),
          ])..insertAll(18, [
            RadioWidget<Answer>(
                title: LocaleKeys.doYouAcceptPolygamy,
                onSubmit: (result) => acceptsPolygamy = result,
                values: Answer.values,
                titles: [AppText(LocaleKeys.yes), AppText(LocaleKeys.no)]
            ),

          ])..insertAll(23, [
            DropDownTextField(title: LocaleKeys.areYouWaringHijab, onChanged: (val) => wearingHijab = val??''),
            DropDownTextField(title: LocaleKeys.degreeOfCommitment, onChanged: (val) => degreeOfCommitment = val ?? ''),
            SignUpTextField(
              upperTitle: LocaleKeys.parentName,
              title: LocaleKeys.pleaseEnterName,
              controller: _parentNameCont,
              // validator: Validators.validateEmpty,
            ),
            SignUpTextField(
              upperTitle: LocaleKeys.parentNumber,
              title: LocaleKeys.pleaseEnterTheNumber,
              controller: _parentNumberCont,
              // validator: Validators.validateEmpty,
            ),
            SignUpTextField(
              upperTitle: LocaleKeys.kinship,
              title: LocaleKeys.pleaseEnterTheKinship,
              controller: _kinshipCont,
              // validator: Validators.validateEmpty,
            ),
          ])..insert(0, SignUpTextField(
            upperTitle: LocaleKeys.name,
            title: LocaleKeys.pleaseEnterName,
            controller: _nameCont,
            // validator: Validators.validateEmpty,
          ),),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CenterCardScaffold(
        upperWidget: const SignUpUpperWidget(),
        body: Column(
          spacing: 10.h,
          children: [
            if(widget.type.isNull)
              ChooseGenderWidget(
                onSelectGender: (selectedGender) => setState(() => mainType = selectedGender),
                genders: const [
                  UserType.male,
                  UserType.female,
                ],
              ),

            UserTypeHelper.drowWidget(
                drow: (_) {
                  if(mainType.isFemale){
                    return _getFemaleFields;

                  }else if(mainType.isMale){
                    return _getMaleFields;

                  }else{
                    return const SizedBox.shrink();
                  }
                }
            ),

            const ConditionsTermsAcceptance(),
            AppLoadingButton(
              asyncCall: (ctx) async{
                if(_formKey.currentState!.validate()){
                  final CompleteProfileModel model = CompleteProfileModel(
                      nickName: sharedFormFieldModel.nickName,
                      maritalStatus: sharedFormFieldModel.maritalStatus,
                      height: sharedFormFieldModel.tall,
                      weight: sharedFormFieldModel.weight,
                      currentJob: sharedFormFieldModel.currentJob,
                      bio: sharedFormFieldModel.quickBrief,  // drop down
                      hasChildren: sharedFormFieldModel.childrenExists,
                      numOfChildren: sharedFormFieldModel.childrenNumber,
                      childCustody: sharedFormFieldModel.nursery?.name,  // drop down
                      wantChildren: sharedFormFieldModel.wantToHaveChildren,
                      prohibitedThings: sharedFormFieldModel.thingsIAcceptOrWant,
                      dowryMin: _dowryMinCont.text,
                      dowryMax: _dowryMaxCont.text,
                      weddingType: sharedFormFieldModel.typeOfWeddingParty,
                      city: sharedFormFieldModel.city,
                      educationLevel: sharedFormFieldModel.educationalQualification,
                      isPrayer: sharedFormFieldModel.pray,
                      healthConditions: sharedFormFieldModel.diseasesIfExists,
                      chatLang: sharedFormFieldModel.inChatYouPrefer?.title,
                      isSmoker: sharedFormFieldModel.smoke,
                      tribeAffiliation: sharedFormFieldModel.belongToATribe,
                      skinColor: sharedFormFieldModel.skinColor,
                      religiousCommitment: degreeOfCommitment,
                      preferredResidenceAfterMarriage: _liveAfterMarryCont.text,
                      hijabWearing: wearingHijab, // answer
                      acceptsPolygamy: acceptsPolygamy,
                      parentName: _parentNameCont.text,
                      parentRelationId: _kinshipCont.text,
                      parentPhone: _parentNumberCont.text,
                  );
                  ctx.read<CompleteProfileCubit>().completeProfile(model);
                }
              },
              title: LocaleKeys.confirm,
            ),
            if(widget.from == ComesFrom.signUpAsPartner)
              const AlreadyHaveAccWidget()
          ],
        )
    );
  }
}