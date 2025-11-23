import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/language/languages.dart';
import '../../../config/language/locale_keys.g.dart';
import '../../../config/res/config_imports.dart';
import '../../../core/extensions/context_extension.dart';
import '../../../core/extensions/padding_extension.dart';
import '../../../core/helpers/cache_service.dart';
import '../../../core/navigation/navigator.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/image_widgets/cached_image.dart';
import '../../auth/imports.dart';
import '../models/intro_model.dart';
import 'on_boarding_dots.dart';

class OnBoardingScreen extends StatelessWidget {
  final int totalNumber;
  final int currentIndex;
  final IntroModel model;

  const OnBoardingScreen({super.key,
    required this.model,
    required this.totalNumber,
    required this.currentIndex
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: context.height,
            width: context.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black38,
                  Colors.black45,
                  Colors.black54,
                  Colors.black
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0, 0.6, 1],
              ),
            ),
            child: CachedImage(url: model.image, fit: BoxFit.fill)
        ),
        Positioned(
          bottom: 100.h,
          width: context.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 7.h,
            children: [
              AppText(model.title, fontWeight: FontWeight.bold, fontSize: 16.h, color: Colors.white,),
              AppText(model.description, fontSize: 14.sp, color: Colors.white),
              OnBoardingDots(currentIndex: currentIndex, totalDotsNumber: totalNumber),
            ],
          ).paddingSymmetric(horizontal: 12.w),
        ),
        if(!(currentIndex == totalNumber - 1))
          Align(
            alignment: Languages.currentLanguage == Languages.arabic?
            Alignment.topRight : Alignment.topLeft,
            child: TextButton(
                onPressed: () {
                  Go.offAll(const LoginScreen());
                  CacheStorage.write(CacheConstant.onBoardingSubmission, true);
                },
                child: AppText(LocaleKeys.skip, color: Colors.white).paddingSymmetric(
                    vertical: 30.h,
                    horizontal: 16.w
                )
            ),
          )
      ],
    );
  }
}