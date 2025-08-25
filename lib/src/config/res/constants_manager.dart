part of 'config_imports.dart';

final GetIt injector = GetIt.instance;

class ConstantManager {
  static const String bundleId = 'com.aait.flutter.sitr';
  static const String appName = 'sitr';
  static const String fontFamily = '';
  static const String token = 'token';
  static const String projectName = 'sitr';
  static const int splashTimer = 3000;
  static const String baseUrl = '';
  static const int paginationFirstPage = 1;
  static const int paginationPageSize = 10;
  static const String emptyText = '';
  static const int zero = 0;
  static const double zeroAsDouble = 0.0;
  static const int pinCodeFieldsCount = 4;
  static const int maxLines = 4;
  static const double snackbarElevation = 4;
  static const int snackbarDuration = 4;
  static const int connectTimeoutDuration = 180;
  static const int recieveTimeoutDuration = 180;
  static const double customImageSliderAsepctRatio = 3;
  static const String ar = 'ar';
  static const String en = 'en';
  static const String arabic = 'العربية';
  static const String english = 'English';
  static String saudiArabCountryCode =
      Languages.currentLanguage.languageCode == 'ar' ? '966+' : '+966';
  static const int pgSize = 10;
  static String platform = Platform.isAndroid ? 'android' : 'ios';
  static const int pgFirst = 1;
  static const double cardElevation = 1;
  static const int rateCount = 5;
  static const double minRateCount = 1;
}

class CacheConstant{
  static const String onBoardingSubmission = "onBoardingSubmission";
  static const String isLoggedIn = "isLoggedIn";
}
