import 'dart:async';
import 'dart:developer';
import 'dart:io';
import '../../core/zego_service/zego.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../../config/language/languages.dart';
import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../extensions/padding_extension.dart';
import '../navigation/navigator.dart';
import '../shared/user_cubit/user_cubit.dart';
import '../widgets/custom_loading.dart';
import '../widgets/custom_messages.dart';
import '../widgets/default_bottom_sheet.dart';
import '../widgets/sheets/login_when_visitor.dart';
import 'permission_handler/handler.dart';
import 'permission_handler/model.dart';

class Helpers {
  static late ZegoService zegoService;
  static Future<void> initZegoService() async{
      zegoService = ZegoService(
          appId: ConstantManager.zegoAppId,
          appSign: ConstantManager.zegoAppSign,
          navigatorKey: Go.navigatorKey
      );

      await zegoService.initZego();
      final isConnected = await zegoService.onUserLogin(
          currentUserId: UserCubit.instance.user.id.toString(),
          currentUserName: UserCubit.instance.user.name??''
      );

      if (isConnected) {
        log('✅ Zego service initialized successfully');
      } else {
        log('⚠️ Zego service failed to initialize');
      }
  }

  static void showUnauthenticatedSheet(){
    WidgetsBinding.instance.addPostFrameCallback(
            (_) => showDefaultBottomSheet(
              enableDrag: false,
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
  }) async {
    await PermissionHandler().checkPermission(
        permissionManagerModel: PermissionModel(
      permissions: [permission],
      onGranted: onGranted,
      onDenied: onDenied,
      onDeniedForever: onDenied,
    ));
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
                    checkPermission(Permission.photos, onGranted: (permission) async {
                      final currentImage =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (currentImage != null) {
                        image = File(currentImage.path);
                      }
                      Go.back();
                    }, onDenied: (permission) {
                      MessageUtils.showSnackBar(
                          LocaleKeys.unableToAccessPhotosPleaseOpenIt);
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: Text(LocaleKeys.camera),
                  onTap: () async {
                    checkPermission(Permission.camera, onGranted: (permission) async {
                      final currentImage =
                          await picker.pickImage(source: ImageSource.camera);
                      if (currentImage != null) {
                        image = File(currentImage.path);
                      }
                      Go.back();
                    }, onDenied: (permission) {
                      MessageUtils.showSnackBar(
                          LocaleKeys.unableToAccessCameraPleaseOpenIt);
                    });
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
