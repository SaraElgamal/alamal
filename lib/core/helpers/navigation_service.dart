import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext? get currentContext => navigatorKey.currentContext;

  static GoRouter get _router {
    final context = currentContext;
    if (context == null) {
      throw FlutterError('NavigationService: No context available. Make sure your app is wrapped with MaterialApp.router or CupertinoApp.router');
    }
    return GoRouter.of(context);
  }

  /// Navigate to a named route
  static void go(String location, {Object? extra}) {
    _router.go(location, extra: extra);
  }

  /// Push a new route onto the navigator
  static Future<T?> push<T extends Object?>(String location, {Object? extra}) async {
    return await _router.push<T?>(location, extra: extra);
  }

  /// Replace the current route with a new route
  static void replace(String location, {Object? extra}) {
    _router.replace(location, extra: extra);
  }

  /// Push a route and remove all previous routes
  static void pushAndRemoveUntil(String location, {Object? extra}) {
    _router.go(location, extra: extra);
  }

  /// Pop the current route from the navigator
  static void pop<T extends Object?>([T? result]) {
    if (_router.canPop()) {
      _router.pop(result);
    } else {
      _router.go('/');
    }
  }

  /// Check if the navigator can be popped
  static bool canPop() {
    return _router.canPop();
  }

  // --- MODIFICATION START ---
  // The methods below are changed to avoid the recursive error.

  /// Go back to the previous route that matches the given route pattern
  static void popUntil(String routePattern) {
    // We get the router instance once to avoid repeated lookups in the loop.
    final router = _router;
    while (router.canPop()) {
      // Get the current location safely inside the loop.
      final currentLocation = router.routerDelegate.currentConfiguration.last.matchedLocation;
      if (_matchesRoute(currentLocation, routePattern)) {
        break; // Stop if we've reached the target route
      }
      router.pop();
    }
  }

  /// Get the current route location safely
  static String get currentLocation {
    // This now accesses the router's state directly, avoiding recursion.
    return _router.routerDelegate.currentConfiguration.last.matchedLocation;
  }

  /// Check if the current route matches the given pattern
  static bool isCurrent(String routePattern) {
    // This now uses the safe 'currentLocation' getter.
    return _matchesRoute(currentLocation, routePattern);
  }

  // --- MODIFICATION END ---

  /// Helper method to match route patterns (no changes needed here)
  static bool _matchesRoute(String currentLocation, String pattern) {
    if (currentLocation == pattern) return true;

    final currentSegments = Uri.parse(currentLocation).pathSegments;
    final patternSegments = Uri.parse(pattern).pathSegments;

    if (currentSegments.length != patternSegments.length) return false;

    for (int i = 0; i < patternSegments.length; i++) {
      final patternSegment = patternSegments[i];
      final currentSegment = currentSegments[i];

      if (patternSegment.startsWith(':')) continue;

      if (patternSegment != currentSegment) return false;
    }

    return true;
  }
}
