import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:zego_zpns/zego_zpns.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../../../generated/assets.dart';
import '../../core/zego_service/zego.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../../config/language/languages.dart';
import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../../features/auth/presentation/enums/complete_register_status.dart';
import '../../features/chats/data/chat_sheet_manager.dart';
import '../extensions/padding_extension.dart';
import '../extensions/string_extension.dart';
import '../navigation/navigator.dart';
import '../shared/models/user_models/user_model.dart';
import '../shared/user_cubit/user_cubit.dart';
import '../widgets/app_bottom_sheet.dart';
import '../widgets/custom_loading.dart';
import '../widgets/custom_messages.dart';
import '../widgets/default_bottom_sheet.dart';
import '../widgets/sheets/accept_chat_request_subscription_sheet.dart';
import '../widgets/sheets/complete_profile_required_sheet.dart';
import '../widgets/sheets/login_when_visitor.dart';
import 'nsfw_detector.dart';
import 'permission_handler/handler.dart';
import 'permission_handler/model.dart';

enum AppFlavor{dev, production, none}
extension Check on AppFlavor{
  bool get isDev => this == AppFlavor.dev;
  bool get isProduction => this == AppFlavor.production;
}


class Helpers {
  static Future<void> checkChatAccessRequirements({
    required Future<void> Function() onAccessGranted,
  }) async {
    final UserModel? currentUser = UserModel.currentUser;
    if (!(currentUser?.hasActivePackage ?? false)) {
      await showDefaultBottomSheet(
        child: const AcceptChatRequestSubscriptionSheet(),
      );
      return;
    }

    final bool hasCompletedProfile = currentUser!.completeRegistration ==
        CompleteRegisterStatus.completed.status;
    if (!hasCompletedProfile) {
      await showDefaultBottomSheet(
        child: CompleteProfileRequiredSheet(
          onCompleteProfilePressed: () => _openCompleteProfile(currentUser),
        ),
      );
      return;
    }

    await onAccessGranted.call();
  }

  static Future<void> _openCompleteProfile(UserModel user) async {
    Go.back();
    final String completeRegistration = user.completeRegistration ??
        CompleteRegisterStatus.incomplete.status;
    completeRegistration.manageNavigationBasedCompleteRegisterStatus(user);
  }

  static String get formatedDataTime => DateFormat('EEEE, dd MMMM yyyy - hh:mm a', 'en_US').format(DateTime.now());
  static String get getBundleId{
    if(currentFlavor.isDev){
      return ConstantManager.devBundleId;
    }
    return ConstantManager.bundleId;
  }

  static AppFlavor currentFlavor = AppFlavor.none;
  static Future<void> get getCurrentFlavor async{
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    log('info is ${packageInfo.packageName} ${packageInfo.appName}');
    switch(packageInfo.packageName){
      case ConstantManager.devBundleId:
        currentFlavor = AppFlavor.dev;

      case ConstantManager.bundleId:
        currentFlavor = AppFlavor.production;

      default:
        currentFlavor = AppFlavor.none;
    }

    log('the current flavor is $currentFlavor');
  }


  static void showRestartSheet()async{
    AppBottomSheet.large(
        asyncCall: (context) async {
          await Phoenix.rebirth(context);
        },
        btnTitle: LocaleKeys.updateAvailableUpdateNow,
        upperWidget: Lottie.asset(Assets.assets.lottie.error.errorView.path)
    );
  }
  static ZegoService? zegoService;
  static Future<void> initZegoData()async{
    zegoService = ZegoService(
        appId: ConstantManager.zegoAppId,
        appSign: ConstantManager.zegoAppSign,
        navigatorKey: Go.navigatorKey
    );

    await zegoService!.initZego();
    _handleZpns();
  }

  static void _handleZpns(){
    ZPNs.getInstance().applyNotificationPermission();
    final ZPNsConfig zpnsConfig = ZPNsConfig();
    zpnsConfig.enableFCMPush = true;
    ZPNs.setPushConfig(zpnsConfig);
    ZPNs.getInstance().registerPush(
        iOSEnvironment: ZPNsIOSEnvironment.Automatic,
        iOSNotificationArrivedConfig: ZPNsIOSNotificationArrivedConfig()
          ..isPresentBadge = true
          ..isPresentSound = true
          ..isPresentAlert = true,
        enableIOSVoIP: true,
    ).catchError((onError) {
      if (onError is PlatformException) {
        log(onError.message ?? "");
      }
    });
  }

  static Future<void> initZegoService({
   void Function(ZegoCallEndEvent, void Function())? onCallEnd,
}) async{
      final isConnected = await zegoService?.onUserLogin(
        onCallEnd: onCallEnd,
        currentUserId: UserCubit.instance.user.id.toString(),
        currentUserName: UserCubit.instance.user.name??'',
        callDuration: const Duration(minutes: 5)
      );

      if (isConnected ?? false) {
        log('✅ Zego service initialized successfully');
      } else {
        log('⚠️ Zego service failed to initialize');
      }
  }

