
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/widgets/buttons/custom_app_buttons/default_button.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../data/models/filter_model.dart';
import '../widgets/filter/filter_job_education_widget.dart';
import '../widgets/filter/filter_lifestyle_widget.dart';
import '../widgets/filter/filter_location_widget.dart';
import '../widgets/filter/filter_physical_attributes_widget.dart';
import 'filter_result.dart' show FilterResultScreen;

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  FilterModel model = FilterModel();

  void _listenToData(FilterModel model) {
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
              FilterLocationWidget(
                onCityChanged: (cityId) => _listenToData(model.copyWith(cityId: cityId)),
              ),
              FilterPhysicalAttributesWidget(
                weightController: _weightCont,
                heightController: _tallCont,
                ageController: _ageCont,
                onWeightChanged: (val) => _listenToData(model.copyWith(weight: val)),
                onHeightChanged: (val) => _listenToData(model.copyWith(height: val)),
                onAgeChanged: (val) => _listenToData(model.copyWith(age: val)),
                onMaritalStatusChanged: (val) => _listenToData(model.copyWith(maritalStatus: val)),
                onSkinColorChanged: (val) => _listenToData(model.copyWith(skinColor: val)),
                onHijabChanged: (val) => _listenToData(model.copyWith(hijab: val)),
              ),
              FilterJobEducationWidget(
                currentJobController: _currentJobCont,
                educationController: _educationalQualificationCont,
                onJobChanged: (val) => _listenToData(model.copyWith(currentJob: val)),
                onEducationChanged: (val) => _listenToData(model.copyWith(educationLevel: val)),
              ),
              FilterLifestyleWidget(
                onDowrySelected: (val) => _listenToData(model.copyWith(dowry: val)),
                onLanguageChanged: (val) => _listenToData(model.copyWith(chatLang: val)),
                onSmokerChanged: (val) => _listenToData(model.copyWith(isSmoker: val)),
                onPrayerChanged: (val) => _listenToData(model.copyWith(isPrayer: val)),
                onWeddingTypeChanged: (val) => _listenToData(model.copyWith(weddingType: val)),
                onWantChildrenChanged: (val) => _listenToData(model.copyWith(wantChildren: val)),
                onReligiousCommitmentChanged: (val) => _listenToData(model.copyWith(religiousCommitment: val)),
              ),
              AppDefaultButton.withBackGroundColor(
                title: LocaleKeys.confirm,
                onTap: () => Go.to(FilterResultScreen(filterModel: model)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
