import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/language/languages.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/enum.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/shared/models/title_value_shape.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../core/widgets/buttons/custom_app_buttons/default_button.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../auth/models/dowry.dart';
import '../../../auth/presentation/data/auth_data.dart' show AuthData;
import '../../../auth/presentation/data/enums_data.dart';
import '../../../auth/presentation/enums/answer.dart';
import '../../../auth/presentation/widgets/shared/text_field.dart';
import '../../../auth/presentation/widgets/sign_up/dowry_widget.dart';
import '../../../auth/presentation/widgets/sign_up/drop_down_text_field.dart';
import '../../../auth/presentation/widgets/sign_up/radio_widget.dart';
import '../../data/home_data.dart';
import '../../data/models/filter_model.dart';
import 'filter_result.dart' show FilterResultScreen;

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  FilterModel model = FilterModel();

  void _listenToData(FilterModel model){
    this.model = model;
  }

  late TextEditingController _tallCont;
  late TextEditingController _weightCont;
  late TextEditingController _ageCont;
  late TextEditingController _currentJobCont;
  late TextEditingController _educationalQualificationCont;

  @override
  void initState() {
    _tallCont = TextEditingController();
    _weightCont = TextEditingController();
    _ageCont = TextEditingController();
    _currentJobCont = TextEditingController();
    _educationalQualificationCont = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _tallCont.dispose();
    _weightCont.dispose();
    _ageCont.dispose();
    _currentJobCont.dispose();
    _educationalQualificationCont.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        appBarTitle: LocaleKeys.filter,
        body: SingleChildScrollView(
      child: Container(
        color: AppColors.whiteGreyColorProMax,
        child: Column(
          spacing: 12.h,
          children: [
            DropDownTextField<CityModel>.withApiRequest(
              hint: LocaleKeys.pleaseEnterTheCity,
              title: LocaleKeys.city,
              onChanged: (val) => _listenToData(model.copyWith(cityId: val?.id)),
              request: (BuildContext ctx) async => await AuthData.getCities(),
              itemBuilder: (city) => AppText(city.name ?? ''),
            ),

            SignUpTextField(
              upperTitle: LocaleKeys.weight,
              title: LocaleKeys.pleaseEnterTheWeight,
              controller: _weightCont,
              inputType: TextInputType.number,
              onChanged: (val) => _listenToData(model.copyWith(weight: double.parse(val!))),
              // validator: Validators.validateEmpty,
            ),
            SignUpTextField(
              upperTitle: LocaleKeys.tall,
              title: LocaleKeys.pleaseEnterTheTall,
              controller: _tallCont,
              inputType: TextInputType.number,
              onChanged: (val) => _listenToData(model.copyWith(height: double.parse(val!))),
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
              upperTitle: LocaleKeys.age,
              title: LocaleKeys.pleaseEnterYourAge,
              controller: _ageCont,
              inputType: TextInputType.number,
              onChanged: (val) => _listenToData(model.copyWith(age: int.parse(val!))),
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
              upperTitle: LocaleKeys.educationalQualification,
              title: LocaleKeys.pleaseEnterTheEducationalQualification,
              controller: _educationalQualificationCont,
              onChanged: (val) => _listenToData(model.copyWith(educationLevel: val)),
              // validator: Validators.validateEmpty,
            ),


            DowryWidget(
                onSelect: (from, to) => _listenToData(model.copyWith(dowry: Dowry(from: from, to: to)))
            ),

            DropDownTextField<TitleValueShape>(
              hint: LocaleKeys.pleaseEnterSkinColor,
              values: EnumsData.skinColors.data,
              itemBuilder: (v) => AppText(v.title.tr()),
              title: LocaleKeys.skinColor,
              onChanged: (val) => _listenToData(model.copyWith(skinColor: val?.value)),
            ),

            if(UserModel.isMale)
              DropDownTextField<TitleValueShape>(
              hint: LocaleKeys.areYouWaringHijab,
              values: EnumsData.hijab.data,
              title: LocaleKeys.areYouWaringHijab,
              itemBuilder: (v) => AppText(v.title),
              onChanged: (value) {
                _listenToData(model.copyWith(hijab: value?.value));
              },
            ),

            RadioWidget<Languages>(
              title: LocaleKeys.inChatYouPrefer,
              onSubmit: (result) => _listenToData(
                  model.copyWith(chatLang: result.languageCode)),
              values: Languages.values,
              titleBuilder: (i) => AppText(Languages.values[i].translate),
            ),
            RadioWidget<Answer>(
              title: LocaleKeys.areYouSmoke,
              onSubmit: (result) =>
                  _listenToData(model.copyWith(isSmoker: result.toBinary)),
              values: Answer.values,
              titleBuilder: (i) => AppText(Answer.values[i].translate),
            ),
            RadioWidget<Answer>(
              title: LocaleKeys.areYouPray,
              onSubmit: (result) =>
                  _listenToData(model.copyWith(isPrayer: result.toBinary)),
              values: Answer.values,
              titleBuilder: (i) => AppText(Answer.values[i].translate),
            ),

            DropDownTextField<TitleValueShape>(
              // // initialValue: ,
              hint: LocaleKeys.pleaseEnterTheWeddingParty,
              values: EnumsData.weddingTypes.data,
              title: LocaleKeys.typeOfWeddingParty,
              itemBuilder: (v) => AppText(v.title.tr()),
              onChanged: (val) =>
                  _listenToData(model.copyWith(weddingType: val?.value)),
            ),
            RadioWidget<Answer>(
              title: LocaleKeys.wantToHaveChildren,
              onSubmit: (result) =>
                  _listenToData(model.copyWith(wantChildren: result.toBinary)),
              values: Answer.values,
              titleBuilder: (i) => AppText(Answer.values[i].translate),
            ),

            DropDownTextField<TitleValueShape>(
              hint: LocaleKeys.pleaseEnterTheDegreeOfCommitment,
              values: EnumsData.religiousCommitment.data,
              title: LocaleKeys.degreeOfCommitment,
              itemBuilder: (v) => AppText(v.title),
              onChanged: (value) => _listenToData(model.copyWith(religiousCommitment: value?.value)),
            ),

            AppDefaultButton.withBackGroundColor(
                title: LocaleKeys.confirm,
                onTap: () => Go.to(FilterResultScreen(filterModel: model))
            )
          ],
        ),
      ),
    )
    );
  }
}