  // static Widget handlePaymentSheet<T extends AsyncCubit>({
  //   List<PaymentMethod>? paymentMethods,
  //   required bool isInAuth,
  //   required Future<void> Function(BuildContext context, int brandId, void Function(String url) onSuccess) onPayOnline,
  //   Future<void> Function(BuildContext context, void Function() onSuccess)? onPayWallet,
  //   required T bloc,
  //   required Widget upperWidget,
  //   void Function(BuildContext context)? onFinish,
  // }){
  //   return BlocProvider(
  //     create: (context) => PaymentBrandsCubit(),
  //     child: Builder(
  //         builder: (context) {
  //           return PaymentSheet(
  //             paymentMethods: paymentMethods,
  //             onPay: (ctx, paymentMethod) async =>
  //             paymentMethod == PaymentMethod.online?
  //             executeOnlinePayment<T>(
  //               context,
  //               upperWidget: upperWidget,
  //               bloc: bloc,
  //               onFinish: onFinish!,
  //               onPay: onPayOnline, isInAuth: isInAuth,
  //             ) : _executeWalletPayment(
  //                 context,
  //                 onFinish: onFinish!,
  //                 onPayWallet: onPayWallet,
  //                 isInAuth: isInAuth
  //             ),
  //           );
  //         }
  //     ),
  //   );
  // }
  //
  // static void _executeWalletPayment(BuildContext context, {
  //   required bool isInAuth,
  //   Future<void> Function(BuildContext context, void Function() onSuccess)? onPayWallet,
  //   required void Function(BuildContext context) onFinish,
  // })async{
  //   await onPayWallet?.call(context, ()async{
  //     await _onPaymentSuccess(
  //         isInAuth: isInAuth,
  //         upperWidget: null
  //     );
  //
  //     onFinish.call(context);
  //   });
  // }
  //
  // static Future<void> executeOnlinePayment<T extends AsyncCubit>(BuildContext context, {
  //   bool isInAuth = false,
  //   required Widget upperWidget,
  //   required T bloc,
  //   required Future<void> Function(BuildContext context, int brandId, void Function(String url) onSuccess) onPay,
  //   required void Function(BuildContext context) onFinish,
  // })async{
  //     await context.read<PaymentBrandsCubit>().get(
  //         onSuccess: (data) => ChatSheetManager.show(
  //             child:  BlocProvider<T>(
  //               create: (context) => bloc,
  //               child: RadioSelectionWidget<int>(
  //                   selectedBackgroundColor: AppColors.primary.withOpacity(.2),
  //                   title: LocaleKeys.choosePaymentMethod,
  //                   onSubmit: (ctx, brandId) async => await onPay.call(ctx, brandId, (url) async{
  //                     final result = await Go.to(SubscriptionScreen(initialUrl: url));
  //                     if(result == 'success'){
  //                       await _onPaymentSuccess(
  //                           upperWidget: upperWidget,
  //                           isInAuth: isInAuth
  //                       );
  //
  //                       onFinish.call(ctx);
  //                     }
  //                   }),
  //                   values: data.map((e) => e.id??0).toList(),
  //                   showSubmitButton: true,
  //                   titles: List.generate(
  //                       data.length,
  //                           (i) => Expanded(child: Row(
  //                         spacing: 10.w,
  //                         children: [
  //                           CachedImage(
  //                               width: 50.w,
  //                               height: 50.h,
  //                               url: data[i].image??''
  //                           ),
  //                           AppText(data[i].name??''),
  //                         ],
  //                       ))
  //                   )
  //               ),
  //             )
  //         )
  //     );
  // }
  //
  // static Future<void> _onPaymentSuccess({
  //   required Widget? upperWidget,
  //   required bool isInAuth,
  // })async{
  //     await ChatSheetManager.show(
  //     child: SuccessSheet( // context comes from
  //       isInAuth: isInAuth,
  //       upperText: upperWidget,
  //     ));
  // }

  static void showUnauthenticatedSheet(){
    WidgetsBinding.instance.addPostFrameCallback(
            (_) => ChatSheetManager.show(
            child: const LoginWhenVisitorSheet()
        )
    );
  }
  static String get deviceType => Platform.isAndroid? 'android' : 'ios';

  static Alignment get getAlignment {
    if (Languages.currentLanguage == Languages.arabic) {
      return Alignment.topRight;
    } else {
      return Alignment.topLeft;
    }
  }

