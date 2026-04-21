import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/shared/models/title_value_shape.dart';
import '../../../../../core/shared/models/user_models/user_model.dart';
import '../../../../../core/widgets/app_dropinity.dart';
import '../../../../auth/presentation/data/auth_data.dart';
import '../../../../auth/presentation/widgets/shared/text_field.dart';

class FilterPhysicalAttributesWidget extends StatelessWidget {
  final TextEditingController weightController;
  final TextEditingController heightController;
  final TextEditingController ageController;
  final void Function(double) onWeightChanged;
  final void Function(double) onHeightChanged;
  final void Function(int) onAgeChanged;
  final void Function(String) onMaritalStatusChanged;
  final void Function(String) onSkinColorChanged;
  final void Function(String) onHijabChanged;

  const FilterPhysicalAttributesWidget({
    super.key,
    required this.weightController,
    required this.heightController,
    required this.ageController,
    required this.onWeightChanged,
    required this.onHeightChanged,
    required this.onAgeChanged,
    required this.onMaritalStatusChanged,
    required this.onSkinColorChanged,
    required this.onHijabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: [
        SignUpTextField(
          upperTitle: LocaleKeys.weight,
          title: LocaleKeys.pleaseEnterTheWeight,
          controller: weightController,
          inputType: TextInputType.number,
          onChanged: (val) => onWeightChanged(double.parse(val!)),
        ),
        SignUpTextField(
          upperTitle: LocaleKeys.tall,
          title: LocaleKeys.pleaseEnterTheTall,
          controller: heightController,
          inputType: TextInputType.number,
          onChanged: (val) => onHeightChanged(double.parse(val!)),
        ),
        AppDropinity<List<TitleValueShape>, TitleValueShape>.withApiRequest(
          listHeight: 100,
          title: LocaleKeys.maritalStatus,
          hint: LocaleKeys.pleaseEnterTheStatus,
          asyncCall: (ctx, page) async => await AuthData.getPersonalData(ApiConstants.maritalStatuses),
          getLabel: (v) => v.title,
          onChanged: (val) => onMaritalStatusChanged(val.value),
          cacheKey: 'marital_statuses',
          cacheToJson: (e) => e.toJson(),
          cacheFromJson: (json) => TitleValueShape.fromJson(json),
        ),
        SignUpTextField(
          upperTitle: LocaleKeys.age,
          title: LocaleKeys.pleaseEnterYourAge,
          controller: ageController,
          inputType: TextInputType.number,
          onChanged: (val) => onAgeChanged(int.parse(val!)),
        ),
        AppDropinity<List<TitleValueShape>, TitleValueShape>.withApiRequest(
          listHeight: 100,
          hint: LocaleKeys.pleaseEnterSkinColor,
          title: LocaleKeys.skinColor,
          asyncCall: (ctx, page) async => await AuthData.getPersonalData(ApiConstants.skinColors),
          getLabel: (v) => v.title,
          onChanged: (val) => onSkinColorChanged(val.value),
          cacheKey: 'skin_colors',
          cacheToJson: (e) => e.toJson(),
          cacheFromJson: (json) => TitleValueShape.fromJson(json),
        ),
        if (UserModel.isMale)
          AppDropinity<List<TitleValueShape>, TitleValueShape>.withApiRequest(
            listHeight: 100,
            hint: LocaleKeys.areYouWaringHijab,
            title: LocaleKeys.areYouWaringHijab,
            asyncCall: (ctx, page) async => await AuthData.getPersonalData(ApiConstants.hijabTypes),
            getLabel: (v) => v.title,
            onChanged: (val) => onHijabChanged(val.value),
            cacheKey: 'hijab_types',
            cacheToJson: (e) => e.toJson(),
            cacheFromJson: (json) => TitleValueShape.fromJson(json),
          ),
      ],
    );
  }
}
