import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../generated/assets.dart';
import '../../config/res/config_imports.dart';
import '../../core/extensions/object.dart';
import '../../core/extensions/string_extension.dart';
import '../../core/helpers/cache_service.dart';
import '../../core/helpers/helpers.dart';
import '../../core/navigation/navigator.dart';
import '../../core/notification/notification_service.dart';
import '../../core/shared/models/user_models/user_model.dart';
import '../../core/shared/user_cubit/user_cubit.dart';
import '../../core/widgets/splash_logo.dart';
import '../../core/zego_service/zego.dart';
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
    _initApp();
    _manipulateSplashData();
    super.initState();
  }

  void _initApp() async {
    NotificationNavigator(
      onRoutingMessage: (message) {
        NotificationRoutes.navigateByType(message.data);
      },
      onNoInitialMessage: () {},
    );
    await injector<NotificationService>()
        .setupNotifications();
  }

  void _manipulateSplashData()async{
    // await _initZego();

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

  void _handleAuthorizedState()async{
    final result =  await CacheStorage.read('user', isDecoded: true);
    final user = UserModel.fromJson(result);
    UserCubit.instance.user.completeRegistration?.manageNavigationBasedCompleteRegisterStatus(user);
  }

  Future<void> _manipulateLoginState()async{
    final result =  (await CacheStorage.read('user', isDecoded: true) as Object?).isNotNull;
    switch(result){
      case true:
        // Go.offAll(const LoginScreen());

        // await UserCubit.instance.init();
        // Go.offAll(const HomeScreen());
        _handleAuthorizedState();
        break;

      default:
        Go.offAll(const LoginScreen());
        break;
    }
  }

  // Future<void> _initZego()async{
  //   await Helpers.initZegoService();
  // }

  @override
  Widget build(BuildContext context) {
    return const SplashLogo();
  }
}
