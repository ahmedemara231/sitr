import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/language/languages.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/extensions/enum.dart';
import '../../../../../core/shared/models/title_value_shape.dart';
import '../../../../../core/shared/models/user_models/individual/female_model.dart';
import '../../../../../core/shared/models/user_models/individual/individual_user_model.dart';
import '../../../../../core/shared/models/user_models/individual/male_model.dart';
import '../../../../../core/shared/models/user_models/user_model.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../models/dowry.dart';
import '../../data/auth_data.dart';
import '../../data/enums_data.dart';
import '../../enums/answer.dart';
import '../shared/text_field.dart';
import 'dowry_widget.dart';
import 'drop_down_text_field.dart';
import 'radio_widget.dart';

class SharedFormFields<T extends IndividualUserModel> extends StatefulWidget {
  final String? restorationId;
  final void Function(T sharedFields) onFinished;
  final void Function(List<Widget> children)? onInitData;
  const SharedFormFields({
    super.key,
    this.restorationId,
    required this.onFinished,
    this.onInitData,
  });

  @override
  State<SharedFormFields<T>> createState() => _SharedFormFieldsState<T>();
}

class _SharedFormFieldsState<T extends IndividualUserModel> extends State<SharedFormFields<T>> {

  late TextEditingController _nickNameCont;
  late TextEditingController _tallCont;
  late TextEditingController _weightCont;
  late TextEditingController _currentJobCont;
  late TextEditingController _briefCont;
  late TextEditingController _childrenNumberCont;
  late TextEditingController _thingsCont;
  late TextEditingController _educationalQualificationCont;
  late TextEditingController _diseasesCont;
  ValueNotifier<Answer?> childrenExits = ValueNotifier(null);

  late T model;

  void _init() {
    if(T == MaleModel){
      model = MaleModel.initial() as T;

    }else if(T == FemaleModel){
      model = FemaleModel.initial() as T;

    }else{
      model = IndividualUserModel.initial() as T;
    }
  }

  void _listenToData(T updatedModel, {String? comingVal}) {
    model = updatedModel;
    log(model.nickName.toString());
    widget.onFinished.call(model);
  }

  void _childrenExitsListener(){
    if(childrenExits.value.isNo){
      _childrenNumberCont.clear();
      _listenToData((model.copyWith(childCustody: null)) as T);
    }
  }

  void _listenToModelChanges(){
    childrenExits.addListener(_childrenExitsListener);
  }

  @override
  void initState() {
    _init();
    _listenToModelChanges();
    _nickNameCont = TextEditingController(text: model.nickName);
    _tallCont = TextEditingController(text: model.height);
    _weightCont = TextEditingController(text: model.weight);
    _currentJobCont = TextEditingController(text: model.currentJob);
    _briefCont = TextEditingController(text: model.bio);
    _childrenNumberCont = TextEditingController(text: model.numOfChildren);
    _thingsCont = TextEditingController(text: model.prohibitedThings);
    _educationalQualificationCont = TextEditingController(text: model.educationLevel);
    _diseasesCont = TextEditingController(text: model.healthConditions);
    super.initState();
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
        upperTitle: LocaleKeys.nickname,
        title: LocaleKeys.pleaseEnterYourName,
        controller: _nickNameCont,
        onChanged: (val) => _listenToData(model.copyWith(nickName: val) as T)
        // validator: Validators.validateEmpty,
      ),
      DropDownTextField<TitleValueShape>(
        title: LocaleKeys.maritalStatus,
        hint: LocaleKeys.pleaseEnterTheStatus,
        values: EnumsData.maritalStatus.data,
        itemBuilder: (v) => AppText(v.title.tr()),
        onChanged: (val) =>
            _listenToData(model.copyWith(maritalStatus: val) as T),
      ),
      SignUpTextField(
        upperTitle: LocaleKeys.tall,
        title: LocaleKeys.pleaseEnterTheTall,
        controller: _tallCont,
        inputType: TextInputType.number,
        onChanged: (val) => _listenToData(model.copyWith(height: val) as T),
        // validator: Validators.validateEmpty,
      ),
      SignUpTextField(
        upperTitle: LocaleKeys.weight,
        title: LocaleKeys.pleaseEnterTheWeight,
        controller: _weightCont,
        inputType: TextInputType.number,
        onChanged: (val) => _listenToData(model.copyWith(weight: val) as T),
        // validator: Validators.validateEmpty,
      ),
      SignUpTextField(
        upperTitle: LocaleKeys.currentJob,
        title: LocaleKeys.pleaseEnterTheCurrentJob,
        controller: _currentJobCont,
        onChanged: (val) => _listenToData(model.copyWith(currentJob: val) as T),
        // validator: Validators.validateEmpty,
      ),
      SignUpTextField(
        upperTitle: LocaleKeys.quickBrief,
        title: LocaleKeys.pleaseEnterTheBrief,
        controller: _briefCont,
        inputType: TextInputType.multiline,
        onChanged: (val) => _listenToData(model.copyWith(bio: val) as T),
        // validator: Validators.validateEmpty,
      ),
      RadioWidget<Answer>(
          title: LocaleKeys.childrenExists,
          onSubmit: (result) {
            childrenExits.value = result;
            _listenToData(model.copyWith(hasChildren: result.toBool) as T);
          },
          values: Answer.values,
          titleBuilder: (i) => AppText(Answer.values[i].translate),
      ),
      ValueListenableBuilder(
           valueListenable: childrenExits,
           builder: (context, value, child) => value.isYes? Column(
             children: [
               SignUpTextField(
                 upperTitle: LocaleKeys.childrenNumber,
                 title: LocaleKeys.pleaseEnterTheNumber,
                 controller: _childrenNumberCont,
                 inputType: TextInputType.number,
                 onChanged: (val) =>
                     _listenToData(model.copyWith(numOfChildren: val) as T),
                 // validator: Validators.validateEmpty,
               ),
               RadioWidget<TitleValueShape>(
                 title: LocaleKeys.nursery,
                 onSubmit: (result) => _listenToData(model.copyWith(childCustody: result) as T),
                 values: EnumsData.childCustody.data,
                 titleBuilder: (i) => AppText(EnumsData.childCustody.data[i].title.tr()),
                   // titles: (i) => [AppText(LocaleKeys.father), AppText(LocaleKeys.mother)]),
               )
             ],
           ) : const SizedBox.shrink(),
       ),

