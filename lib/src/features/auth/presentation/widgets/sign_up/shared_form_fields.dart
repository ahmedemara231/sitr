import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/language/languages.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/extensions/enum.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../models/city.dart';
import '../../../models/complete_profile/female_body.dart';
import '../../../models/complete_profile/male_body.dart';
import '../../../models/dowry.dart';
import '../../../models/shared_form_fields_model.dart';
import '../../data/auth_data.dart';
import '../../data/enums_data.dart';
import '../../enums/answer.dart';
import '../shared/text_field.dart';
import 'dowry_widget.dart';
import 'drop_down_text_field.dart';
import 'radio_widget.dart';

class SharedFormFields<T extends SharedFormFieldModel> extends StatefulWidget {
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

class _SharedFormFieldsState<T extends SharedFormFieldModel> extends State<SharedFormFields<T>> {

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
    if(T == FemaleCompleteProfileBody){
      model = FemaleCompleteProfileBody.initial() as T;

    }else if(T == FemaleParentCompleteProfileBody){
      model = FemaleParentCompleteProfileBody.initial() as T;

    }else if (T == MaleCompleteProfileBody){
      model = MaleCompleteProfileBody.initial() as T;

    }else if (T == MaleParentCompleteProfileBody){
      model = MaleParentCompleteProfileBody.initial() as T;

    }else{
      model = SharedFormFieldModel.initial() as T;
    }
  }

  void _listenToData(SharedFormFieldModel updatedModel) {
    model = model.merge(updatedModel) as T;
    widget.onFinished.call(model);
  }

  void _childrenExitsListener(){
    if(childrenExits.value.isNo){
      _childrenNumberCont.clear();
      _listenToData(model.copyWith(nursery: null) as T);
    }
  }

  void _listenToModelChanges(){
    childrenExits.addListener(_childrenExitsListener);
  }

