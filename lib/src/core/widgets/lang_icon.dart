import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../generated/assets.dart';
import '../../config/language/languages.dart';
import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../extensions/context_extension.dart';
import '../extensions/padding_extension.dart';
import '../navigation/navigator.dart';
import 'app_text.dart';
import 'buttons/loading_button.dart';
import 'default_bottom_sheet.dart';

class LangIcon extends StatelessWidget {
  final FutureOr<void> Function(Languages selectedLang) onSelectLang;
  const LangIcon({super.key,
    required this.onSelectLang
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showDefaultBottomSheet(child: _LangSheet(onSelectLang: onSelectLang)),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.white
        ),
        child: SvgPicture.asset(Assets.svgLangIcon).paddingAll(7.sp),
      ),
    );
  }
}

class _LangSheet extends StatelessWidget {
  final FutureOr<void> Function(Languages selectedLang) onSelectLang;
  const _LangSheet({super.key,
    required this.onSelectLang
  });

  @override
  Widget build(BuildContext context) {
    context.locale;
    return IntrinsicHeight(
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r))
          ),
          child: SelectLangWidget(onSelectLang: onSelectLang)
      ),
    );
  }
}

class SelectLangWidget extends StatefulWidget {
  final FutureOr<void> Function(Languages selectedLang) onSelectLang;
  const SelectLangWidget({super.key,
    required this.onSelectLang
  });

  @override
  State<SelectLangWidget> createState() => _SelectLangWidgetState();
}

class _SelectLangWidgetState extends State<SelectLangWidget> {
  Languages language = Languages.deviceLocale;

  final List<LangModel> languages = [
    LangModel(langTitle: 'اللغة العربية', image: Assets.svgSAFlag, wholeLang: Languages.arabic),
    LangModel(langTitle: 'English', image: Assets.svgUSAFlag, wholeLang: Languages.english),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: [
        AppText(LocaleKeys.selectTheLanguage, fontSize: 16.sp, fontWeight: FontWeight.w500),
        AppText(LocaleKeys.selectTheLanguageFromTheAvailableLanguages, fontSize: 12.sp),

        Column(
          children: [
            Column(
              children: List.generate(languages.length, (index) => InkWell(
                onTap: () => setState(() => language = languages[index].wholeLang),
                child: Container(
                  height: 125.h,
                  width: context.width,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: language == languages[index].wholeLang ?
                          AppColors.primary : AppColors.transparent
                      ),
                      borderRadius: BorderRadius.circular(30.r)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(languages[index].image),
                      AppText(languages[index].langTitle),
                    ],
                  ),
                ),
              ),),
            ),
            LoadingButton(
                title: LocaleKeys.confirm,
                borderRadius: 40.r,
                height: 45.h,
                fontSize: 12.sp,
                onTap: () async{
                  Languages.setLocale(language);
                  await widget.onSelectLang(language);
                  Go.back();
                }, btnKey: null,
            )
          ],
        )
      ],
    );
  }
}


class LangModel{
  final String langTitle;
  final String image;
  final Languages wholeLang;

  LangModel({required this.langTitle, required this.image, required this.wholeLang});
}