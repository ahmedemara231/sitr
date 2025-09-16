import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/custom_app_bar.dart';

class TermsAndConditionAndAboutUs extends StatelessWidget {
  const TermsAndConditionAndAboutUs({super.key, required this.staticPageType});

  final StaticPageType staticPageType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
          appBarTitle: staticPageType == StaticPageType.terms
              ? LocaleKeys.termsAndConditions
              : LocaleKeys.aboutUs),
      body: SizedBox(
        height: double.infinity,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),

          ),
          child: AppText(text,color: AppColors.textBlack,fontSize: 12,fontWeight: FontWeight.w400,),
        ).paddingAll(18),
      ),
    );
  }
}

enum StaticPageType { terms, about }
String text='''هذا النص افتراضي هذا النص يمكن استبداله بنص أخر في  المسا
هذا النص افتراضي يمكن استبداله هذا النص افتراضي هذا النص افتراضي هذا النص يمكن استبداله بنص أخر في نفس المساحة هذا النص افتراضي يمكن استبداله هذا النص افتراضيهذا النص افتراضي هذا النص يمكن استبداله بنص أخر في  المسا
هذا النص افتراضي يمكن استبداله هذا النص افتراضي هذا النص افتراضي هذا النص يمكن استبداله بنص أخر في نفس المساحة هذا النص افتراضي يمكن استبداله هذا النص افتراضي''';