  @override
  void initState() {
    _init();
    _listenToModelChanges();
    _nickNameCont = TextEditingController();
    _tallCont = TextEditingController();
    _weightCont = TextEditingController();
    _currentJobCont = TextEditingController();
    _briefCont = TextEditingController();
    _childrenNumberCont = TextEditingController();
    _thingsCont = TextEditingController();
    _educationalQualificationCont = TextEditingController();
    _diseasesCont = TextEditingController();
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
        onChanged: (val) => _listenToData(model.copyWith(nickName: val)),
        // validator: Validators.validateEmpty,
      ),
      DropDownTextField<TitleValueShape>(
        title: LocaleKeys.maritalStatus,
        hint: LocaleKeys.pleaseEnterTheStatus,
        values: EnumsData.maritalStatus.data,
        itemBuilder: (v) => AppText(v.title.tr()),
        onChanged: (val) =>
            _listenToData(model.copyWith(maritalStatus: val?.value)),
      ),
      SignUpTextField(
        upperTitle: LocaleKeys.tall,
        title: LocaleKeys.pleaseEnterTheTall,
        controller: _tallCont,
        inputType: TextInputType.number,
        onChanged: (val) => _listenToData(model.copyWith(tall: val)),
        // validator: Validators.validateEmpty,
      ),
      SignUpTextField(
        upperTitle: LocaleKeys.weight,
        title: LocaleKeys.pleaseEnterTheWeight,
        controller: _weightCont,
        inputType: TextInputType.number,
        onChanged: (val) => _listenToData(model.copyWith(weight: val)),
        // validator: Validators.validateEmpty,
      ),
      SignUpTextField(
        upperTitle: LocaleKeys.currentJob,
        title: LocaleKeys.pleaseEnterTheCurrentJob,
        controller: _currentJobCont,
        onChanged: (val) => _listenToData(model.copyWith(currentJob: val)),
        // validator: Validators.validateEmpty,
      ),
      SignUpTextField(
        upperTitle: LocaleKeys.quickBrief,
        title: LocaleKeys.pleaseEnterTheBrief,
        controller: _briefCont,
        inputType: TextInputType.multiline,
        onChanged: (val) => _listenToData(model.copyWith(quickBrief: val)),
        // validator: Validators.validateEmpty,
      ),
      RadioWidget<Answer>(
          title: LocaleKeys.childrenExists,
          onSubmit: (result) {
            childrenExits.value = result;
            _listenToData(model.copyWith(childrenExists: result.toBool));
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
                     _listenToData(model.copyWith(childrenNumber: val)),
                 // validator: Validators.validateEmpty,
               ),
               RadioWidget<TitleValueShape>(
                 title: LocaleKeys.nursery,
                 onSubmit: (result) => _listenToData(model.copyWith(nursery: result.value)),
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
              _listenToData(model.copyWith(wantToHaveChildren: result.toBool)),
          values: Answer.values,
          titleBuilder: (i) => AppText(Answer.values[i].translate),
      ),
      SignUpTextField(
        upperTitle: LocaleKeys.thingsIAbsolutelyDoNotAcceptOrWant,
        title: LocaleKeys.pleaseEnterTheThings,
        controller: _thingsCont,
        onChanged: (val) =>
            _listenToData(model.copyWith(thingsIAcceptOrWant: val)),
        // validator: Validators.validateEmpty,
      ),
      DowryWidget(onSelect: (from, to) {
        _listenToData(model.copyWith(dowry: Dowry(from: from, to: to)));
      }),

      DropDownTextField<TitleValueShape>(
        hint: LocaleKeys.pleaseEnterTheWeddingParty,
        values: EnumsData.weddingTypes.data,
        title: LocaleKeys.typeOfWeddingParty,
        itemBuilder: (v) => AppText(v.title.tr()),
        onChanged: (val) =>
            _listenToData(model.copyWith(typeOfWeddingParty: val?.value)),
      ),
      DropDownTextField<City>.withApiRequest(
        hint: LocaleKeys.pleaseEnterTheCity,
        title: LocaleKeys.city,
        onChanged: (val) => _listenToData(model.copyWith(cityId: val?.id)),
        request: (BuildContext ctx) async => await AuthData.getCities(),
        itemBuilder: (city) => AppText(city.name),
      ),
      SignUpTextField(
        upperTitle: LocaleKeys.educationalQualification,
        title: LocaleKeys.pleaseEnterTheEducationalQualification,
        controller: _educationalQualificationCont,
        onChanged: (val) =>
            _listenToData(model.copyWith(educationalQualification: val)),
        // validator: Validators.validateEmpty,
      ),
      RadioWidget<Answer>(
          title: LocaleKeys.areYouPray,
          onSubmit: (result) =>
              _listenToData(model.copyWith(pray: result.toBool)),
          values: Answer.values,
        titleBuilder: (i) => AppText(Answer.values[i].translate),
      ),
      SignUpTextField(
        upperTitle: LocaleKeys.diseasesIfExists,
        title: LocaleKeys.pleaseEnterTheDiseases,
        controller: _diseasesCont,
        onChanged: (val) =>
            _listenToData(model.copyWith(diseasesIfExists: val)),
        // validator: Validators.validateEmpty,
      ),
      RadioWidget<Languages>(
          title: LocaleKeys.inChatYouPrefer,
          onSubmit: (result) => _listenToData(
              model.copyWith(inChatYouPrefer: result.languageCode)),
          values: Languages.values,
          titleBuilder: (i) => AppText(Languages.values[i].translate),
      ),
      RadioWidget<Answer>(
          title: LocaleKeys.areYouSmoke,
          onSubmit: (result) =>
              _listenToData(model.copyWith(smoke: result.toBool)),
          values: Answer.values,
          titleBuilder: (i) => AppText(Answer.values[i].translate),
      ),
      RadioWidget<Answer>(
          title: LocaleKeys.doYouBelongToATribe,
          onSubmit: (result) =>
              _listenToData(model.copyWith(belongToATribe: result.toBool)),
          values: Answer.values,
        titleBuilder: (i) => AppText(Answer.values[i].translate),
      ),
      DropDownTextField<TitleValueShape>(
        hint: LocaleKeys.pleaseEnterSkinColor,
        values: EnumsData.skinColors.data,
        itemBuilder: (v) => AppText(v.title.tr()),
        title: LocaleKeys.skinColor,
        onChanged: (val) => _listenToData(model.copyWith(skinColor: val?.value)),
      ),
    ];

    widget.onInitData?.call(inputs);
    return inputs;
  }

  @override
  Widget build(BuildContext context) {
    return Column(spacing: 10.h, children: children);
  }
}
