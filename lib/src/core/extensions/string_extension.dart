import 'dart:developer';

import 'package:easy_localization/easy_localization.dart' as tr;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../config/language/languages.dart';
import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../../features/auth/imports.dart';
import '../../features/auth/presentation/cubits/add_child.dart';
import '../../features/auth/presentation/cubits/complete_profile_cubit.dart';
import '../../features/auth/presentation/cubits/oath.dart';
import '../../features/auth/presentation/enums/complete_register_status.dart';
import '../../features/auth/presentation/widgets/sign_up/sheets/add_child_sheet.dart';
import '../../features/auth/presentation/widgets/sign_up/sheets/complete_profile_sheet.dart';
import '../../features/chats/data/chat_sheet_manager.dart';
import '../../features/chats/enums.dart';
import '../../features/home/home_screen.dart';
import '../../features/packages/presentation/packages_screen.dart';
import '../base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../helpers/status_builder.dart';
import '../helpers/user_type_enum.dart';
import '../navigation/navigator.dart';
import '../network/api_endpoints.dart';
import '../network/network_service.dart';
import '../shared/models/user_models/user_model.dart';
import '../shared/user_cubit/user_cubit.dart';
import '../widgets/app_bottom_sheet.dart' show AppBottomSheet;
import '../widgets/app_text.dart';
import '../widgets/sheets/payment_sheet.dart';


extension FormatString on String {
  ShowTips get currentStageTips{
    return ShowTips.values
        .firstWhere((element) => element.title == this,
        orElse: () => ShowTips.chattingStageTips
    );
  }

  String get currentStageTipsTitle{
    if(this == ShowTips.istikharahTips.title){
      return LocaleKeys.tipsForIstikharahPhase;

    }else if(this == ShowTips.shariaComplaintMeetingTips.title){
      return LocaleKeys.tipsForShariaComplaintMeeting;

    }else if(this == ShowTips.shariaComplaintMeetingTerms.title){
      return LocaleKeys.tipsForShariaComplaintMeeting;

    }else if(this == ShowTips.chattingStageTips.title){
      return LocaleKeys.tipsForTheStageOfSufficientKnowledge;

    }else if(this == ShowTips.informParentsTips.title){
      return LocaleKeys.tipsForTheParentingStage;

    }else if(this == ShowTips.engagementTips.title){
      return LocaleKeys.tipsForEngagementStage;

    }else if(this == ShowTips.parentIndividualConversationTips.title){
      return LocaleKeys.tipsPorParentIndividualConversation;

    }

    return '';
  }


  ChatStages get getCurrentStageAsStagesEnum {
    return ChatStages.values
        .firstWhere((e) => this == e.stageText,
        orElse: () => ChatStages.chatting
    );
  }

  MatchRequestEnum get getMatchRequestAsEnum => MatchRequestEnum.values
      .firstWhere((e) => this == e.requestName,
      orElse: () => MatchRequestEnum.noRequests
  );

  UserRequestStatus get getUserRequestStatusAsEnum => UserRequestStatus.values
      .firstWhere((e) => this == e.statusText,
      orElse: () => UserRequestStatus.undefined
  );


