import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/language/languages.dart';
import '../../config/language/locale_keys.g.dart';
import '../../features/auth/imports.dart';
import '../../features/auth/presentation/cubits/add_child.dart';
import '../../features/auth/presentation/cubits/complete_profile_cubit.dart';
import '../../features/auth/presentation/enums/complete_register_status.dart';
import '../../features/auth/presentation/widgets/sign_up/sheets/add_child_sheet.dart';
import '../../features/auth/presentation/widgets/sign_up/sheets/complete_profile_sheet.dart';
import '../../features/chats/enums.dart';
import '../../features/home/home_screen.dart';
import '../../features/packages/presentation/packages_screen.dart';
import '../helpers/user_type_enum.dart';
import '../navigation/navigator.dart';
import '../network/api_endpoints.dart';
import '../shared/models/user_models/user_model.dart';
import '../widgets/default_bottom_sheet.dart';
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

    }

    return '';
  }


  ChatStages get getCurrentStageAsStagesEnum {
    log('the text is $this');
    return ChatStages.values
        .firstWhere((e) => this == e.stageText);
  }

  MatchRequestEnum get getMatchRequestAsEnum => MatchRequestEnum.values
      .firstWhere((e) => this == e.requestName.split("/").last);

  UserRequestStatus get getUserRequestStatusAsEnum => UserRequestStatus.values
      .firstWhere((e) => this == e.statusText);

  bool get isImage =>
      contains('jpg') ||
          contains('png') ||
          contains('svg') ||
          contains('gif');

  String get pathToRequest{
    if(this == LocaleKeys.moveToNextStage){
      return ApiConstants.userMoveToNextRequest;

    }else if(this == LocaleKeys.refuseMoveToNextStage){
      return ApiConstants.rejectAll;

    }else if(this == LocaleKeys.requestForExtensionOfPeriod){
      return ApiConstants.userExtensionRequest;

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

  void manageNavigationBasedCompleteRegisterStatus(){
    final CompleteRegisterStatus statusType = toCompleteRegisterStatus();
    if(statusType.isCompleted){
      Go.offAll(const HomeScreen());

    }else if(statusType.isNotSubscribed){
      Go.to(const PackagesScreen.subscription(
          paymentMethods: [PaymentMethod.online],
          isInAuth: true,
      ));

    }else if(statusType.isCompleteChild){
      Go.to(EnterMaleOrFemaleOrChildDataScreen.showAll(
          scaffoldType: ScaffoldType.centerCard,
          showConditionsAndTerms: true,
          showAlreadyHaveAccount: true,
          onClick: (context, user) => context.read<AddChildCubit>().addChild(
            body: user, onSuccess: () => showDefaultBottomSheet(child: const AddChildSheet()),
          )
      ));

    }else if(statusType.isHasSetrCode){
      Go.to(
          UserTypeHelper.currentType!.isParent?
          EnterMaleOrFemaleOrChildDataScreen.showAll(
              scaffoldType: ScaffoldType.centerCard,
              showConditionsAndTerms: true,
              showAlreadyHaveAccount: true,
              onClick: (context, user) => context.read<AddChildCubit>().addChild(
                body: user, onSuccess: () => showDefaultBottomSheet(child: const AddChildSheet()),
              )
          ) :
          EnterMaleOrFemaleOrChildDataScreen.individual(
            scaffoldType: ScaffoldType.centerCard,
            showConditionsAndTerms: true,
            showAlreadyHaveAccount: true,
            userType: UserModel.currentUser?.gender?.userType,
            onClick: (context, user) => context.read<CompleteProfileCubit>().completeProfile(
              body: user, onSuccess: () => showDefaultBottomSheet(child: const CompleteProfileSheet()),
            ),
          )
      );

    }else if(statusType.isIncomplete){
      Go.to(EnterMaleOrFemaleOrChildDataScreen.individual(
        scaffoldType: ScaffoldType.centerCard,
        showConditionsAndTerms: true,
        showAlreadyHaveAccount: true,
        userType: UserModel.currentUser?.gender?.userType,
        onClick: (context, user) => context.read<CompleteProfileCubit>().completeProfile(
          body: user, onSuccess: () => showDefaultBottomSheet(child: const CompleteProfileSheet()),
        ),
      ));

    }else{
      throw Exception('there is no such value with $statusType');
    }
  }


  CompleteRegisterStatus toCompleteRegisterStatus(){
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

  UserType toUserType(){
    if(this == UserType.male.name){
      return UserType.male;

    }else if(this == UserType.female.name){
      return UserType.female;

    }else if(this == UserType.parent.name){
      return UserType.parent;

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
    final formatter = NumberFormat('#,###');
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
    final formatter = NumberFormat('#,###');
    return formatter.format(this);
  }
}

extension DateTimeFormatHelper on DateTime {
  String toTime([String? locale]) {
    return DateFormat('hh:mm a', locale).format(this);
  }

  String toTimeWithoutPmAndAm([String? locale]) {
    return DateFormat('hh:mm', locale).format(this);
  }

  String toAmAndPm([String? locale]) {
    return DateFormat('a', locale).format(this);
  }

  String toFullDate({String? locale, String key = '-'}) {
    return DateFormat('yyyy${key}MM${key}dd').format(this);
  }

  String toFullDateTime([String? locale]) {
    return DateFormat('yyyy-MM-dd HH:mm').format(this);
  }

  String toDay([String? locale]) {
    return DateFormat('EEEE').format(this);
  }

  String toMonth([String? locale]) {
    return DateFormat('MMMM').format(this);
  }

  String toMonthShort([String? locale]) {
    return DateFormat('MMM').format(this);
  }

  String toDayMonth([String? locale]) {
    return DateFormat('dd MMMM').format(this);
  }

  String toDayMonthShort([String? locale]) {
    return DateFormat('dd MMM').format(this);
  }

  String toDayMonthYear([String? locale]) {
    return DateFormat('dd MMMM yyyy').format(this);
  }

  String toDayMonthYearShort([String? locale]) {
    return DateFormat('dd MMM yyyy').format(this);
  }

  String toDayMonthYearTime([String? locale]) {
    return DateFormat('dd MMMM yyyy HH:mm').format(this);
  }

  String toDayMonthYearTimeShort([String? locale]) {
    return DateFormat('dd MMM yyyy HH:mm').format(this);
  }

  String toDayMonthYearTimeSeconds([String? locale]) {
    return DateFormat('dd MMMM yyyy HH:mm:ss').format(this);
  }

  String toDayMonthYearTimeSecondsShort([String? locale]) {
    return DateFormat('dd MMM yyyy HH:mm:ss').format(this);
  }
}
