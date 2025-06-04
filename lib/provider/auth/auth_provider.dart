import 'package:flutter/material.dart';
import 'package:proyek2/data/api/api_services.dart';
import 'package:proyek2/service/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final ApiServices _apiServices = ApiServices();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> login(
      String phone, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _apiServices.login(phone, password);
      if (success) {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token') ?? '';
        final clientId = prefs.getInt('client_id') ?? 0;
        final kkId = prefs.getInt('kk_id') ?? 0;

        await GlobalNotificationService().startGlobalMonitoring();
        debugPrint("Login successful, global monitoring started");
        debugPrint('Token: $token');
        debugPrint('Client ID: $clientId');
        debugPrint('KK ID: $kkId');

        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Error starting global monitoring after login: $e");
      debugPrint('Login Error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to call during logout
  Future<void> onLogout() async {
    try {
      // Stop global monitoring
      GlobalNotificationService().stopGlobalMonitoring();

      // Clear stored data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('client_id');
      await prefs.remove('token');
      await prefs.remove('global_previous_statuses');

      debugPrint("Logout successful, global monitoring stopped");
      notifyListeners();
    } catch (e) {
      debugPrint("Error during logout cleanup: $e");
    }
  }

  Future<void> restartGlobalMonitoring() async {
    try {
      GlobalNotificationService().stopGlobalMonitoring();
      await Future.delayed(const Duration(seconds: 1));
      await GlobalNotificationService().startGlobalMonitoring();
      debugPrint("Global monitoring restarted");
    } catch (e) {
      debugPrint("Error restarting global monitoring: $e");
    }
  }

  String getMonitoringStatus() {
    return GlobalNotificationService().monitoringStatus;
  }
}
