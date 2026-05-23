import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/helpers/status_builder.dart';
import '../../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../cubit/terms_condition_and_about_cubit/terms_condition_and_about_cubit.dart';

class TermsAndConditionAndAboutUs extends StatelessWidget {
  const TermsAndConditionAndAboutUs({super.key, required this.staticPageType});

  final StaticPageType staticPageType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TermsConditionAndAboutCubit()
        ..fetchTermsAndConditions(staticPageType: staticPageType),
      child: AppScaffold(
        isScrollable: true,
        appBarTitle: staticPageType == StaticPageType.terms ?
        LocaleKeys.termsAndConditions : LocaleKeys.aboutUs,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: BlocBuilder<TermsConditionAndAboutCubit, AsyncState<String>>(
            builder: (context, state) {
              return StatusBuilder(
                  data: state,
                  onSuccess: (data, context) {
                    return Html(data: data);
                  });
            },
          ),
        ).paddingAll(18),
      ),
    );
  }
}

