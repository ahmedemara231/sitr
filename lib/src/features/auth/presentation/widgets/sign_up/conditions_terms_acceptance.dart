import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/validation_helper.dart';
import '../../../../more/presentation/cubit/terms_condition_and_about_cubit/terms_condition_and_about_cubit.dart';
import '../../../../more/presentation/screens/terms_andcondition_and_about_us/terms_andcondition_and_about_us.dart';

class ConditionsTermsAcceptance extends StatelessWidget {
  const ConditionsTermsAcceptance({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isAccepted = ValueNotifier(false);
    return ValidationHost<bool>(
      onSaved: (v){},
      validator: (d) =>
      isAccepted.value ? null :
      LocaleKeys.pleaseAcceptTheConditionsAndTerms,
      initialValue: false,
      builderWidget: (accepted) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ValueListenableBuilder(
                  valueListenable: isAccepted,
                  builder: (context, val, child) => Checkbox(
                    activeColor: AppColors.primary,
                      value: val,
                      onChanged: (val) {
                        isAccepted.value = val!;
                        accepted.didChange(val);
                      },
                  ),
              ),
              AppText(LocaleKeys.iHaveReadAndAccept, fontSize: 12.sp, color: Colors.grey),
              TextButton(
                  onPressed: () => Go.to(const TermsAndConditionAndAboutUs(staticPageType: StaticPageType.terms)),
                  child: AppText(LocaleKeys.conditionsAndTerms, fontSize: 12.sp, color: AppColors.primary)
              )
            ],
          ),
          if(accepted.hasError)
            AppText(accepted.errorText ?? '', color: Colors.red)
        ],
      ),
    );
  }
}
