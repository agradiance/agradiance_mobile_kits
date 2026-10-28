// import 'dart:async';
// import 'dart:io' show Platform;

// import 'package:agradiance_mobile_kits/src/updates/custom_app_update_modal_sheet.dart';
// import 'package:flutter/services.dart' show PlatformException;
// import 'package:in_app_update_flutter/in_app_update_flutter.dart';
// import 'package:material_ui/material_ui.dart';

// enum DisplayMode { dialog, bottomSheet }

// /// flexible  = downloads in background, user keeps using the app
// /// immediate = full-screen blocking flow (for critical updates)
// enum AppUpdateType { flexible, immediate }

// class AppUpdateService {
//   AppUpdateService._internal();

//   static AppUpdateService instance = AppUpdateService._internal();

//   factory AppUpdateService() {
//     return instance;
//   }

//   final InAppUpdateFlutter plugin = InAppUpdateFlutter();

//   /// In-app updates via Google Play only exist on Android.
//   bool get isSupported => Platform.isAndroid;

//   /// Stream of download progress, only emits during a flexible update.
//   Stream<InstallStateAndroid> get installStates =>
//       plugin.installStateStreamAndroid;

//   /// Returns null when unsupported, or when the Play check fails
//   /// (not installed from Play, no network, emulator, etc.).
//   Future<AppUpdateInfoAndroid?> checkForUpdate() async {
//     if (!isSupported) return null;
//     try {
//       return await plugin.checkUpdateAndroid();
//     } on PlatformException catch (e) {
//       debugPrint('checkUpdateAndroid failed: ${e.code} ${e.message}');
//       return null;
//     }
//   }

//   bool canUpdate(AppUpdateInfoAndroid? info) =>
//       info?.updateAvailability == UpdateAvailabilityAndroid.updateAvailable;

//   /// Starts the Play update flow. Falls back to the other type if the
//   /// requested one isn't allowed. Returns null if neither is allowed.
//   Future<UpdateResultAndroid?> startUpdate(
//     AppUpdateInfoAndroid info, {
//     AppUpdateType type = AppUpdateType.flexible,
//   }) async {
//     final wantImmediate =
//         type == AppUpdateType.immediate && info.isImmediateUpdateAllowed;

//     try {
//       if (wantImmediate) {
//         return await plugin.startImmediateUpdateAndroid();
//       }
//       if (info.isFlexibleUpdateAllowed) {
//         return await plugin.startFlexibleUpdateAndroid();
//       }
//       if (info.isImmediateUpdateAllowed) {
//         return await plugin.startImmediateUpdateAndroid();
//       }
//     } on PlatformException catch (e) {
//       debugPrint('startUpdate failed: ${e.code} ${e.message}');
//       return UpdateResultAndroid.inAppUpdateFailed;
//     }
//     return null;
//   }

//   /// Call once a flexible update has finished downloading.
//   Future<void> completeUpdate() async {
//     try {
//       await plugin.completeUpdateAndroid();
//     } on PlatformException catch (e) {
//       debugPrint('completeUpdateAndroid failed: ${e.code} ${e.message}');
//     }
//   }

//   Future<void> showUpdateDialog({
//     required BuildContext context,
//     required bool showWhenUptodate,
//     DisplayMode displayMode = DisplayMode.dialog,
//     AppUpdateType updateType = AppUpdateType.flexible,
//     String? releaseNotes,
//   }) async {
//     AppUpdateInfoAndroid? info;

//     if (!showWhenUptodate) {
//       info = await checkForUpdate();
//       if (!canUpdate(info)) return;
//     }

//     // ignore: use_build_context_synchronously
//     if (!context.mounted) return;

//     final sheet = CustomAppUpdateModalSheet(
//       updateInfo: info,
//       updateType: updateType,
//       releaseNotes: releaseNotes,
//     );

//     if (displayMode == DisplayMode.bottomSheet) {
//       await showModalBottomSheet(
//         isScrollControlled: true,
//         shape: const RoundedRectangleBorder(),
//         context: context,
//         builder: (context) => PopScope(canPop: false, child: sheet),
//       );
//     } else {
//       await showDialog(
//         context: context,
//         builder: (context) => PopScope(
//           canPop: false,
//           child: Material(child: AlertDialog(content: sheet)),
//         ),
//       );
//     }
//   }
// }
