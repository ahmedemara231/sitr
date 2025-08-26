import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../generated/assets.dart';
import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../../core/extensions/padding_extension.dart';
import '../../core/helpers/cache_service.dart';
import '../../core/navigation/navigator.dart';
import '../../core/widgets/buttons/default_button.dart';
import '../auth/presentation/screens/login.dart';
import 'models/screen_model.dart';
import 'widgets/views.dart';

class OnBoardingView extends StatelessWidget {

  OnBoardingView({super.key});
  final PageController pageController = PageController();

  final totalNumber = 3;
  final ValueNotifier<int> currentIndex = ValueNotifier(0);
  final List<ScreenModel> screens = [
    ScreenModel(backgroundImage: Assets.imagesAppLogo, firstText: 'firstText1', secondText: 'secondText1'),
    ScreenModel(backgroundImage: Assets.imagesArrowDown, firstText: 'firstText2', secondText: 'secondText2'),
    ScreenModel(backgroundImage: Assets.imagesAuthBackground, firstText: 'firstText3', secondText: 'secondText3', isLast: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: currentIndex,
        builder: (context, value, child) => Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView(
              controller: pageController,
                onPageChanged: (value) => currentIndex.value = value,
                children: List.generate(
                    totalNumber,
                        (index) => OnBoardingScreen(
                        model: screens[index],
                        totalNumber: totalNumber,
                        currentIndex: value
                    )
                )
            ),
            DefaultButton(
              borderRadius: BorderRadius.circular(40.r),
                onTap: () {
                  if(value == totalNumber - 1){
                    Go.to(const LoginScreen());
                    CacheStorage.write(CacheConstant.onBoardingSubmission, true);
                  }else{
                    value++;
                    pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOutCirc
                    );
                  }
                },
                title: value != totalNumber - 1?
                LocaleKeys.next : LocaleKeys.start
            ).paddingAll(12.r)
          ],
        ),
      ),
    );
  }
}

