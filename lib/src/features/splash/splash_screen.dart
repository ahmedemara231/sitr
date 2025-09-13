import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../generated/assets.dart';
import '../../config/res/config_imports.dart';
import '../../core/helpers/cache_service.dart';
import '../../core/navigation/navigator.dart';
import '../../core/notification/notification_service.dart';
import '../auth/imports.dart';
import '../on_boarding/screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _manipulateSplashData();
    _initApp();
    super.initState();
  }

  void _initApp() async {
    NotificationNavigator(
      onRoutingMessage: (message) {
        NotificationRoutes.navigateByType(message.data);
      },
      onNoInitialMessage: () {},
    ); // TODO add notification navigator
    await injector<NotificationService>()
        .setupNotifications();
  }

  void _manipulateSplashData()async{
    await Future.delayed(const Duration(seconds: 3));
    final result = await CacheStorage.read(CacheConstant.onBoardingSubmission);
    switch(result){
      case true:
        Go.to(const LoginScreen());
        // await authLogin();
        break;

      default:
        Go.to(OnBoardingView());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 1.sh,
      width: 1.sw,
      child: Center(child: SvgPicture.asset(Assets.svgAppLogo)),
    );
  }
}
