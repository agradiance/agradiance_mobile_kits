import 'package:material_ui/material_ui.dart';

class AppMainNavigationService {
  final navigatorKey = GlobalKey<NavigatorState>();
  final rootScaffoldStateKey = GlobalKey<ScaffoldState>();

  static final AppMainNavigationService _internal =
      AppMainNavigationService._();
  static AppMainNavigationService get instance => _internal;

  AppMainNavigationService._();

  // factory AppMainNavigationService._() {
  //   return _internal;
  // }

  BuildContext? get context => instance.navigatorKey.currentState?.context;

  void openDrawer() {
    rootScaffoldStateKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    rootScaffoldStateKey.currentState?.closeDrawer();
  }
}
