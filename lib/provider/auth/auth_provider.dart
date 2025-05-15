import 'package:flutter/material.dart';
import 'package:proyek2/data/api/api_services.dart';
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
        // Preload data biar lebih cepet saat load main screen
        await _apiServices.preloadMasterData();

        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token') ?? '';
        final clientId = prefs.getInt('client_id') ?? 0;

        debugPrint('Token: $token');
        debugPrint('Client ID: $clientId');

        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Login Error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