  int calculateRenderedLines({
    required BuildContext context,
    required String text,
    required double maxWidth,
    TextStyle style = const TextStyle(),
  }) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.start,
      maxLines: null,
    );

    // لازم نحط maxWidth
    textPainter.layout(maxWidth: maxWidth);

    return textPainter.computeLineMetrics().length;
  }



  /// 1) عدد السطور المنطقي (count of '\n' + 1)
  int get getLinesCount {
    if (isEmpty) return 0;
    return split('\n').length;
  }

  // /// 2) عدد السطور بعد الرندر (wrap) باستخدام TextPainter
  // ///
  // /// - [style]: مطلوب (حجم/وزن/خط)
  // /// - [maxWidth]: مطلوب — المساحة المتاحة لعرض النص (بالـ pixels)
  // /// - [textDirection]: افتراضي ltr
  // /// - [textAlign]: افتراضي start
  // /// - [maxLines]: اذا عايز تحصر بعدد أقصى من السطور
  // /// - [textScaleFactor]: عادة تأخذ من MediaQuery
  int renderedLineCount({
    TextAlign textAlign = TextAlign.start,
    int? maxLines,
    double textScaleFactor = 1.0,
    StrutStyle? strutStyle,
  }) {
    if (isEmpty) return 0;

    final tp = TextPainter(
      text: TextSpan(text: this),
      textDirection: TextDirection.ltr,
      textAlign: textAlign,
      maxLines: maxLines,
      textScaleFactor: textScaleFactor,
      strutStyle: strutStyle,
    );

    // layout with given maxWidth
    tp.layout();

    // computeLineMetrics gives a LineMetrics per visual line
    final metrics = tp.computeLineMetrics();
    return metrics.length;
  }



  bool get isImage =>
      contains('jpg') ||
          contains('png') ||
          contains('svg') ||
          contains('gif');

  String get pathToRequest{
    if(this == LocaleKeys.moveToNextStage){
      return ApiConstants.matchRequestAnd+ApiConstants.userMoveToNextRequest;

    }else if(this == LocaleKeys.refuseMoveToNextStage){
      return ApiConstants.rejectAll;

    }else if(this == LocaleKeys.requestForExtensionOfPeriod){
      return ApiConstants.matchRequestAnd+ApiConstants.userExtensionRequest;

    }else{
      log('this is $this');
      return '';
    }
  }

  Languages toLang(){
    if(this == Languages.arabic.locale.languageCode || this == Languages.arabic.title){
      return Languages.arabic;
    }

    return Languages.english;
  }

  void manageNavigationBasedCompleteRegisterStatus(UserModel user)async{
    final CompleteRegisterStatus statusType = user.completeRegistration!.toCompleteRegisterStatus();
    // await UserCubit.instance.init();
    if(statusType.isCompleted){
      ChatSheetManager.show(
          child: BlocProvider(
            create: (context) => OathCubit()..getOath(),
            child: AppBottomSheet.small(
                asyncCall: (context) async {
                  Go.offAll(const HomeScreen());
                },
                btnTitle: LocaleKeys.accept,
                upperWidget: Column(
                  children: [
                    AppText(LocaleKeys.oath, fontWeight: FontWeight.w500),
                    BlocBuilder<OathCubit, AsyncState<String>>(
                        builder: (context, state) => StatusBuilder(
                            data: state,
                            onSuccess: (oath, context) => Html(
                              data: oath,
                            )
                        )
                    ),
                  ],
                )
            ),
          )
      );

    }else if(statusType.isNotSubscribed){
      injector<NetworkService>().setToken(user.token ?? '');
      Go.off(PackagesScreen.subscription(
        paymentMethods: const [PaymentMethod.online],
        userType: user.type?.userType,
        isInAuth: true,
      ));

    }else if(statusType.isCompleteChild){
      Go.off(EnterMaleOrFemaleOrChildDataScreen.showAll(
          scaffoldType: ScaffoldType.centerCard,
          showConditionsAndTerms: true,
          showAlreadyHaveAccount: true,
          onClick: (context, user) => context.read<AddChildCubit>().addChild(
            body: user,
          )
      ));

    }else if(statusType.isHasSetrCode){
      Go.off(
          user.type!.userType!.isParent?
          EnterMaleOrFemaleOrChildDataScreen.showAll(
              scaffoldType: ScaffoldType.centerCard,
              showConditionsAndTerms: true,
              showAlreadyHaveAccount: true,
              onClick: (context, user) => context.read<AddChildCubit>().addChild(
                body: user,
              )
          ) :
          EnterMaleOrFemaleOrChildDataScreen.individual(
            scaffoldType: ScaffoldType.centerCard,
            showConditionsAndTerms: true,
            showAlreadyHaveAccount: true,
            userType: user.gender!.userGender,
            onClick: (context, formUser) => context.read<CompleteProfileCubit>().completeProfile(
                body: formUser, onSuccess: (responseUser) async {
              await UserCubit.instance.setUserLoggedIn(user: responseUser, token: responseUser.token ?? '');
              Go.offAll(const HomeScreen());
            }),
          )
      );

    }else if(statusType.isIncomplete){
      Go.off(EnterMaleOrFemaleOrChildDataScreen.individual(
        scaffoldType: ScaffoldType.centerCard,
        showConditionsAndTerms: true,
        showAlreadyHaveAccount: true,
        userType: user.gender!.userGender,
        onClick: (context, formUser) => context.read<CompleteProfileCubit>().completeProfile(
            body: formUser, onSuccess: (responseUser) async {
          await UserCubit.instance.setUserLoggedIn(user: responseUser, token: responseUser.token ?? '');
          Go.offAll(const HomeScreen());
        }),
      ));

    }else{
      throw Exception('there is no such value with $statusType');
    }
  }


  CompleteRegisterStatus toCompleteRegisterStatus(){
    log('complete register state is $this');
    if(this == CompleteRegisterStatus.completed.status){
      return CompleteRegisterStatus.completed;

    }else if(this == CompleteRegisterStatus.notSubscribed.status){
      return CompleteRegisterStatus.notSubscribed;

    }else if(this == CompleteRegisterStatus.hasSetrCode.status){
      return CompleteRegisterStatus.hasSetrCode;

    }else if(this == CompleteRegisterStatus.completeChild.status){
      return CompleteRegisterStatus.completeChild;

    }else if(this == CompleteRegisterStatus.incomplete.status){
      return CompleteRegisterStatus.incomplete;

    }else {
      throw Exception('not such value match with value $this');
    }
  }

  UserGender toUserGender(){
    if(this == LocaleKeys.male || this == UserGender.male.name){
      return UserGender.male;

    }else if(this == LocaleKeys.female || this == UserGender.female.name){
      return UserGender.female;

    }else{
      return UserGender.unknown;
    }
  }

  UserType toUserType(){
    if(this == UserType.individual.name){
      return UserType.individual;

    }else if(this == UserType.parent.name){
      return UserType.parent;

    }else if(this == UserType.child.name){
      return UserType.child;

    }else{
      return UserType.unknown;
    }
  }

  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String toEnglishNumbers() {
    return replaceAll('٠', '0')
        .replaceAll('١', '1')
        .replaceAll('٢', '2')
        .replaceAll('٣', '3')
        .replaceAll('٤', '4')
        .replaceAll('٥', '5')
        .replaceAll('٦', '6')
        .replaceAll('٧', '7')
        .replaceAll('٨', '8')
        .replaceAll('٩', '9');
  }

  String toCurrency() {
    final formatter = tr.NumberFormat('#,###');
    return formatter.format(double.parse(this));
  }

  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: this));
  }

  String get locale {
    return this.tr();
  }

  bool isNumeric() {
    return double.tryParse(this) != null;
  }

  String toCamelCase() {
    return this[0].toUpperCase() +
        substring(1).replaceAllMapped(
            RegExp('[_-](.)'), (Match match) => match.group(1)!.toLowerCase());
  }
}

