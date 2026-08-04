import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/language/languages.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/extensions/enum.dart';
import '../../../../../core/extensions/object.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/helpers/validators.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/shared/models/title_value_shape.dart';
import '../../../../../core/shared/models/user_models/individual/female_model.dart';
import '../../../../../core/shared/models/user_models/individual/individual_user_model.dart';
import '../../../../../core/shared/models/user_models/individual/male_model.dart';
import '../../../../../core/shared/models/user_models/user_model.dart';
import '../../../../../core/widgets/app_dropinity.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/first_validation_error_form.dart';
import '../../data/auth_data.dart';
import '../../enums/answer.dart';
import '../shared/text_field.dart';
import 'dowry_widget.dart';
import 'individual_validation_field.dart';
import 'radio_widget.dart';

class SharedFormFields<T extends IndividualUserModel> extends StatefulWidget {
  final String? restorationId;
  final FirstValidationErrorFieldKeys validationFieldKeys;
  final IndividualUserModel? initialValue;
  final void Function(T sharedFields) onChanged;
  final void Function(List<Widget> children)? onInitData;
  const SharedFormFields({
    super.key,
    this.restorationId,
    required this.validationFieldKeys,
    required this.onChanged,
    this.onInitData,
    this.initialValue,
  });

  @override
  State<SharedFormFields<T>> createState() => _SharedFormFieldsState<T>();
}