  static Future<File?> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final File imageFile = File(image.path);
      return imageFile;
    }
    return null;
  }

  static Future<List<File>> getImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> result = await picker.pickMultiImage();
    if (result.isNotEmpty) {
      final List<File> files = result.map((e) => File(e.path)).toList();
      return files;
    } else {
      return [];
    }
  }

  static void changeStatusbarColor({
    required Color statusBarColor,
    Brightness? statusBarIconBrightness,
  }) {
    return SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        statusBarIconBrightness: statusBarIconBrightness ?? Brightness.dark,
        systemNavigationBarColor: AppColors.main,
      ),
    );
  }

  static Future<void> checkPermission(
    Permission permission, {
    required FutureOr<void> Function(Permission permission)? onGranted,
    required FutureOr<void> Function(Permission permission)? onDenied,
    FutureOr<void> Function(Permission permission)? onDeniedForever,
    FutureOr<void> Function(Permission permission)? onLimited,
    bool openSettingsOnPermanentDenial = false,
  }) async {
    await PermissionHandler().checkPermission(
      openSetting: openSettingsOnPermanentDenial,
        permissionManagerModel: PermissionModel(
      permissions: [permission],
      onGranted: onGranted,
      onDenied: onDenied,
      onDeniedForever: onDeniedForever ?? onDenied,
      onPermissionLimited: onLimited ?? onGranted,
    ));
  }


  static Future<File?> _cropImage({required String sourcePath}) async {
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: sourcePath,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: AppColors.primary,
          toolbarWidgetColor: Colors.white,
          statusBarColor: AppColors.primary,
          activeControlsWidgetColor: AppColors.primary,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(),
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(),
          ],
        ),
      ],
    );
    return croppedFile != null ? File(croppedFile.path) : null;
  }

  static Future<File?> getImageFromCameraOrDevice() async {
    final ImagePicker picker = ImagePicker();
    File? image;
    await showModalBottomSheet(
        context: Go.navigatorKey.currentContext!,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: Text(LocaleKeys.photoLibrary),
                  onTap: () async {
                    checkPermission(
                      Platform.isIOS?
                      Permission.storage :
                      Permission.photos,
                      onGranted: (permission) async {
                        final currentImage = await picker.pickImage(source: ImageSource.gallery);
                        if (currentImage != null) {
                          final croppedImage = await _cropImage(sourcePath: currentImage.path);
                          if(croppedImage != null){
                            final bool isSafe = await NsfwDetectorHelper.isSafe(croppedImage)??false;
                            if(isSafe){
                              image = File(croppedImage.path);
                            }else{
                              MessageUtils.show(
                                LocaleKeys.thisImageHasSensitiveContentPleaseRechooseAnotherImage,
                                state: MsgState.info,
                              );
                            }
                          }
                        }
                        Go.back();
                      },
                      onDenied: (permission) {
                        MessageUtils.show(
                          LocaleKeys.unableToAccessPhotosPleaseOpenIt,
                          state: MsgState.info,
                        );
                      },
                      onDeniedForever: (permission) {
                        MessageUtils.show(
                          LocaleKeys.unableToAccessPhotosPleaseOpenIt,
                          state: MsgState.info,
                        );
                        openAppSettings();
                      },
                      onLimited: (permission) async {
                        // iOS limited photo access - treat as granted
                        final currentImage = await picker.pickImage(source: ImageSource.gallery);
                        if (currentImage != null) {
                          final croppedImage = await _cropImage(sourcePath: currentImage.path);
                          if(croppedImage != null){
                            final bool isSafe = await NsfwDetectorHelper.isSafe(croppedImage)??false;
                            if(isSafe){
                              image = File(croppedImage.path);
                            }else{
                              MessageUtils.show(
                                LocaleKeys.thisImageHasSensitiveContentPleaseRechooseAnotherImage,
                                state: MsgState.info,
                              );
                            }
                          }
                        }
                        Go.back();
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: Text(LocaleKeys.camera),
                  onTap: () async {
                    checkPermission(
                      Permission.camera,
                      onGranted: (permission) async {
                        final currentImage =
                            await picker.pickImage(source: ImageSource.camera);
                        if (currentImage != null) {
                          final croppedImage = await _cropImage(sourcePath: currentImage.path);
                          if(croppedImage != null){
                            final bool isSafe = await NsfwDetectorHelper.isSafe(croppedImage)??false;
                            if(isSafe){
                              image = File(croppedImage.path);
                            }else{
                              MessageUtils.show(
                                LocaleKeys.thisImageHasSensitiveContentPleaseRechooseAnotherImage,
                                state: MsgState.info,
                              );
                            }
                          }
                        }
                        Go.back();
                      },
                      onDenied: (permission) {
                        MessageUtils.show(
                          LocaleKeys.unableToAccessCameraPleaseOpenIt,
                          state: MsgState.info,
                        );
                      },
                      onDeniedForever: (permission) {
                        MessageUtils.show(
                          LocaleKeys.unableToAccessCameraPleaseOpenIt,
                          state: MsgState.info,
                        );
                        openAppSettings();
                      },
                    );
                  },
                ),
              ],
            ).paddingAll(AppPadding.pH10),
          );
        });
    return image;
  }

  static void shareApp(String url) {
    CustomLoading.showFullScreenLoading();
    final ShareParams params = ShareParams(uri: Uri.parse(url));
    SharePlus.instance.share(params).whenComplete(() {
      CustomLoading.hideFullScreenLoading();
    });
  }

  static String getDeviceType() {
    if (Platform.isIOS) {
      return 'ios';
    } else {
      return 'android';
    }
  }

  static String showByLang({
    required String ar,
    required String en,
  }) {
    if (Languages.currentLanguage.languageCode == 'ar') {
      return ar;
    } else {
      return en;
    }
  }
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (324, 214);

  @override
  String get name => '324 x 214 (3:2) Customized';
}
