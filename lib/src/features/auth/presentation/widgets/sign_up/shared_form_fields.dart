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
  final void Function(T sharedFields) onChanged;
  final void Function(List<Widget> children)? onInitData;
  const SharedFormFields({
    super.key,
    this.restorationId,
    required this.onChanged,
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
  late final ValueNotifier<Answer?> childrenExits = ValueNotifier(UserModel.isParent? null : asIndividualUserModel.hasChildren?.toAnswer);

  // لازم يبقي برا عشان تعرف تتحكم فيه وتحسب عدد الmale وال female
  late T model;

  // final AuthData<T> _authData = AuthData<T>();
  void _initIndividualOrChild(IndividualUserModel element){
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
    if(T == MaleModel){
      _initIndividualOrChild(MaleModel.initial());

    }else if(T == FemaleModel){
      _initIndividualOrChild(FemaleModel.initial());

    }else{
      _initIndividualOrChild(IndividualUserModel.initial());
    }
  }

  void _listenToData(T updatedModel, {String? comingVal}) {
    model = updatedModel;
    widget.onChanged.call(model);
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

  // IndividualUserModel get _currentUser => UserModel.currentUser as IndividualUserModel;

  UserModel? get _currentUser {
    if(UserModel.isIndividual){
      return UserModel.currentUser as IndividualUserModel;

    }else if(UserModel.isParent){
      // IndividualUserModel لازم يبقي فيه children جوا ال parent model عشان كله يبقي
      // return ((UserModel.currentUser as ParentModel).children[index]) as IndividualUserModel;
      return UserModel.currentUser ?? UserModel.initial();

    }else{
      return UserModel.initial();
    }
  }

  IndividualUserModel get asIndividualUserModel => _currentUser as IndividualUserModel;

  @override
  void initState() {
    _init();
    _listenToModelChanges();
    _nickNameCont = TextEditingController(text: UserModel.isParent? null : asIndividualUserModel.nickName);
    _tallCont = TextEditingController(text: UserModel.isParent? null : asIndividualUserModel.height);
    _weightCont = TextEditingController(text: UserModel.isParent? null : asIndividualUserModel.weight);
    _currentJobCont = TextEditingController(text: UserModel.isParent? null : asIndividualUserModel.currentJob);
    _briefCont = TextEditingController(text: UserModel.isParent? null : asIndividualUserModel.bio);
    _childrenNumberCont = TextEditingController(text: UserModel.isParent? null : asIndividualUserModel.numOfChildren);
    _thingsCont = TextEditingController(text: UserModel.isParent? null : asIndividualUserModel.prohibitedThings);
    _educationalQualificationCont = TextEditingController(text: UserModel.isParent? null : asIndividualUserModel.educationLevel);
    _diseasesCont = TextEditingController(text: UserModel.isParent? null : asIndividualUserModel.healthConditions);
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
        upperTitle: LocaleKeys.nickname,
        title: LocaleKeys.pleaseEnterYourName,
        controller: _nickNameCont,
        onChanged: (val) => _listenToData(model.copyWith(nickName: val) as T)
        // validator: Validators.validateEmpty,
      ),
      DropDownTextField<TitleValueShape>(
        // initialValue: _currentUser.maritalStatus,
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
          // initialValue: _currentUser.hasChildren?.toAnswer,
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
             spacing: 12.h,
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
                 // initialValue: _currentUser.childCustody,
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
        // initialValue: _currentUser.wantChildren?.toAnswer,
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

      DowryWidget(
        // initialValue: _currentUser.dowry,
        onSelect: (from, to) => _listenToData(model.copyWith(dowry: Dowry(from: from, to: to)) as T)
      ),

      DropDownTextField<TitleValueShape>(
        // // initialValue: ,
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
        // initialValue: _currentUser.isPrayer?.toAnswer,
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
        // initialValue: _currentUser.chatLang?.toLang(),
          title: LocaleKeys.inChatYouPrefer,
          onSubmit: (result) => _listenToData(
              model.copyWith(chatLang: result.languageCode) as T),
          values: Languages.values,
          titleBuilder: (i) => AppText(Languages.values[i].translate),
      ),
      RadioWidget<Answer>(
        // initialValue: _currentUser.isSmoker?.toAnswer,
          title: LocaleKeys.areYouSmoke,
          onSubmit: (result) =>
              _listenToData(model.copyWith(isSmoker: result.toBool) as T),
          values: Answer.values,
          titleBuilder: (i) => AppText(Answer.values[i].translate),
      ),
      RadioWidget<Answer>(
        // initialValue: _currentUser.tribeAffiliation?.toAnswer,
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
