import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../generated/assets.dart';
import '../../config/res/config_imports.dart';
import '../../core/helpers/cache_service.dart';
import '../../core/navigation/navigator.dart';
import '../../core/notification/notification_service.dart';
import '../../core/shared/models/title_value_shape.dart';
import '../../core/shared/models/user_models/individual/female_model.dart';
import '../../core/shared/models/user_models/user_model.dart';
import '../../core/shared/user_cubit/user_cubit.dart';
import '../auth/imports.dart';
import '../auth/models/kinship.dart';
import '../on_boarding/screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _testFakeData();
    _manipulateSplashData();
    _initApp();
    super.initState();
  }

  void _testFakeData(){
    final FemaleModel female = FemaleModel(
      id: 60,
      name: "جواهر القحطاني",
      parentId: null,
      type: TitleValueShape.fromJson({
        "value": "individual",
        "title": "فرد"
      }),
      gender: Gender.fromJson({'title' : 'انثي', 'value' : 'female'}),
      avatar: "https://setr.test/storage/uploads/users/1753656889_8377.jpg",
      phone: "500500902",
      countryCode: "966",
      fullPhone: "966500500902",
      identityNumber: "5005009002",
      age: 26,
      isActive: true,
      isBlocked: false,
      adminApprovalStatus: TitleValueShape.initial(),
      completeRegistration: "completed",
      token: "Bearer 166|WUktBilvQvagmy3p11HtZx9bKSBS6iEEqBmLXIgu",
      // token: "Bearer 163|HHo3wbY3XYokTkKKl8AdDxHFzgjbKzsiVDYL0EOl",
      // token: "Bearer 145|qjG9asgeoAZcqWJgRUzzj734XAw60PciGrxiInD4",
      nickName: "جوجو",
      maritalStatus: TitleValueShape.fromJson({'title' : 'انثي', 'value' : 'female'}),
      height: 160,
      weight: 52,
      currentJob: "معلمة",
      bio: "أبحث عن شريك حياة يقدّر الاحترام والصدق، وأحب الحياة الأسرية المستقرة.",
      hasChildren: true,
      numOfChildren: 2,
      childCustody: TitleValueShape.fromJson({'title' : 'انثي', 'value' : 'female'}),
      wantChildren: true,
      prohibitedThings: "الإهمال والكذب",
      dowryMin: 20000,
      dowryMax: 80000,
      weddingType: TitleValueShape.fromJson({'title' : 'انثي', 'value' : 'female'}),
      cityId: CityModel.fromJson({'title' : 'انثي', 'value' : 'female'}),
      educationLevel: "ماجستير",
      isPrayer: true,
      healthConditions: "حساسية بسيطة",
      chatLang: "ar",
      isSmoker: false,
      tribeAffiliation: true,
      skinColor: "white",
      religiousCommitment: TitleValueShape.fromJson({'title' : 'انثي', 'value' : 'female'}),
      views: 0,
      hijab: "hijab",
      acceptsPolygamy: false,
      preferredResidenceAfterMarriage: "المدينة المنورة",
      guardianName: "عبدالله القحطاني",
      guardianPhone: "500500511",
      guardianCountryCode: "966",
      guardianRelation: Kinship.fromJson(const {'id' : 1, 'name' : 'father'}),
    );

    UserCubit.instance.updateUser(female);
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
        Go.offAll(const LoginScreen());
        // await authLogin();
        break;

      default:
        Go.offAll(OnBoardingView());
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
