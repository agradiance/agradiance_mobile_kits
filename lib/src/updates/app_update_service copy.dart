// import 'dart:async';
// import 'dart:io' show Platform;

// import 'package:flutter/services.dart' show PlatformException;
// import 'package:in_app_update_flutter/in_app_update_flutter.dart';
// import 'package:material_ui/material_ui.dart';

// /// flexible  = Play's own prompt, then the download runs in the background
// ///             while the user keeps using the app
// /// immediate = Play's own full-screen flow (for critical updates)
// enum AppUpdateType { flexible, immediate }

// /// Updates through Google Play's in-app update flow. All the update screens
// /// (the consent prompt and the full-screen immediate flow) are Play's own, so
// /// this app shows no update dialog or sheet of its own. The only app UI left
// /// is a snack bar for results Play doesn't show, such as "up to date" and
// /// "update downloaded, restart".
// class AppUpdateService {
//   AppUpdateService._internal();

//   static AppUpdateService instance = AppUpdateService._internal();

//   factory AppUpdateService() {
//     return instance;
//   }

//   final InAppUpdateFlutter plugin = InAppUpdateFlutter();

//   StreamSubscription<InstallStateAndroid>? _installSub;
//   bool _running = false;

//   /// In-app updates via Google Play only exist on Android.
//   bool get isSupported => Platform.isAndroid;

//   /// Stream of download progress, only emits during a flexible update.
//   Stream<InstallStateAndroid> get installStates => plugin.installStateStreamAndroid;

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

//   bool canUpdate(AppUpdateInfoAndroid? info) => info?.updateAvailability == UpdateAvailabilityAndroid.updateAvailable;

//   /// Starts the Play update flow. Falls back to the other type if the
//   /// requested one isn't allowed. Returns null if neither is allowed.
//   Future<UpdateResultAndroid?> startUpdate(
//     AppUpdateInfoAndroid info, {
//     AppUpdateType type = AppUpdateType.flexible,
//   }) async {
//     final wantImmediate = type == AppUpdateType.immediate && info.isImmediateUpdateAllowed;

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

//   /// Checks Play for an update and, if there is one, hands over to Play's own
//   /// update UI.
//   ///
//   /// With [notifyWhenUpToDate] (use it for a manual "Check for updates" tap)
//   /// a short message is shown when there is nothing to install or the check
//   /// fails. Without it, an automatic check stays silent in those cases.
//   Future<void> checkAndUpdate({
//     required BuildContext context,
//     bool notifyWhenUpToDate = false,
//     AppUpdateType updateType = AppUpdateType.flexible,
//   }) async {
//     if (_running) return;
//     _running = true;

//     // Taken now, because the screen may be gone by the time a download finishes.
//     final messenger = ScaffoldMessenger.maybeOf(context);

//     void say(String message, {SnackBarAction? action, Duration duration = const Duration(seconds: 4)}) {
//       messenger
//         ?..hideCurrentSnackBar()
//         ..showSnackBar(SnackBar(content: Text(message), action: action, duration: duration));
//     }

//     try {
//       if (!isSupported) {
//         if (notifyWhenUpToDate) say('Updates through Google Play are only available on Android.');
//         return;
//       }

//       final info = await checkForUpdate();
//       if (info == null) {
//         if (notifyWhenUpToDate) say("Couldn't check for updates. Please try again later.");
//         return;
//       }
//       if (!canUpdate(info)) {
//         if (notifyWhenUpToDate) say("You're up to date.");
//         return;
//       }

//       // Listen before starting, so the "downloaded" event can't be missed.
//       final flexible = updateType == AppUpdateType.flexible && info.isFlexibleUpdateAllowed;
//       if (flexible) {
//         await _installSub?.cancel();
//         _installSub = installStates.listen((state) {
//           if (state.status == InstallStatusAndroid.downloaded) {
//             _installSub?.cancel();
//             _installSub = null;
//             say(
//               'An update has been downloaded.',
//               duration: const Duration(days: 1),
//               action: SnackBarAction(label: 'Restart', onPressed: completeUpdate),
//             );
//           }
//         });
//       }

//       // Play shows its own prompt here. For an immediate update it also takes
//       // over the screen and restarts the app when it finishes.
//       final result = await startUpdate(info, type: updateType);

//       if (result == UpdateResultAndroid.success) {
//         if (flexible) say('Downloading the update in the background.');
//       } else {
//         await _installSub?.cancel();
//         _installSub = null;
//         if (result == UpdateResultAndroid.inAppUpdateFailed) {
//           say("The update couldn't be started. Please try again.");
//         } else if (result == null && notifyWhenUpToDate) {
//           say("An update isn't available right now.");
//         }
//         // Otherwise the user declined Play's prompt, which needs no message.
//       }
//     } finally {
//       _running = false;
//     }
//   }

//   /// Kept so existing calls still work. It no longer shows an app dialog: it
//   /// runs [checkAndUpdate], which uses Play's own update UI.
//   Future<void> showUpdateDialog({
//     required BuildContext context,
//     required bool showWhenUptodate,
//     AppUpdateType updateType = AppUpdateType.flexible,
//   }) {
//     return checkAndUpdate(context: context, notifyWhenUpToDate: showWhenUptodate, updateType: updateType);
//   }
// }
