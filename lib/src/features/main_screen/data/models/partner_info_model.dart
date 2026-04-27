import '../../../../config/language/locale_keys.g.dart';

class PartnerInfoModel {
  final String? leading;
  final String? title;
  final String subTitle;
  final bool isValueSet;

  PartnerInfoModel({
    required this.leading,
    required this.title,
    required String? subTitle,
  })  : subTitle = subTitle ?? LocaleKeys.notSetYet,
        isValueSet = subTitle != null;

  PartnerInfoModel copyWith({
    String? leading,
    String? title,
    String? subTitle,
  }) {
    return PartnerInfoModel(
      leading: leading ?? this.leading,
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
    );
  }
}