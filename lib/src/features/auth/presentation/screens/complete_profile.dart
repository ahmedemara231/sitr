import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/sized_box_helper.dart';
import '../../../../core/widgets/app_logo_widget.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/buttons/custom_app_buttons/default_button.dart';
import '../../../../core/widgets/lang_icon.dart';
import '../../../../core/widgets/scaffolds/auth_scaffold.dart';
import '../widgets/dowry_widget.dart';
import '../widgets/drop_down_text_field.dart';
import '../widgets/radio_widget.dart';
import '../widgets/sign_up_static_texts.dart';
import '../widgets/text_field.dart';

enum Answer{yes, no}
enum Nursery{father, mother}

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController _nameCont;
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

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
        upperWidget: Column(
          spacing: 12.h,
          children: [
            Row(
              spacing: context.width / 8,
              children: [
                LangIcon(onSelectLang: (lang){}),
                const AppLogoWidget(),
              ],
            ),
            const SignUpStaticTexts()
          ],
        ),
        body: Form(
          key: formKey,
          child: Column(
            spacing: 10.h,
            children: [
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

              SignUpTextField(
                upperTitle: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage,
                title: LocaleKeys.pleaseEnterHome,
                controller: _homeCont,
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
                  title: LocaleKeys.doYouAcceptPolygamy,
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
              DropDownTextField(title: LocaleKeys.areYouWaringHijab),
              DropDownTextField(title: LocaleKeys.degreeOfCommitment),


              SignUpTextField(
                upperTitle: LocaleKeys.parentName,
                title: LocaleKeys.pleaseEnterYourName,
                controller: _parentNameCont,
                // validator: Validators.validateEmpty,
              ),
              SignUpTextField(
                upperTitle: '${LocaleKeys.parentNumber} (${LocaleKeys.optional})',
                title: LocaleKeys.pleaseEnterTheNumber,
                inputType: TextInputType.number,
                controller: _parentNumberCont,
                // validator: Validators.validateEmpty,
              ),
              SignUpTextField(
                upperTitle: LocaleKeys.kinship,
                title: LocaleKeys.pleaseEnterTheKinship,
                controller: _kinshipCont,
                // validator: Validators.validateEmpty,
              ),

              10.szH,
              AppDefaultButton.withBackGroundColor(
                  title: LocaleKeys.confirm,
                  onTap: (){
                    if(formKey.currentState!.validate()){}
                  }
              )
            ],
          ),
        )
    );
  }
}
