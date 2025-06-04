import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyek2/data/api/api_services.dart';
import 'package:proyek2/data/models/pengajuan/pengajuan_detail_model.dart';

class TrackingSuratProvider with ChangeNotifier {
  final String _baseUrl = ApiServices.baseUrl;

  PengajuanDetailModel? _pengajuanData;
  bool _isLoading = false;
  String? _errorMessage;

  PengajuanDetailModel? get pengajuanData => _pengajuanData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Mengambil data pengajuan berdasarkan ID user
  Future<void> fetchPengajuan(int idUser) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = '$_baseUrl/pengajuan/user/$idUser';
      debugPrint("Fetching from URL: $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      debugPrint("Response status code: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if data is empty or null
        if (data == null ||
            data['data'] == null ||
            (data['data'] is List && data['data'].isEmpty)) {
          debugPrint("No data available from API");
          _pengajuanData = null;
          _errorMessage = null; 
        } else {
          try {
            _pengajuanData = PengajuanDetailModel.fromJson(data);
            debugPrint("Loaded ${_pengajuanData?.data.length ?? 0} items");
          } catch (parseError) {
            debugPrint("Error parsing data: $parseError");
            _errorMessage = 'Error parsing data: ${parseError.toString()}';
            _pengajuanData = null;
          }
        }
      } else if (response.statusCode == 404) {
        // Handle 404
        debugPrint("No pengajuan found for user $idUser");
        _pengajuanData = null;
        _errorMessage = null;
      } else {
        _errorMessage = 'Server error: ${response.statusCode}';
        debugPrint("Error ${response.statusCode}: ${response.body}");
        _pengajuanData = null;
      }
    } catch (e) {
      _errorMessage = 'Connection error: ${e.toString()}';
      debugPrint("Exception in fetchPengajuan: $e");
      _pengajuanData = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Memulai proses fetch berdasarkan ID user dari SharedPreferences
  Future<void> startFetchingFromPrefs() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final idUser = prefs.getInt('client_id');
      debugPrint("client_id from prefs: $idUser");

      if (idUser != null) {
        await fetchPengajuan(idUser);
      } else {
        _errorMessage = 'Client ID tidak ditemukan. Silakan login ulang.';
        debugPrint("client_id not found in prefs");
        _pengajuanData = null;
      }
    } catch (e) {
      _errorMessage = 'Gagal memuat data: ${e.toString()}';
      debugPrint("Exception in startFetchingFromPrefs: $e");
      _pengajuanData = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Refresh data pengajuan (misalnya saat pull-to-refresh)
  Future<void> refreshData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final idUser = prefs.getInt('client_id');

      if (idUser != null) {
        await fetchPengajuan(idUser);
      } else {
        _errorMessage = 'Client ID tidak ditemukan. Silakan login ulang.';
        _pengajuanData = null;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Gagal refresh data: ${e.toString()}';
      debugPrint("Exception in refreshData: $e");
      _pengajuanData = null;
      notifyListeners();
    }
  }

  /// Delete pengajuan by ID
  Future<bool> deletePengajuan(String id) async {
    try {
      final url = '$_baseUrl/pengajuan/$id';
      debugPrint('Attempting to delete pengajuan with URL: $url');
      debugPrint('Pengajuan ID: $id');

      // Get token from SharedPreferences - REQUIRED
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        debugPrint('Token not found! Cannot delete pengajuan');
        return false;
      }

      debugPrint('Token found, length: ${token.length}');
      // Don't print full token for security, just first few chars
      debugPrint(
          'Token starts with: ${token.substring(0, token.length > 10 ? 10 : token.length)}...');

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      };

      debugPrint('Request headers: ${headers.keys.join(', ')}');

      final response = await http
          .delete(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(const Duration(seconds: 15));

      debugPrint('Delete response status: ${response.statusCode}');
      debugPrint('Delete response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Success - remove from local data
        if (_pengajuanData != null && _pengajuanData!.data.isNotEmpty) {
          _pengajuanData!.data.removeWhere((item) => item.id.toString() == id);
          notifyListeners();
        }
        debugPrint('Pengajuan deleted successfully');
        return true;
      } else if (response.statusCode == 401) {
        debugPrint('Unauthorized (401) - token might be invalid or expired');
        return false;
      } else if (response.statusCode == 403) {
        debugPrint(
            'Access forbidden (403) - user might not have permission to delete this pengajuan');
        return false;
      } else if (response.statusCode == 404) {
        debugPrint('Pengajuan not found (404) - might already be deleted');
        // Still remove from local data and return success
        if (_pengajuanData != null && _pengajuanData!.data.isNotEmpty) {
          _pengajuanData!.data.removeWhere((item) => item.id.toString() == id);
          notifyListeners();
        }
        return true;
      } else if (response.statusCode == 422) {
        debugPrint(
            'Validation error (422) - pengajuan might be in a state that cannot be deleted');
        try {
          final errorData = json.decode(response.body);
          debugPrint('Validation error details: $errorData');
        } catch (e) {
          debugPrint('Could not parse validation error response');
        }
        return false;
      } else if (response.statusCode == 500) {
        debugPrint('Server error (500) - backend issue');
        try {
          final errorData = json.decode(response.body);
          debugPrint('Server error details: $errorData');
        } catch (e) {
          debugPrint('Could not parse server error response');
        }
        return false;
      } else {
        debugPrint(
            'Unexpected error deleting pengajuan: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Exception when deleting pengajuan: $e');
      return false;
    }
  }

  /// Verifikasi isi SharedPreferences (debugging purpose)
  Future<void> verifySharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    debugPrint("All SharedPreferences keys: $keys");

    final clientId = prefs.getInt('client_id');
    debugPrint("client_id value: $clientId");

    final token = prefs.getString('token');
    debugPrint("token available: ${token != null}");
    if (token != null) {
      debugPrint("token length: ${token.length}");
      debugPrint(
          "token starts with: ${token.substring(0, token.length > 10 ? 10 : token.length)}...");
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }

  /// Clear all data (useful for logout)
  void clearData() {
    _pengajuanData = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}

/// Fungsi pembantu: mencari nilai minimum
int min(int a, int b) => a < b ? a : b;
