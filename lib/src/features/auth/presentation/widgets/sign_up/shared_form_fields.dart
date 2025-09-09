import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/language/languages.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../models/shared_form_fields_model.dart';
import '../shared/text_field.dart';
import 'drop_down_text_field.dart';
import 'radio_widget.dart';


enum Answer{yes, no}
enum Nursery{father, mother}

class SharedFormFields extends StatefulWidget {
  final void Function(SharedFormFieldModel sharedFields) onFinished;
  final void Function(List<Widget> children) onInitData;
  const SharedFormFields({super.key,
    required this.onFinished,
    required this.onInitData,
  });

  @override
  State<SharedFormFields> createState() => _SharedFormFieldsState();
}

class _SharedFormFieldsState extends State<SharedFormFields> {

  final SharedFormFieldModel sharedFields = SharedFormFieldModel.initial();

  late TextEditingController _nickNameCont;
  late TextEditingController _statusCont;
  late TextEditingController _tallCont;
  late TextEditingController _weightCont;
  late TextEditingController _currentJobCont;
  late TextEditingController _briefCont;
  late TextEditingController _childrenNumberCont;
  late TextEditingController _thingsCont;
  late TextEditingController _educationalQualificationCont;
  late TextEditingController _diseasesCont;

  @override
  void initState() {
    _nickNameCont = TextEditingController();
    _statusCont = TextEditingController();
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

  SharedFormFieldModel model = SharedFormFieldModel.initial();
  void _listenToData(SharedFormFieldModel model){
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
       controller: _nickNameCont,
       onChanged: (val) => _listenToData(model.copyWith(nickName: val)),
        // validator: Validators.validateEmpty,
      ),
      SignUpTextField(
        upperTitle: LocaleKeys.maritalStatus,
        title: LocaleKeys.pleaseEnterTheStatus,
        controller: _statusCont,
        onChanged: (val) => _listenToData(model.copyWith(maritalStatus: val)),
        // validator: Validators.validatePhone,
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
          onSubmit: (result) => _listenToData(model.copyWith(childrenExists: result)),
          values: Answer.values,
          titles: [AppText(LocaleKeys.yes), AppText(LocaleKeys.no)]
      ),
     SignUpTextField(
        upperTitle: LocaleKeys.childrenNumber,
        title: LocaleKeys.pleaseEnterTheNumber,
        controller: _childrenNumberCont,
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
     RadioWidget<Answer>(
          title: LocaleKeys.wantToHaveChildren,
          onSubmit: (result) => _listenToData(model.copyWith(wantToHaveChildren: result)),
          values: Answer.values,
          titles: [AppText(LocaleKeys.yes), AppText(LocaleKeys.no)]
      ),

     SignUpTextField(
        upperTitle: LocaleKeys.thingsIAbsolutelyDoNotAcceptOrWant,
        title: LocaleKeys.pleaseEnterTheThings,
        controller: _thingsCont,
        onChanged: (val) => _listenToData(model.copyWith(thingsIAcceptOrWant: val)),
        // validator: Validators.validateEmpty,
      ),

     DropDownTextField(
        title: LocaleKeys.typeOfWeddingParty,
        onChanged: (val) => _listenToData(model.copyWith(typeOfWeddingParty: val)),
      ),

     DropDownTextField(
       title: LocaleKeys.city,
       onChanged: (val) => _listenToData(model.copyWith(city: val)),
     ),

     SignUpTextField(
        upperTitle: LocaleKeys.educationalQualification,
        title: LocaleKeys.pleaseEnterTheEducationalQualification,
        controller: _educationalQualificationCont,
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
        controller: _diseasesCont,
        onChanged: (val) => _listenToData(model.copyWith(diseasesIfExists: val)),
        // validator: Validators.validateEmpty,
      ),

     RadioWidget<Languages>(
          title: LocaleKeys.inChatYouPrefer,
          onSubmit: (result) => _listenToData(model.copyWith(inChatYouPrefer: result)),
          values: Languages.values,
          titles: [AppText(LocaleKeys.arabic), AppText(LocaleKeys.english)]
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

     DropDownTextField(
       title: LocaleKeys.skinColor,
       onChanged: (val) => _listenToData(model.copyWith(skinColor: val)),
     ),
    ];

   widget.onInitData.call(inputs);
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