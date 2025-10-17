import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../more/presentation/cubit/terms_condition_and_about_cubit/terms_condition_and_about_cubit.dart';
import '../../../../more/presentation/screens/terms_andcondition_and_about_us/terms_andcondition_and_about_us.dart';

class ConditionsTermsAcceptance extends StatelessWidget {
  const ConditionsTermsAcceptance({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppText(LocaleKeys.iHaveReadAndAccept, fontSize: 12.sp, color: Colors.grey),
        TextButton(
            onPressed: () => Go.to(const TermsAndConditionAndAboutUs(staticPageType: StaticPageType.terms)),
            child: AppText(LocaleKeys.conditionsAndTerms, fontSize: 12.sp, color: AppColors.primary)
        )
      ],
    );
  }
}
