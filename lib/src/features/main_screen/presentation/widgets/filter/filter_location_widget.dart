import 'package:flutter/material.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/shared/models/user_models/user_model.dart';
import '../../../../../core/widgets/app_dropinity.dart';
import '../../../../auth/presentation/data/auth_data.dart';

class FilterLocationWidget extends StatelessWidget {
  final void Function(int? cityId) onCityChanged;

  const FilterLocationWidget({
    super.key,
    required this.onCityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppDropinity<List<CityModel>, CityModel>.withApiRequest(
      hint: LocaleKeys.pleaseEnterTheCity,
      title: LocaleKeys.city,
      asyncCall: (context, page) async => await AuthData.getCities(),
      getLabel: (city) => city.name ?? '',
      onChanged: (val) => onCityChanged(val.id),
      cacheKey: 'cities',
      cacheToJson: (e) => e.toJson(),
      cacheFromJson: (json) => CityModel.fromJson(json),
    );
  }
}
