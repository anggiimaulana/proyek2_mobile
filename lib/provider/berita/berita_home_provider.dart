// ===== SOLUSI 1: Modifikasi BeritaHomeProvider =====
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyek2/data/models/berita/berita_home_model.dart';
import 'package:proyek2/data/api/api_services.dart';

class BeritaHomeProvider with ChangeNotifier {
  static const String baseUrl = ApiServices.baseUrl;

  List<Datum> _beritaHomeList = [];
  bool _isLoading = false;
  String _errorMessage = '';
  bool _disposed =
      false; // Tambahkan flag untuk cek apakah provider sudah di-dispose

  List<Datum> get beritaHomeList => _beritaHomeList;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  // Method untuk safely notify listeners
  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  Future<void> fetchBeritaHome() async {
    if (_disposed) return; // Return early jika sudah disposed

    _isLoading = true;
    _errorMessage = '';
    _safeNotifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/berita/home/show'),
        headers: {'Content-Type': 'application/json'},
      );

      if (_disposed) return; // Check lagi setelah async operation

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final beritaHome = BeritaHome.fromJson(jsonData);
        if (!beritaHome.error) {
          _beritaHomeList = beritaHome.data;
        } else {
          _errorMessage = beritaHome.message;
        }
      } else {
        _errorMessage =
            'Gagal memuat berita Home. Status: ${response.statusCode}';
      }
    } catch (e) {
      if (_disposed) return; // Check sebelum set error
      _errorMessage = 'Terjadi kesalahan: $e';
    }

    if (_disposed) return; // Final check sebelum notify
    _isLoading = false;
    _safeNotifyListeners();
  }

  String getImageUrl(String imagePath) {
    // Debug print untuk cek URL gambar
    print('Original image path: $imagePath');

    // Jika imagePath sudah full URL (seperti dari response API kamu), return as is
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      print('Full URL detected: $imagePath');
      return imagePath;
    }

    // Jika imagePath relatif, gabung dengan base URL
    // Pastikan tidak ada double slash
    String cleanImagePath =
        imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    String fullUrl = '$baseUrl/$cleanImagePath';
    print('Constructed URL: $fullUrl');
    return fullUrl;
  }
}
