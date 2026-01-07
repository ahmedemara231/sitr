import 'package:flutter/material.dart';
import '../../config/res/config_imports.dart';
import '../../core/extensions/object.dart';
import '../../core/extensions/string_extension.dart';
import '../../core/helpers/cache_service.dart';
import '../../core/navigation/navigator.dart';
import '../../core/notification/notification_service.dart';
import '../../core/shared/models/user_models/user_model.dart';
import '../../core/shared/user_cubit/user_cubit.dart';
import '../../core/widgets/splash_logo.dart';
import '../auth/imports.dart';
import '../home/home_screen.dart';
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
    super.initState();
  }


  void _manipulateSplashData()async{
    await NotificationService().saveFcmToken();
    await Future.delayed(const Duration(seconds: 2));
    final result = await CacheStorage.read(CacheConstant.onBoardingSubmission);
    switch(result){
      case true:
        _manipulateLoginState();
        break;

      default:
        Go.offAll(const OnBoardingView());
        break;
    }
  }

  Future<void> _manipulateLoginState()async{
    final result =  (await CacheStorage.read('user', isDecoded: true) as Object?).isNotNull;
    switch(result){
      case true:
        await UserCubit.instance.init();
        Go.offAll(const HomeScreen());
        break;

      default:
        Go.offAll(const LoginScreen());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashLogo();
  }
}