class _SharedFormFieldsState<T extends IndividualUserModel>
    extends State<SharedFormFields<T>> {
  late TextEditingController _nickNameCont;
  late TextEditingController _tallCont;
  late TextEditingController _weightCont;
  late TextEditingController _currentJobCont;
  late TextEditingController _briefCont;
  late TextEditingController _childrenNumberCont;
  late TextEditingController _thingsCont;
  late TextEditingController _educationalQualificationCont;
  late TextEditingController _diseasesCont;
  late final ValueNotifier<Answer?> childrenExits = ValueNotifier(null);
  late final ValueNotifier<String> martialStatus = ValueNotifier('')
    ..addListener(_martialStatusListener);

  void _martialStatusListener() {
    if (martialStatus.value == 'single') {
      childrenExits.value = Answer.no;
      log('the children exists is ${childrenExits.value}');
    }
  }

  late T model;

  void _initIndividualOrChild(IndividualUserModel element) {
    model = element.copyWith() as T;

    // if(UserModel.isIndividual){
    //   model = element.copyWith() as T;
    //
    // }else if(UserModel.isParent){
    //   AuthData.childrenList.add(element.copyWith());
    //   model = AuthData.childrenList[AuthData.childrenList.length - 1] as T;
    // }
  }

  void _init() {
    if (T == MaleModel) {
      _initIndividualOrChild(MaleModel.initial());
    } else if (T == FemaleModel) {
      _initIndividualOrChild(FemaleModel.initial());
    } else {
      _initIndividualOrChild(IndividualUserModel.initial());
    }
  }

  void _listenToData(T updatedModel) {
    model = updatedModel;
    widget.onChanged.call(model);
  }

  void _childrenExitsListener() {
    if (childrenExits.value.isNo) {
      _childrenNumberCont.clear();
      _listenToData((model.copyWith(childCustody: null)) as T);
    }
  }

  void _listenToModelChanges() {
    childrenExits.addListener(_childrenExitsListener);
  }

  // IndividualUserModel get asIndividualUserModel => UserModel.currentUser as IndividualUserModel;

  @override
  void initState() {
    _init();
    _listenToModelChanges();
    _nickNameCont = TextEditingController(text: widget.initialValue?.nickName);
    _tallCont = TextEditingController(text: widget.initialValue?.height);
    _weightCont = TextEditingController(text: widget.initialValue?.weight);
    _currentJobCont =
        TextEditingController(text: widget.initialValue?.currentJob);
    _briefCont = TextEditingController(text: widget.initialValue?.bio);
    _childrenNumberCont = TextEditingController(
        text: (widget.initialValue?.numOfChildren).isNull
            ? null
            : widget.initialValue?.numOfChildren.toString());
    _thingsCont =
        TextEditingController(text: widget.initialValue?.prohibitedThings);
    _educationalQualificationCont =
        TextEditingController(text: widget.initialValue?.educationLevel);
    _diseasesCont =
        TextEditingController(text: widget.initialValue?.healthConditions);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SharedFormFields<T> oldWidget) {
    _init();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _nickNameCont.dispose();
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
        key: widget.validationFieldKeys.get(
          IndividualValidationField.nickname,
        ),
        upperTitle: LocaleKeys.nickname,
        title: LocaleKeys.pleaseEnterYourName,
        controller: _nickNameCont,
        onChanged: (val) => _listenToData(model.copyWith(nickName: val) as T),
        validator: (v) =>
            Validators.validateEmpty(v, fieldTitle: LocaleKeys.nickname.tr()),
      ),
      AppDropinity<List<TitleValueShape>, TitleValueShape>.withApiRequest(
        key: widget.validationFieldKeys.get(
          IndividualValidationField.maritalStatus,
        ),
        listHeight: 100,
        hint: LocaleKeys.pleaseEnterMartialStatus,
        initialValue: widget.initialValue?.maritalStatus,
        title: LocaleKeys.maritalStatus,
        asyncCall: (BuildContext ctx, int page) async =>
            await AuthData.getPersonalData(ApiConstants.maritalStatuses),
        getLabel: (element) => element.title,
        onChanged: (val) {
          _listenToData(model.copyWith(maritalStatus: val) as T);
          martialStatus.value = val.value;
        },
        validator: (e) => Validators.validateEmpty(e?.title),
        cacheKey: 'marital_statuses',
        cacheToJson: (e) => e.toJson(),
        cacheFromJson: (json) => TitleValueShape.fromJson(json),
      ),

      SignUpTextField(
        key: widget.validationFieldKeys.get(
          IndividualValidationField.height,
        ),
        upperTitle: LocaleKeys.tall,
        title: LocaleKeys.pleaseEnterTheTall,
        controller: _tallCont,
        inputType: TextInputType.number,
        onChanged: (val) => _listenToData(model.copyWith(height: val) as T),
        validator: (v) => Validators.validateNumeric(v,
            min: 75, max: 250, fieldTitle: LocaleKeys.tall.tr()),
      ),
      SignUpTextField(
        key: widget.validationFieldKeys.get(
          IndividualValidationField.weight,
        ),
        upperTitle: LocaleKeys.weight,
        title: LocaleKeys.pleaseEnterTheWeight,
        controller: _weightCont,
        inputType: TextInputType.number,
        onChanged: (val) => _listenToData(model.copyWith(weight: val) as T),
        validator: (v) => Validators.validateNumeric(v,
            min: 30, max: 300, fieldTitle: LocaleKeys.weight.tr()),
      ),
      SignUpTextField(
        key: widget.validationFieldKeys.get(
          IndividualValidationField.currentJob,
        ),
        upperTitle: LocaleKeys.currentJob,
        title: LocaleKeys.pleaseEnterTheCurrentJob,
        controller: _currentJobCont,
        onChanged: (val) => _listenToData(model.copyWith(currentJob: val) as T),
        validator: (v) => Validators.validateString(v,
            min: 3, max: 100, fieldTitle: LocaleKeys.currentJob.tr()),
      ),
      SignUpTextField(
        key: widget.validationFieldKeys.get(IndividualValidationField.bio),
        upperTitle: LocaleKeys.quickBrief,
        title: LocaleKeys.pleaseEnterTheBrief,
        controller: _briefCont,
        inputType: TextInputType.multiline,
        onChanged: (val) => _listenToData(model.copyWith(bio: val) as T),
        validator: (v) => Validators.validateString(v,
            min: 3, max: 1000, fieldTitle: LocaleKeys.quickBrief.tr()),
      ),
      // if(model.maritalStatus?.value == 'single')

      ValueListenableBuilder(
        valueListenable: martialStatus,
        builder: (context, value, child) =>
            value.isNotEmpty && value != 'single'
                ? RadioWidget<Answer>(
                    initialValue: widget.initialValue?.hasChildren?.toAnswer,
                    title: LocaleKeys.childrenExists,
                    onSubmit: (result) {
                      childrenExits.value = result;
                      _listenToData(
                          model.copyWith(hasChildren: result.toBool) as T);
                    },
                    values: Answer.values,
                    titleBuilder: (i) => AppText(Answer.values[i].translate),
                  )
                : const SizedBox.shrink(),
      ),
      ValueListenableBuilder(
        valueListenable: childrenExits,
        builder: (context, value, child) => value.isYes
            ? Column(
                spacing: 12.h,
                children: [
                  SignUpTextField(
                    key: widget.validationFieldKeys.get(
                      IndividualValidationField.childrenNumber,
                    ),
                    upperTitle: LocaleKeys.childrenNumber,
                    title: LocaleKeys.pleaseEnterTheNumber,
                    controller: _childrenNumberCont,
                    inputType: TextInputType.number,
                    onChanged: (val) => _listenToData(
                        model.copyWith(numOfChildren: int.parse(val!)) as T),
                    validator: (v) => Validators.validateInteger(v,
                        min: 0,
                        max: 100,
                        fieldTitle: LocaleKeys.childrenNumber.tr()),
                  ),
                  AppDropinity<List<TitleValueShape>,
                      TitleValueShape>.withApiRequest(
                    key: widget.validationFieldKeys.get(
                      IndividualValidationField.childCustody,
                    ),
                    initialValue: widget.initialValue?.childCustody,
                    hint: LocaleKeys.nursery,
                    title: LocaleKeys.nursery,
                    asyncCall: (BuildContext ctx, int page) async =>
                        await AuthData.getPersonalData(
                            ApiConstants.childCustodies),
                    getLabel: (element) => element.title,
                    onChanged: (result) => _listenToData(
                        model.copyWith(childCustody: result) as T),
                    validator: (e) => Validators.validateEmpty(e?.title),
                    cacheKey: 'child_custodies',
                    cacheToJson: (e) => e.toJson(),
                    cacheFromJson: (json) => TitleValueShape.fromJson(json),
                  )
                ],
              )
            : const SizedBox.shrink(),
      ),

      RadioWidget<Answer>(
        initialValue: widget.initialValue?.wantChildren?.toAnswer,
        title: LocaleKeys.wantToHaveChildren,
        onSubmit: (result) =>
            _listenToData(model.copyWith(wantChildren: result.toBool) as T),
        values: Answer.values,
        titleBuilder: (i) => AppText(Answer.values[i].translate),
      ),
      SignUpTextField(
        key: widget.validationFieldKeys.get(
          IndividualValidationField.prohibitedThings,
        ),
        upperTitle: LocaleKeys.thingsIAbsolutelyDoNotAcceptOrWant,
        title: LocaleKeys.pleaseEnterTheThings,
        inputType: TextInputType.multiline,
        controller: _thingsCont,
        onChanged: (val) =>
            _listenToData(model.copyWith(prohibitedThings: val) as T),
        validator: (v) => Validators.validateString(v,
            min: 3,
            max: 1000,
            fieldTitle: LocaleKeys.thingsIAbsolutelyDoNotAcceptOrWant.tr()),
      ),

      DowryWidget(
          initialValue: widget.initialValue?.dowry,
          onSelect: (dowryVal) =>
              _listenToData(model.copyWith(dowry: dowryVal) as T)),

      AppDropinity<List<TitleValueShape>, TitleValueShape>.withApiRequest(
        listHeight: 100,
        hint: LocaleKeys.pleaseEnterTheWeddingParty,
        initialValue: widget.initialValue?.weddingType,
        title: LocaleKeys.typeOfWeddingParty,
        asyncCall: (BuildContext ctx, int page) async =>
            await AuthData.getPersonalData(ApiConstants.weddingTypes),
        getLabel: (element) => element.title,
        onChanged: (val) => _listenToData(model.copyWith(
            weddingType: TitleValueShape.fromSingleLabel(val.value)) as T),
        cacheKey: 'wedding_types',
        cacheToJson: (e) => e.toJson(),
        cacheFromJson: (json) => TitleValueShape.fromJson(json),
      ),

      AppDropinity<List<CityModel>, CityModel>.withApiRequest(
        key: widget.validationFieldKeys.get(IndividualValidationField.city),
        initialValue: widget.initialValue?.cityId,
        hint: LocaleKeys.pleaseEnterTheCity,
        title: LocaleKeys.city,
        asyncCall: (context, page) async => await AuthData.getCities(),
        getLabel: (city) => city.name ?? '',
        onChanged: (val) => _listenToData(model.copyWith(cityId: val) as T),
        validator: (e) => Validators.validateEmpty(e?.name),
        cacheKey: 'cities',
        cacheToJson: (e) => e.toJson(),
        cacheFromJson: (json) => CityModel.fromJson(json),
        // validator: (v) => Validators.validateDropDown<String>(
        //     v?.name,
        //     fieldTitle: LocaleKeys.city.tr()
        // ),
      ),

      SignUpTextField(
        key: widget.validationFieldKeys.get(
          IndividualValidationField.educationLevel,
        ),
        upperTitle: LocaleKeys.educationalQualification,
        title: LocaleKeys.pleaseEnterTheEducationalQualification,
        controller: _educationalQualificationCont,
        onChanged: (val) =>
            _listenToData(model.copyWith(educationLevel: val) as T),
        validator: (v) => Validators.validateString(v,
            fieldTitle: LocaleKeys.educationalQualification.tr()),
      ),
      RadioWidget<Answer>(
        initialValue: widget.initialValue?.isPrayer?.toAnswer,
        title: LocaleKeys.areYouPray,
        onSubmit: (result) =>
            _listenToData(model.copyWith(isPrayer: result.toBool) as T),
        values: Answer.values,
        titleBuilder: (i) => AppText(Answer.values[i].translate),
      ),
      SignUpTextField(
        key: widget.validationFieldKeys.get(
          IndividualValidationField.healthConditions,
        ),
        upperTitle: LocaleKeys.diseasesIfExists,
        title: LocaleKeys.pleaseEnterTheDiseases,
        controller: _diseasesCont,
        onChanged: (val) =>
            _listenToData(model.copyWith(healthConditions: val) as T),
        validator: (v) => Validators.validateString(v,
            min: 3,
            max: 1000,
            isRequired: false,
            fieldTitle: LocaleKeys.diseasesIfExists.tr()),
      ),
      RadioWidget<Languages>(
        initialValue: widget.initialValue?.chatLang?.toLang(),
        title: LocaleKeys.inChatYouPrefer,
        onSubmit: (result) =>
            _listenToData(model.copyWith(chatLang: result.languageCode) as T),
        values: Languages.values,
        titleBuilder: (i) => AppText(Languages.values[i].translate),
      ),
      RadioWidget<Answer>(
        initialValue: widget.initialValue?.isSmoker?.toAnswer,
        title: LocaleKeys.areYouSmoke,
        onSubmit: (result) =>
            _listenToData(model.copyWith(isSmoker: result.toBool) as T),
        values: Answer.values,
        titleBuilder: (i) => AppText(Answer.values[i].translate),
      ),
      RadioWidget<Answer>(
        initialValue: widget.initialValue?.tribeAffiliation?.toAnswer,
        title: LocaleKeys.doYouBelongToATribe,
        onSubmit: (result) =>
            _listenToData(model.copyWith(tribeAffiliation: result.toBool) as T),
        values: Answer.values,
        titleBuilder: (i) => AppText(Answer.values[i].translate),
      ),

      AppDropinity<List<TitleValueShape>, TitleValueShape>.withApiRequest(
        listHeight: 100,
        hint: LocaleKeys.pleaseEnterSkinColor,
        initialValue: widget.initialValue?.skinColor,
        title: LocaleKeys.skinColor,
        asyncCall: (BuildContext ctx, int page) async =>
            await AuthData.getPersonalData(ApiConstants.skinColors),
        getLabel: (element) => element.title,
        onChanged: (val) => _listenToData(model.copyWith(
            skinColor: TitleValueShape.fromSingleLabel(val.value)) as T),
        cacheKey: 'skin_colors',
        cacheToJson: (e) => e.toJson(),
        cacheFromJson: (json) => TitleValueShape.fromJson(json),
      ),

      AppDropinity<List<TitleValueShape>, TitleValueShape>.withApiRequest(
        key: widget.validationFieldKeys.get(
          IndividualValidationField.religiousCommitment,
        ),
        listHeight: 100,
        hint: LocaleKeys.pleaseEnterTheDegreeOfCommitment,
        initialValue: widget.initialValue?.religiousCommitment,
        title: LocaleKeys.degreeOfCommitment,
        asyncCall: (BuildContext ctx, int page) async =>
            await AuthData.getPersonalData(ApiConstants.religiousCommitments),
        getLabel: (element) => element.title,
        onChanged: (value) => _listenToData(model.copyWith(
            religiousCommitment:
                TitleValueShape.fromSingleLabel(value.value)) as T),
        validator: (e) => Validators.validateEmpty(e?.title),
        cacheKey: 'religious_commitments',
        cacheToJson: (e) => e.toJson(),
        cacheFromJson: (json) => TitleValueShape.fromJson(json),
      ),
    ];

    widget.onInitData?.call(inputs);
    return inputs;
  }

  @override
  Widget build(BuildContext context) {
    return Column(spacing: 12.h, children: children);
  }
}
