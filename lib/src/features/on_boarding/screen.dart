import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../core/extensions/padding_extension.dart';
import '../../core/helpers/cache_service.dart';
import '../../core/helpers/status_builder.dart';
import '../../core/navigation/navigator.dart';
import '../../core/widgets/buttons/default_button.dart';
import '../auth/imports.dart';
import 'cubit.dart';
import 'models/intro_model.dart';
import 'widgets/views.dart' show OnBoardingScreen;

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => IntroCubit()..getIntros(),
        child: _OnBoarding()
    );
  }
}

class _OnBoarding extends StatelessWidget {

  final PageController pageController = PageController();

  // final totalNumber = 3;
  final ValueNotifier<int> currentIndex = ValueNotifier(0);
  // final List<ScreenModel> screens = [
  //   ScreenModel(backgroundImage: Assets.imagesBoardingFirst, firstText: 'firstText1', secondText: 'secondText1'),
  //   ScreenModel(backgroundImage: Assets.imagesBoardingSecond, firstText: 'firstText2', secondText: 'secondText2'),
  //   ScreenModel(backgroundImage: Assets.imagesBoardingThird, firstText: 'firstText3', secondText: 'secondText3', isLast: true),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: currentIndex,
        builder: (context, value, child) => BlocBuilder<IntroCubit, AsyncState<List<IntroModel>>>(
          builder: (context, state) => StatusBuilder(
            data: state,
            onSuccess: (data, context) => Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PageView(
                    controller: pageController,
                    onPageChanged: (value) => currentIndex.value = value,
                    children: List.generate(
                        state.data.length,
                            (index) => OnBoardingScreen(
                            model: data[index],
                            totalNumber: data.length,
                            currentIndex: value
                        )
                    )
                ),
                DefaultButton(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(40.r),
                    onTap: () {
                      if(value == data.length - 1){
                        Go.offAll(const LoginScreen());
                        CacheStorage.write(CacheConstant.onBoardingSubmission, true);
                      }else{
                        value++;
                        pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOutCirc
                        );
                      }
                    },
                    title: value != data.length - 1?
                    LocaleKeys.next : LocaleKeys.start
                ).paddingAll(12.r)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