      RadioWidget<Answer>(
          title: LocaleKeys.wantToHaveChildren,
          onSubmit: (result) =>
              _listenToData(model.copyWith(wantChildren: result.toBool) as T),
          values: Answer.values,
          titleBuilder: (i) => AppText(Answer.values[i].translate),
      ),
      SignUpTextField(
        upperTitle: LocaleKeys.thingsIAbsolutelyDoNotAcceptOrWant,
        title: LocaleKeys.pleaseEnterTheThings,
        controller: _thingsCont,
        onChanged: (val) =>
            _listenToData(model.copyWith(prohibitedThings: val) as T),
        // validator: Validators.validateEmpty,
      ),
      DowryWidget(onSelect: (from, to) {
        log('the data is ${int.tryParse(from)}'); // 6666
        _listenToData(model.copyWith(dowry: Dowry(from: from, to: to)) as T);
      }),

      DropDownTextField<TitleValueShape>(
        hint: LocaleKeys.pleaseEnterTheWeddingParty,
        values: EnumsData.weddingTypes.data,
        title: LocaleKeys.typeOfWeddingParty,
        itemBuilder: (v) => AppText(v.title.tr()),
        onChanged: (val) =>
            _listenToData(model.copyWith(weddingType: TitleValueShape.fromSingleLabel(val?.value)) as T),
      ),
      DropDownTextField<CityModel>.withApiRequest(
        hint: LocaleKeys.pleaseEnterTheCity,
        title: LocaleKeys.city,
        onChanged: (val) => _listenToData(model.copyWith(cityId: val) as T),
        request: (BuildContext ctx) async => await AuthData.getCities(),
        itemBuilder: (city) => AppText(city.name ?? ''),
      ),
      SignUpTextField(
        upperTitle: LocaleKeys.educationalQualification,
        title: LocaleKeys.pleaseEnterTheEducationalQualification,
        controller: _educationalQualificationCont,
        onChanged: (val) =>
            _listenToData(model.copyWith(educationLevel: val) as T),
        // validator: Validators.validateEmpty,
      ),
      RadioWidget<Answer>(
          title: LocaleKeys.areYouPray,
          onSubmit: (result) =>
              _listenToData(model.copyWith(isPrayer: result.toBool) as T),
          values: Answer.values,
        titleBuilder: (i) => AppText(Answer.values[i].translate),
      ),
      SignUpTextField(
        upperTitle: LocaleKeys.diseasesIfExists,
        title: LocaleKeys.pleaseEnterTheDiseases,
        controller: _diseasesCont,
        onChanged: (val) =>
            _listenToData(model.copyWith(healthConditions: val) as T),
        // validator: Validators.validateEmpty,
      ),
      RadioWidget<Languages>(
          title: LocaleKeys.inChatYouPrefer,
          onSubmit: (result) => _listenToData(
              model.copyWith(chatLang: result.languageCode) as T),
          values: Languages.values,
          titleBuilder: (i) => AppText(Languages.values[i].translate),
      ),
      RadioWidget<Answer>(
          title: LocaleKeys.areYouSmoke,
          onSubmit: (result) =>
              _listenToData(model.copyWith(isSmoker: result.toBool) as T),
          values: Answer.values,
          titleBuilder: (i) => AppText(Answer.values[i].translate),
      ),
      RadioWidget<Answer>(
          title: LocaleKeys.doYouBelongToATribe,
          onSubmit: (result) =>
              _listenToData(model.copyWith(tribeAffiliation: result.toBool) as T),
          values: Answer.values,
        titleBuilder: (i) => AppText(Answer.values[i].translate),
      ),
      DropDownTextField<TitleValueShape>(
        hint: LocaleKeys.pleaseEnterSkinColor,
        values: EnumsData.skinColors.data,
        itemBuilder: (v) => AppText(v.title.tr()),
        title: LocaleKeys.skinColor,
        onChanged: (val) => _listenToData(model.copyWith(skinColor: TitleValueShape.fromSingleLabel(val?.value)) as T),
      ),

      DropDownTextField<TitleValueShape>(
        hint: LocaleKeys.pleaseEnterTheDegreeOfCommitment,
        values: EnumsData.religiousCommitment.data,
        title: LocaleKeys.degreeOfCommitment,
        itemBuilder: (v) => AppText(v.title),
        onChanged: (value) => _listenToData(model.copyWith(religiousCommitment: TitleValueShape.fromSingleLabel(value?.value)) as T),
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
