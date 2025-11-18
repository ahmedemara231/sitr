import 'package:easy_localization/easy_localization.dart';
import '../../config/language/locale_keys.g.dart';
import '../navigation/navigator.dart';
 
class Validators {
  static String? validateEmpty(String? value, {String? fieldTitle}) {
    if (value == null || value.isEmpty) {
      return fieldTitle == null
          ? LocaleKeys.fillField.tr(context: Go.context)
          : '${LocaleKeys.filedValidation.tr()} $fieldTitle';
    } else if (RegExp(r'[<>]').hasMatch(value)) {
      return LocaleKeys.scripInjectionValidate.tr(
        context: Go.context,
      );
    }

    return null;
  }

  static String? validateDowry({required String min, required String max}) {
    final num minNum = num.tryParse(min) ?? 0;
    final num maxNum = num.tryParse(max) ?? 0;

    if(minNum >= maxNum){
      return LocaleKeys.theMinDowryCanNotBeGreaterThanMax;
    }

    return null;
  }

 

  static String? validateEmail(String? value, {String? fieldTitle}) {
    if (value?.trim().isEmpty ?? true) {
      return fieldTitle == null
          ? LocaleKeys.fillField.tr(context: Go.context)
          : '${LocaleKeys.filedValidation.tr()} $fieldTitle';
    } else if (RegExp(r'[<>]').hasMatch(value!)) {
      return LocaleKeys.scripInjectionValidate.tr(
        context: Go.context,
      );
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.["
            r'a-zA-Z]+')
        .hasMatch(value)) {
      return LocaleKeys.mailValidation.tr(context: Go.context);
    }
    return null;
  }

  static String? validatePhone(String? value, {String? message}) {
    if (value?.trim().isEmpty ?? true) {
      return message ?? LocaleKeys.fillField;
    } else if (!RegExp(r'^(5)(5|0|3|6|4|9|1|8|7)([0-9]{7})$')
        .hasMatch(value!.trim()) ||
        value.length < 9) {
      return message ?? LocaleKeys.phoneValidation.tr();
    }
    return null;
  }


 
 

  static String? noValidate(String value) {
    if (RegExp(r'[<>]').hasMatch(value)) {
      return LocaleKeys.scripInjectionValidate.tr(
        context: Go.context,
      );
    } else {
      return null;
    }
  }

  static String? validateDropDown<T>(T? value, {String? fieldTitle}) {
    if (value == null) {
      return fieldTitle != null
          ? '${LocaleKeys.please.tr()} $fieldTitle'
          : LocaleKeys.fillField.tr(context: Go.context);
    } else {
      return null;
    }
  }
}
