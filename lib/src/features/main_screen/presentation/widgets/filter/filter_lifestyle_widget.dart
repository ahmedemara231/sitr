import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/language/languages.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/extensions/enum.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/shared/models/title_value_shape.dart';
import '../../../../../core/widgets/app_dropinity.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../auth/models/dowry.dart';
import '../../../../auth/presentation/data/auth_data.dart';
import '../../../../auth/presentation/enums/answer.dart';
import '../../../../auth/presentation/widgets/sign_up/dowry_widget.dart';
import '../../../../auth/presentation/widgets/sign_up/radio_widget.dart';

class FilterLifestyleWidget extends StatelessWidget {
  final void Function(Dowry) onDowrySelected;
  final void Function(String) onLanguageChanged;
  final void Function(int) onSmokerChanged;
  final void Function(int) onPrayerChanged;
  final void Function(String) onWeddingTypeChanged;
  final void Function(int) onWantChildrenChanged;
  final void Function(String) onReligiousCommitmentChanged;

  const FilterLifestyleWidget({
    super.key,
    required this.onDowrySelected,
    required this.onLanguageChanged,
    required this.onSmokerChanged,
    required this.onPrayerChanged,
    required this.onWeddingTypeChanged,
    required this.onWantChildrenChanged,
    required this.onReligiousCommitmentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: [
        DowryWidget(onSelect: onDowrySelected),
        RadioWidget<Languages>(
          title: LocaleKeys.inChatYouPrefer,
          onSubmit: (result) => onLanguageChanged(result.languageCode),
          values: Languages.values,
          titleBuilder: (i) => AppText(Languages.values[i].translate),
        ),
        RadioWidget<Answer>(
          title: LocaleKeys.areYouSmoke,
          onSubmit: (result) => onSmokerChanged(result.toBinary),
          values: Answer.values,
          titleBuilder: (i) => AppText(Answer.values[i].translate),
        ),
        RadioWidget<Answer>(
          title: LocaleKeys.areYouPray,
          onSubmit: (result) => onPrayerChanged(result.toBinary),
          values: Answer.values,
          titleBuilder: (i) => AppText(Answer.values[i].translate),
        ),
        AppDropinity<List<TitleValueShape>, TitleValueShape>.withApiRequest(
          listHeight: 100,
          hint: LocaleKeys.pleaseEnterTheWeddingParty,
          title: LocaleKeys.typeOfWeddingParty,
          asyncCall: (ctx, page) async => await AuthData.getPersonalData(ApiConstants.weddingTypes),
          getLabel: (v) => v.title,
          onChanged: (val) => onWeddingTypeChanged(val.value),
          cacheKey: 'wedding_types',
          cacheToJson: (e) => e.toJson(),
          cacheFromJson: (json) => TitleValueShape.fromJson(json),
        ),
        RadioWidget<Answer>(
          title: LocaleKeys.wantToHaveChildren,
          onSubmit: (result) => onWantChildrenChanged(result.toBinary),
          values: Answer.values,
          titleBuilder: (i) => AppText(Answer.values[i].translate),
        ),
        AppDropinity<List<TitleValueShape>, TitleValueShape>.withApiRequest(
          listHeight: 100,
          hint: LocaleKeys.pleaseEnterTheDegreeOfCommitment,
          title: LocaleKeys.degreeOfCommitment,
          asyncCall: (ctx, page) async => await AuthData.getPersonalData(ApiConstants.religiousCommitments),
          getLabel: (v) => v.title,
          onChanged: (val) => onReligiousCommitmentChanged(val.value),
          cacheKey: 'religious_commitments',
          cacheToJson: (e) => e.toJson(),
          cacheFromJson: (json) => TitleValueShape.fromJson(json),
        ),
      ],
    );
  }
}
