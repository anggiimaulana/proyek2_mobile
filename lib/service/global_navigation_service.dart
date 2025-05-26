// services/global_navigation_service.dart
import 'package:flutter/material.dart';

class GlobalNavigationService {
  static final GlobalNavigationService _instance =
      GlobalNavigationService._internal();
  factory GlobalNavigationService() => _instance;
  GlobalNavigationService._internal();

  // Global navigator key
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // Navigate to specific route
  static Future<void> navigateTo(String routeName, {Object? arguments}) async {
    try {
      if (navigatorKey.currentState != null) {
        await navigatorKey.currentState!
            .pushNamed(routeName, arguments: arguments);
      } else {
        debugPrint("Navigator state is null, cannot navigate to $routeName");
      }
    } catch (e) {
      debugPrint("Error navigating to $routeName: $e");
    }
  }

  // Navigate and clear stack
  static Future<void> navigateAndClearStack(String routeName,
      {Object? arguments}) async {
    try {
      if (navigatorKey.currentState != null) {
        await navigatorKey.currentState!.pushNamedAndRemoveUntil(
          routeName,
          (route) => false,
          arguments: arguments,
        );
      } else {
        debugPrint("Navigator state is null, cannot navigate to $routeName");
      }
    } catch (e) {
      debugPrint("Error navigating and clearing stack to $routeName: $e");
    }
  }

  // Go back
  static void goBack() {
    try {
      if (navigatorKey.currentState != null &&
          navigatorKey.currentState!.canPop()) {
        navigatorKey.currentState!.pop();
      }
    } catch (e) {
      debugPrint("Error going back: $e");
    }
  }

  // Get current context
  static BuildContext? get currentContext => navigatorKey.currentContext;
}
