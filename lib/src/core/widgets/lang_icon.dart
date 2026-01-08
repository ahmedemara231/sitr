import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../generated/assets.dart';
import '../../config/language/languages.dart';
import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../../features/chats/data/chat_sheet_manager.dart';
import '../../features/more/presentation/cubit/change_lang.dart';
import '../extensions/context_extension.dart';
import '../extensions/padding_extension.dart';
import '../navigation/navigator.dart';
import 'app_text.dart';
import 'buttons/app_loading_button.dart';

class LangIcon extends StatelessWidget {
  final bool withRequest;
  const LangIcon({super.key, required this.withRequest});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => ChatSheetManager.show(child: LangSheet(withRequest: withRequest)),
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

class LangSheet extends StatelessWidget {
  final bool withRequest;

  const LangSheet({required this.withRequest});

  @override
  Widget build(BuildContext context) {
    context.locale;
    return IntrinsicHeight(
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r))
          ),
          child: SelectLangWidget(withRequest: withRequest)
      ),
    );
  }
}

class SelectLangWidget extends StatefulWidget {
  final bool withRequest;
  const SelectLangWidget({super.key, required this.withRequest});

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
          spacing: 10.h,
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
                          AppColors.primary : Colors.transparent
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
            BlocProvider(
              create: (context) => ChangeLangCubit(),
              child: AppLoadingButton(
                  title: LocaleKeys.confirm,
                  asyncCall: (context) async{
                    if(widget.withRequest){
                      await context.read<ChangeLangCubit>().changeLang(language.languageCode);
                    }
                    Languages.setLocale(language);
                    Go.back();
                  },
              ),
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