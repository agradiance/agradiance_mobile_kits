import 'dart:async';

import 'package:agradiance_mobile_kits/gen/assets.gen.dart';
import 'package:agradiance_mobile_kits/src/extensions/build_context_extension.dart';
import 'package:agradiance_mobile_kits/src/extensions/text_extension.dart';
import 'package:agradiance_mobile_kits/src/updates/app_update_service.dart';
import 'package:agradiance_mobile_kits/src/widgets/custom_button.dart';
import 'package:agradiance_mobile_kits/src/widgets/failed_state_button.dart';
import 'package:agradiance_mobile_kits/src/widgets/loading_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_update_flutter/in_app_update_flutter.dart';

class CustomAppUpdateModalSheet extends StatefulWidget {
  const CustomAppUpdateModalSheet({
    super.key,
    this.updateInfo,
    this.updateType = AppUpdateType.flexible,
    this.releaseNotes,
  });

  final AppUpdateInfoAndroid? updateInfo;
  final AppUpdateType updateType;

  /// Play's API doesn't return release notes, so pass them in if you want
  /// a "What's new" section (e.g. from Remote Config / your own backend).
  final String? releaseNotes;

  @override
  State<CustomAppUpdateModalSheet> createState() =>
      _CustomAppUpdateModalSheetState();
}

class _CustomAppUpdateModalSheetState extends State<CustomAppUpdateModalSheet> {
  final _service = AppUpdateService.instance;

  bool checking = false;
  bool downloading = false;
  bool downloaded = false;
  double? progress; // null = indeterminate
  String? errorMessage;

  AppUpdateInfoAndroid? updateInfo;
  StreamSubscription<InstallStateAndroid>? _installSub;

  bool get canUpdate => _service.canUpdate(updateInfo);

  Future<void> checkUpdate() async {
    setState(() => checking = true);
    updateInfo = await _service.checkForUpdate();
    if (!mounted) return;
    setState(() => checking = false);
  }

  Future<void> _updateNow() async {
    final info = updateInfo;
    if (info == null) return;

    setState(() => errorMessage = null);

    final immediate =
        widget.updateType == AppUpdateType.immediate &&
        info.isImmediateUpdateAllowed;

    if (!immediate) {
      // Listen before starting so no progress event is missed.
      _installSub?.cancel();
      _installSub = _service.installStates.listen((state) {
        if (!mounted) return;
        final total = state.totalBytesToDownload;
        setState(() {
          progress = total > 0 ? state.bytesDownloaded / total : null;
        });
        if (state.status == InstallStatusAndroid.downloaded) {
          setState(() {
            downloading = false;
            downloaded = true;
          });
          _service.completeUpdate(); // installs and restarts the app
        }
      });
      setState(() => downloading = true);
    }

    final result = await _service.startUpdate(info, type: widget.updateType);
    if (!mounted) return;

    // Immediate flow: Play restarts the app on success, nothing else to do.
    if (result != UpdateResultAndroid.success) {
      _installSub?.cancel();
      setState(() {
        downloading = false;
        errorMessage = result == null
            ? "Update isn't available right now"
            : "Update was cancelled or failed. Please try again";
      });
    }
  }

  @override
  void initState() {
    if (widget.updateInfo != null) {
      updateInfo = widget.updateInfo;
    } else {
      // Defer so setState inside checkUpdate isn't called during init.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) checkUpdate();
      });
      checking = true;
    }
    super.initState();
  }

  @override
  void dispose() {
    _installSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notes = widget.releaseNotes?.trim() ?? "";

    return Container(
      constraints: BoxConstraints.tightFor(height: 300),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    spacing: 10,
                    children: [
                      SvgPicture.asset(
                        Assets.images.icon.googlePlay50,
                        width: 30,
                        height: 30,
                        semanticsLabel: 'Store',
                      ),
                      Text("Play Store"),
                    ],
                  ),
                ),
                CloseButton(
                  onPressed: downloading
                      ? null
                      : () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (checking) {
                    return LoadingStateWidget();
                  }
                  if (updateInfo == null) {
                    return FailedStateWidget(
                      message: "Couldn't check for updates. Try again",
                      onButtonPressed: checkUpdate,
                    );
                  }
                  return Column(
                    spacing: 10,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          canUpdate ? "Update available" : "You're up to date",
                        ).bold.sp17,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(_message()).bold.sp10,
                      ),
                      if (downloading || downloaded)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 6,
                          children: [
                            LinearProgressIndicator(value: progress),
                            Text(
                              downloaded
                                  ? "Installing..."
                                  : "Downloading update...",
                            ).sp10,
                          ],
                        ),
                      if (errorMessage != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            errorMessage!,
                            style: TextStyle(
                              fontSize: 11,
                              color: context.colorScheme.error,
                            ),
                          ),
                        ),
                      Expanded(
                        child: notes.isEmpty
                            ? const SizedBox.shrink()
                            : SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 4,
                                  children: [
                                    Text("What's new").bold,
                                    Text(notes, style: TextStyle(fontSize: 11)),
                                  ],
                                ),
                              ),
                      ),
                      Row(
                        spacing: 20,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: CButton(
                              minHeight: 36,
                              enable: !downloading,
                              backgroundColor: context.colorScheme.surface,
                              text: canUpdate ? "Update later" : "Close",
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          Expanded(
                            child: CButton(
                              minHeight: 36,
                              enable: canUpdate && !downloading && !downloaded,
                              text: "Update now",
                              onPressed: _updateNow,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _message() {
    if (!canUpdate) {
      return "You're running the latest version available on the Play Store.";
    }
    final days = updateInfo?.clientVersionStalenessDays;
    final age = (days != null && days > 0)
        ? " It has been available for $days day${days == 1 ? '' : 's'}."
        : "";
    return "A new version is available on the Play Store.$age Update to get the latest features.";
  }
}
