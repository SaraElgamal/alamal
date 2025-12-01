import 'package:flutter/material.dart';

class RouteObserverService extends NavigatorObserver {
  static final RouteObserverService _instance = RouteObserverService._internal();
  final List<NavigatorObserver> _navigatorObservers = [];

  factory RouteObserverService() {
    return _instance;
  }

  RouteObserverService._internal();

  void addObserver(NavigatorObserver observer) {
    if (!_navigatorObservers.contains(observer)) {
      _navigatorObservers.add(observer);
    }
  }

  void removeObserver(NavigatorObserver observer) {
    _navigatorObservers.remove(observer);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    for (final observer in _navigatorObservers) {
      observer.didPush(route, previousRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    for (final observer in _navigatorObservers) {
      observer.didPop(route, previousRoute);
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    for (final observer in _navigatorObservers) {
      observer.didRemove(route, previousRoute);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    for (final observer in _navigatorObservers) {
      observer.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    }
  }

  @override
  void didStartUserGesture(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    for (final observer in _navigatorObservers) {
      observer.didStartUserGesture(route, previousRoute);
    }
  }

  @override
  void didStopUserGesture() {
    for (final observer in _navigatorObservers) {
      observer.didStopUserGesture();
    }
  }
}
