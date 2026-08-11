// import 'package:flutter/material.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:shorebird_code_push/shorebird_code_push.dart';
//
// import 'cache_service.dart';
// import 'helpers.dart';
//
// class AutoUpdateService {
//   final String currentVersionKey = 'currentVersion';
//   Future<PackageInfo> get getInfo async => await PackageInfo.fromPlatform();
//   Future<String?> get getStoredVersion async => await CacheStorage.read(currentVersionKey);
//
//   Future<void> updateStoredVersion() async {
//     final PackageInfo info = await getInfo;
//     await CacheStorage.write(currentVersionKey, info.version);
//   }
//   Future<void> checkForUpdates() async {
//     final String? currentVersion = await getStoredVersion;
//     final PackageInfo info = await getInfo;
//     if(currentVersion != info.version){
//       _update();
//     }
//   }
//
//   Future<void> _update()async{
//     bool makeAnotherCheck = true;
//     final shorebirdCodePush = ShorebirdUpdater();
//     while (makeAnotherCheck) {
//       final status = await shorebirdCodePush.checkForUpdate();
//       final isUpdateAvailable = status == UpdateStatus.outdated;
//       final isRestartNeeded = status == UpdateStatus.restartRequired;
//
//       if (isUpdateAvailable) {
//         await shorebirdCodePush.update();
//       } else if (isRestartNeeded) {
//         WidgetsBinding.instance.addPostFrameCallback((_) => Helpers.showRestartSheet());
//         makeAnotherCheck = false;
//       } else {
//         makeAnotherCheck = false;
//       }
//     }
//   }
// }