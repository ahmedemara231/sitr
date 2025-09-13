import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/language/languages.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/extensions/enum.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../models/city.dart';
import '../../../models/shared_form_fields_model.dart';
import '../../data/auth_data.dart';
import '../../enums/answer.dart';
import '../../enums/nursery.dart';
import '../../enums/skin.dart';
import '../../enums/wedding_party_type.dart';
import '../shared/text_field.dart';
import 'drop_down_text_field.dart';
import 'radio_widget.dart';


class SharedFormFields extends StatefulWidget {
  final String? restorationId;
  final SharedFormFieldModel sharedFormFieldModel;
  final void Function(SharedFormFieldModel sharedFields) onFinished;
  final void Function(List<Widget> children)? onInitData;
  const SharedFormFields({super.key,
    this.restorationId,
    required this.sharedFormFieldModel,
    required this.onFinished,
    this.onInitData,
  });

  @override
  State<SharedFormFields> createState() => _SharedFormFieldsState();
}

class _SharedFormFieldsState extends State<SharedFormFields>
    with RestorationMixin{

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_nickNameCont, '_nickNameCont');
    registerForRestoration(_statusCont, '_statusCont');
    registerForRestoration(_tallCont, '_tallCont');
    registerForRestoration(_weightCont, '_weightCont');
    registerForRestoration(_currentJobCont, '_currentJobCont');
    registerForRestoration(_briefCont, '_briefCont');
    registerForRestoration(_childrenNumberCont, '_childrenNumberCont');
    registerForRestoration(_thingsCont, '_thingsCont');
    registerForRestoration(
        _educationalQualificationCont, '_educationalQualificationCont');
    registerForRestoration(_diseasesCont, '_diseasesCont');
  }



  final SharedFormFieldModel sharedFields = SharedFormFieldModel.initial();

  final RestorableTextEditingController _nickNameCont =
  RestorableTextEditingController();
  final RestorableTextEditingController _statusCont =
  RestorableTextEditingController();
  final RestorableTextEditingController _tallCont =
  RestorableTextEditingController();
  final RestorableTextEditingController _weightCont =
  RestorableTextEditingController();
  final RestorableTextEditingController _currentJobCont =
  RestorableTextEditingController();
  final RestorableTextEditingController _briefCont =
  RestorableTextEditingController();
  final RestorableTextEditingController _childrenNumberCont =
  RestorableTextEditingController();
  final RestorableTextEditingController _thingsCont =
  RestorableTextEditingController();
  final RestorableTextEditingController _educationalQualificationCont =
  RestorableTextEditingController();
  final RestorableTextEditingController _diseasesCont =
  RestorableTextEditingController();


  // @override
  // void initState() {
  //   _nickNameCont = RestorableTextEditingController();
  //   _statusCont = RestorableTextEditingController();
  //   _tallCont = RestorableTextEditingController();
  //   _weightCont = RestorableTextEditingController();
  //   _currentJobCont = RestorableTextEditingController();
  //   _briefCont = RestorableTextEditingController();
  //   _childrenNumberCont = RestorableTextEditingController();
  //   _thingsCont = RestorableTextEditingController();
  //   _educationalQualificationCont = RestorableTextEditingController();
  //   _diseasesCont = RestorableTextEditingController();
  //
  //   super.initState();
  // }

  late SharedFormFieldModel model;
  void _init(){
    model = widget.sharedFormFieldModel.copyWith();
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _listenToData(SharedFormFieldModel updatedModel) {
    model = updatedModel;
    widget.onFinished.call(model);
  }

  @override
  void dispose() {
    _nickNameCont.dispose();
    _statusCont.dispose();
    _tallCont.dispose();
    _weightCont.dispose();
    _currentJobCont.dispose();
    _briefCont.dispose();
    _childrenNumberCont.dispose();
    _thingsCont.dispose();
    _educationalQualificationCont.dispose();
    _diseasesCont.dispose();
    super.dispose();
  }

  List<Widget> get children {
    final List<Widget> inputs = [
      SignUpTextField(
        upperTitle: LocaleKeys.nickname,
        title: LocaleKeys.pleaseEnterYourName,
        controller: _nickNameCont.value,
        onChanged: (val) => _listenToData(model.copyWith(nickName: val)),
        // validator: Validators.validateEmpty,
      ),
      SignUpTextField(
        upperTitle: LocaleKeys.maritalStatus,
        title: LocaleKeys.pleaseEnterTheStatus,
        controller: _statusCont.value,
        onChanged: (val) => _listenToData(model.copyWith(maritalStatus: val)),
        // validator: Validators.validatePhone,
      ),
      SignUpTextField(
        upperTitle: LocaleKeys.tall,
        title: LocaleKeys.pleaseEnterTheTall,
        controller: _tallCont.value,
        inputType: TextInputType.number,
        onChanged: (val) => _listenToData(model.copyWith(tall: val)),
        // validator: Validators.validateEmpty,
      ),
      SignUpTextField(
        upperTitle: LocaleKeys.weight,
        title: LocaleKeys.pleaseEnterTheWeight,
        controller: _weightCont.value,
        inputType: TextInputType.number,
        onChanged: (val) => _listenToData(model.copyWith(weight: val)),
        // validator: Validators.validateEmpty,
      ),

      SignUpTextField(
        upperTitle: LocaleKeys.currentJob,
        title: LocaleKeys.pleaseEnterTheCurrentJob,
        controller: _currentJobCont.value,
        onChanged: (val) => _listenToData(model.copyWith(currentJob: val)),
        // validator: Validators.validateEmpty,
      ),
      SignUpTextField(
        upperTitle: LocaleKeys.quickBrief,
        title: LocaleKeys.pleaseEnterTheBrief,
        controller: _briefCont.value,
        inputType: TextInputType.multiline,
        onChanged: (val) => _listenToData(model.copyWith(quickBrief: val)),
        // validator: Validators.validateEmpty,
      ),

      RadioWidget<Answer>(
          title: LocaleKeys.childrenExists,
          onSubmit: (result) =>
              setState(() => _listenToData(model.copyWith(childrenExists: result))),
          values: Answer.values,
          titles: [AppText(LocaleKeys.yes), AppText(LocaleKeys.no)]
      ),
      if(model.childrenExists?.isYes?? false)
        ...[
          SignUpTextField(
            upperTitle: LocaleKeys.childrenNumber,
            title: LocaleKeys.pleaseEnterTheNumber,
            controller: _childrenNumberCont.value,
            inputType: TextInputType.number,
            onChanged: (val) => _listenToData(model.copyWith(childrenNumber: val)),
            // validator: Validators.validateEmpty,
          ),

          RadioWidget<Nursery>(
              title: LocaleKeys.nursery,
              onSubmit: (result) => _listenToData(model.copyWith(nursery: result)),
              values: Nursery.values,
              titles: [AppText(LocaleKeys.father), AppText(LocaleKeys.mother)]
          ),
        ],
      RadioWidget<Answer>(
          title: LocaleKeys.wantToHaveChildren,
          onSubmit: (result) => _listenToData(model.copyWith(wantToHaveChildren: result)),
          values: Answer.values,
          titles: [AppText(LocaleKeys.yes), AppText(LocaleKeys.no)]
      ),

      SignUpTextField(
        upperTitle: LocaleKeys.thingsIAbsolutelyDoNotAcceptOrWant,
        title: LocaleKeys.pleaseEnterTheThings,
        controller: _thingsCont.value,
        onChanged: (val) => _listenToData(model.copyWith(thingsIAcceptOrWant: val)),
        // validator: Validators.validateEmpty,
      ),

      DropDownTextField<String>(
        hint: LocaleKeys.pleaseEnterTheWeddingParty,
        values: WeddingPartyType.values.map((e) => e.translate).toList(),
        title: LocaleKeys.typeOfWeddingParty,
        onChanged: (val) => _listenToData(model.copyWith(typeOfWeddingParty: val)),
      ),

        DropDownTextField<City>.withApiRequest(
          hint: LocaleKeys.pleaseEnterTheCity,
          title: LocaleKeys.city,
          onChanged: (val) => _listenToData(model.copyWith(city: val?.name)),
          request: (BuildContext ctx) async => await AuthData.getCities(),
          itemBuilder: (city) => AppText(city.name),
        ),

      SignUpTextField(
        upperTitle: LocaleKeys.educationalQualification,
        title: LocaleKeys.pleaseEnterTheEducationalQualification,
        controller: _educationalQualificationCont.value,
        onChanged: (val) => _listenToData(model.copyWith(educationalQualification: val)),
        // validator: Validators.validateEmpty,
      ),

      RadioWidget<Answer>(
          title: LocaleKeys.areYouPray,
          onSubmit: (result) => _listenToData(model.copyWith(pray: result)),
          values: Answer.values,
          titles: [AppText(LocaleKeys.yes), AppText(LocaleKeys.no)]
      ),

      SignUpTextField(
        upperTitle: LocaleKeys.diseasesIfExists,
        title: LocaleKeys.pleaseEnterTheDiseases,
        controller: _diseasesCont.value,
        onChanged: (val) => _listenToData(model.copyWith(diseasesIfExists: val)),
        // validator: Validators.validateEmpty,
      ),

      RadioWidget<Languages>(
          title: LocaleKeys.inChatYouPrefer,
          onSubmit: (result) => _listenToData(model.copyWith(inChatYouPrefer: result)),
          values: Languages.values,
          titles: [AppText(LocaleKeys.english), AppText(LocaleKeys.arabic)]
      ),
      RadioWidget<Answer>(
          title: LocaleKeys.areYouSmoke,
          onSubmit: (result) => _listenToData(model.copyWith(smoke: result)),
          values: Answer.values,
          titles: [AppText(LocaleKeys.yes), AppText(LocaleKeys.no)]
      ),

      RadioWidget<Answer>(
          title: LocaleKeys.doYouBelongToATribe,
          onSubmit: (result) => _listenToData(model.copyWith(belongToATribe: result)),
          values: Answer.values,
          titles: [AppText(LocaleKeys.yes), AppText(LocaleKeys.no)]
      ),

      DropDownTextField<String>(
        hint: LocaleKeys.pleaseEnterSkinColor,
        values: Skin.values.map((e) => e.translate).toList(),
        title: LocaleKeys.skinColor,
        onChanged: (val) => _listenToData(model.copyWith(skinColor: val)),
      ),
    ];

    widget.onInitData?.call(inputs);
    return inputs;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        spacing: 10.h,
        children: children
    );
  }
}