extension FormatDouble on double {
  String toCurrency() {
    final formatter = tr.NumberFormat('#,###');
    return formatter.format(this);
  }
}

extension DateTimeFormatHelper on DateTime {
  String toTime([String? locale]) {
    return tr.DateFormat('hh:mm a', locale).format(this);
  }

  String toTimeWithoutPmAndAm([String? locale]) {
    return tr.DateFormat('hh:mm', locale).format(this);
  }

  String toAmAndPm([String? locale]) {
    return tr.DateFormat('a', locale).format(this);
  }

  String toFullDate({String? locale, String key = '-'}) {
    return tr.DateFormat('yyyy${key}MM${key}dd').format(this);
  }

  String toFullDateTime([String? locale]) {
    return tr.DateFormat('yyyy-MM-dd HH:mm').format(this);
  }

  String toDay([String? locale]) {
    return tr.DateFormat('EEEE').format(this);
  }

  String toMonth([String? locale]) {
    return tr.DateFormat('MMMM').format(this);
  }

  String toMonthShort([String? locale]) {
    return tr.DateFormat('MMM').format(this);
  }

  String toDayMonth([String? locale]) {
    return tr.DateFormat('dd MMMM').format(this);
  }

  String toDayMonthShort([String? locale]) {
    return tr.DateFormat('dd MMM').format(this);
  }

  String toDayMonthYear([String? locale]) {
    return tr.DateFormat('dd MMMM yyyy').format(this);
  }

  String toDayMonthYearShort([String? locale]) {
    return tr.DateFormat('dd MMM yyyy').format(this);
  }

  String toDayMonthYearTime([String? locale]) {
    return tr.DateFormat('dd MMMM yyyy HH:mm').format(this);
  }

  String toDayMonthYearTimeShort([String? locale]) {
    return tr.DateFormat('dd MMM yyyy HH:mm').format(this);
  }

  String toDayMonthYearTimeSeconds([String? locale]) {
    return tr.DateFormat('dd MMMM yyyy HH:mm:ss').format(this);
  }

  String toDayMonthYearTimeSecondsShort([String? locale]) {
    return tr.DateFormat('dd MMM yyyy HH:mm:ss').format(this);
  }
}
