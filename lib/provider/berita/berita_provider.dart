import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyek2/data/api/api_services.dart';
import 'dart:convert';
import 'package:proyek2/data/models/berita/berita_model.dart';
import 'package:proyek2/data/models/berita/berita_detail_model.dart';

class BeritaProvider with ChangeNotifier {
  // Base URL API - sesuaikan dengan URL API kamu
  static const String baseUrl = ApiServices.baseUrl;

  // State variables
  List<Datum> _beritaList = [];
  BeritaDetailModel? _beritaDetail;
  bool _isLoading = false;
  bool _isLoadingDetail = false;
  bool _isLoadingMore = false;
  String _errorMessage = '';

  // Pagination variables
  int _currentPage = 1;
  int _perPage = 10;
  bool _hasMoreData = true;

  // Disposed flag for safe notifyListeners
  bool _disposed = false;

  // Getters
  List<Datum> get beritaList => _beritaList;
  BeritaDetailModel? get beritaDetail => _beritaDetail;
  bool get isLoading => _isLoading;
  bool get isLoadingDetail => _isLoadingDetail;
  bool get isLoadingMore => _isLoadingMore;
  String get errorMessage => _errorMessage;
  bool get hasMoreData => _hasMoreData;
  int get currentPage => _currentPage;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  // Helper: only notify if not disposed
  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  // Fetch daftar berita (untuk pertama kali atau refresh)
  Future<void> fetchBerita({bool isRefresh = false}) async {
    if (_disposed) return;
    if (isRefresh) {
      _currentPage = 1;
      _hasMoreData = true;
      _beritaList.clear();
    }

    _isLoading = true;
    _errorMessage = '';
    _safeNotifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/berita?page=$_currentPage&per_page=$_perPage'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (_disposed) return;

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final beritaModel = BeritaModel.fromJson(jsonData);

        if (!beritaModel.error) {
          if (isRefresh) {
            _beritaList = beritaModel.data;
          } else {
            _beritaList.addAll(beritaModel.data);
          }
          // Check if there's more data
          _hasMoreData = beritaModel.data.length == _perPage;
          _errorMessage = '';
        } else {
          _errorMessage = beritaModel.message;
        }
      } else {
        _errorMessage = 'Gagal memuat berita. Status: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
      print('Error fetching berita: $e');
    }

    _isLoading = false;
    _safeNotifyListeners();
  }

  // Load more berita (pagination)
  Future<void> loadMoreBerita() async {
    if (_disposed) return;
    if (_isLoadingMore || !_hasMoreData) return;

    _isLoadingMore = true;
    _safeNotifyListeners();

    try {
      _currentPage++;
      final response = await http.get(
        Uri.parse('$baseUrl/berita?page=$_currentPage&per_page=$_perPage'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (_disposed) return;

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final beritaModel = BeritaModel.fromJson(jsonData);

        if (!beritaModel.error) {
          _beritaList.addAll(beritaModel.data);
          // Check if there's more data
          _hasMoreData = beritaModel.data.length == _perPage;
          _errorMessage = '';
        } else {
          _errorMessage = beritaModel.message;
          _currentPage--; // Rollback page if error
        }
      } else {
        _errorMessage =
            'Gagal memuat lebih banyak berita. Status: ${response.statusCode}';
        _currentPage--; // Rollback page if error
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
      _currentPage--; // Rollback page if error
      print('Error loading more berita: $e');
    }

    _isLoadingMore = false;
    _safeNotifyListeners();
  }

  // Fetch detail berita berdasarkan ID
  Future<void> fetchBeritaDetail(int id) async {
    if (_disposed) return;
    _isLoadingDetail = true;
    _errorMessage = '';
    _safeNotifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/berita/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (_disposed) return;

      print('Detail response status: ${response.statusCode}');
      print('Detail response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final beritaDetailModel = BeritaDetailModel.fromJson(jsonData);

        if (!beritaDetailModel.error) {
          _beritaDetail = beritaDetailModel;
          _errorMessage = '';
        } else {
          _errorMessage = beritaDetailModel.message;
        }
      } else {
        _errorMessage =
            'Gagal memuat detail berita. Status: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
      print('Error fetching berita detail: $e');
    }

    _isLoadingDetail = false;
    _safeNotifyListeners();
  }

  // Clear berita detail ketika keluar dari halaman detail
  void clearBeritaDetail({bool notify = true}) {
    _beritaDetail = null;
    if (notify) _safeNotifyListeners();
  }

  // Reset pagination
  void resetPagination() {
    if (_disposed) return;
    _currentPage = 1;
    _hasMoreData = true;
    _beritaList.clear();
    _safeNotifyListeners();
  }

  // Helper function untuk format tanggal
  String formatDate(DateTime date) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // Helper function untuk debug image URL - PERBAIKAN
  String getImageUrl(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }
    String cleanImagePath =
        imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    String fullUrl = '$baseUrl/$cleanImagePath';
    return fullUrl;
  }

  // ALTERNATIF: Jika masih bermasalah, gunakan fungsi ini
  String getImageUrlAlternative(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }
    String constructedUrl;
    if (imagePath.startsWith('/')) {
      constructedUrl =
          '${baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl}$imagePath';
    } else {
      constructedUrl =
          '${baseUrl.endsWith('/') ? baseUrl : '$baseUrl/'}$imagePath';
    }
    return constructedUrl;
  }
}
