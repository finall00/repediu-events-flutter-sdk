import 'package:flutter/widgets.dart';

import 'repediu.dart';

/// Calls [Repediu.screen] for every named [PageRoute] that is pushed, replaced or returned to.
///
/// Add it to `navigatorObservers` of `MaterialApp` or `CupertinoApp`. Routes without a name are not tracked.
class RepediuNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => _trackScreen(route);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PageRoute) _trackScreen(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) => _trackScreen(newRoute);

  void _trackScreen(Route<dynamic>? route) {
    final name = route?.settings.name;
    if (route is PageRoute && name != null) Repediu.screen(name);
  }
}
