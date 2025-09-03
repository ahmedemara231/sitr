import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/widgets/text.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../models/shared_form_fields_model.dart';
import '../../screens/complete_profile.dart';
import '../shared/text_field.dart';
import 'dowry_widget.dart';
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

  late TextEditingController _nameCont;
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
  late TextEditingController _homeCont;
  late TextEditingController _parentNameCont;
  late TextEditingController _parentNumberCont;
  late TextEditingController _kinshipCont;



  @override
  void initState() {
    _nameCont = TextEditingController();
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
    _homeCont = TextEditingController();
    _parentNameCont = TextEditingController();
    _parentNumberCont = TextEditingController();
    _kinshipCont = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _nameCont.dispose();
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
    _homeCont.dispose();
    _parentNameCont.dispose();
    _parentNumberCont.dispose();
    _kinshipCont.dispose();
    super.dispose();
  }

  List<Widget> get children {
   final List<Widget> inputs = [
     SignUpTextField(
       upperTitle: LocaleKeys.name,
       title: LocaleKeys.pleaseEnterYourName,
       controller: _nameCont,
       // validator: Validators.validateEmpty,
     ),

     SignUpTextField(
        upperTitle: LocaleKeys.nickname,
        title: LocaleKeys.pleaseEnterYourName,
        controller: _nameCont,
        // validator: Validators.validateEmpty,
      ),
      SignUpTextField(
        upperTitle: LocaleKeys.maritalStatus,
        title: LocaleKeys.pleaseEnterTheStatus,
        controller: _statusCont,
        // validator: Validators.validatePhone,
      ),
      SignUpTextField(
        upperTitle: LocaleKeys.tall,
        title: LocaleKeys.pleaseEnterTheTall,
        controller: _tallCont,
        inputType: TextInputType.number,
        // validator: Validators.validateEmpty,
      ),
      SignUpTextField(
        upperTitle: LocaleKeys.weight,
        title: LocaleKeys.pleaseEnterTheWeight,
        controller: _weightCont,
        inputType: TextInputType.number,
        // validator: Validators.validateEmpty,
      ),

      SignUpTextField(
        upperTitle: LocaleKeys.currentJob,
        title: LocaleKeys.pleaseEnterTheCurrentJob,
        controller: _currentJobCont,
        // validator: Validators.validateEmpty,
      ),
      SignUpTextField(
        upperTitle: LocaleKeys.quickBrief,
        title: LocaleKeys.pleaseEnterTheBrief,
        controller: _briefCont,
        inputType: TextInputType.multiline,
        // validator: Validators.validateEmpty,
      ),

      RadioWidget<Answer>(
          title: LocaleKeys.childrenExists,
          onSubmit: (result) {},
          values: Answer.values,
          titles: [AppText(LocaleKeys.yes), AppText(LocaleKeys.no)]
      ),
      SignUpTextField(
        upperTitle: LocaleKeys.childrenNumber,
        title: LocaleKeys.pleaseEnterTheNumber,
        controller: _childrenNumberCont,
        inputType: TextInputType.number,
        // validator: Validators.validateEmpty,
      ),

      RadioWidget<Nursery>(
          title: LocaleKeys.nursery,
          onSubmit: (result) {},
          values: Nursery.values,
          titles: [AppText(LocaleKeys.father), AppText(LocaleKeys.mother)]
      ),
      RadioWidget<Answer>(
          title: LocaleKeys.wantToHaveChildren,
          onSubmit: (result) {},
          values: Answer.values,
          titles: [AppText(LocaleKeys.yes), AppText(LocaleKeys.no)]
      ),

      SignUpTextField(
        upperTitle: LocaleKeys.thingsIAbsolutelyDoNotAcceptOrWant,
        title: LocaleKeys.pleaseEnterTheThings,
        controller: _thingsCont,
        // validator: Validators.validateEmpty,
      ),

      DowryWidget(onSelect: (from, to){}),
      DropDownTextField(title: LocaleKeys.typeOfWeddingParty),
      DropDownTextField(title: LocaleKeys.city),

      SignUpTextField(
        upperTitle: LocaleKeys.educationalQualification,
        title: LocaleKeys.pleaseEnterTheEducationalQualification,
        controller: _educationalQualificationCont,
        // validator: Validators.validateEmpty,
      ),

      RadioWidget<Answer>(
          title: LocaleKeys.areYouPray,
          onSubmit: (result) {},
          values: Answer.values,
          titles: [AppText(LocaleKeys.yes), AppText(LocaleKeys.no)]
      ),

      SignUpTextField(
        upperTitle: LocaleKeys.diseasesIfExists,
        title: LocaleKeys.pleaseEnterTheDiseases,
        controller: _diseasesCont,
        // validator: Validators.validateEmpty,
      ),

      RadioWidget<int>(
          title: LocaleKeys.inChatYouPrefer,
          onSubmit: (result) {},
          values: const [1,2],
          titles: [AppText(LocaleKeys.arabic), AppText(LocaleKeys.english)]
      ),
      RadioWidget<Answer>(
          title: LocaleKeys.areYouSmoke,
          onSubmit: (result) {},
          values: Answer.values,
          titles: [AppText(LocaleKeys.yes), AppText(LocaleKeys.no)]
      ),

      RadioWidget<Answer>(
          title: LocaleKeys.doYouBelongToATribe,
          onSubmit: (result) {},
          values: Answer.values,
          titles: [AppText(LocaleKeys.yes), AppText(LocaleKeys.no)]
      ),


      DropDownTextField(title: LocaleKeys.skinColor),
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
