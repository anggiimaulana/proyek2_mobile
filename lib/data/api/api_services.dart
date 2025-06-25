import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:proyek2/data/models/informasi_umum/kartu_keluarga_detail.dart';
import 'package:proyek2/data/models/pengaduan/api_response.dart';
import 'package:proyek2/data/models/pengaduan/pagination.dart';
import 'package:proyek2/data/models/pengaduan/pengaduan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyek2/data/models/client/client_detail.dart';

class ApiServices {
  static const String baseUrl = "http://srv847399.hstgr.cloud/api";

  static const String baseUrl2 = "http://srv847399.hstgr.cloud";

  static const String urlBansos = "http://srv847399.hstgr.cloud/flutter_api/";

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken(); // sekarang ini valid
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<ApiResponse<PaginatedData<Pengaduan>>> getPengaduanByUser(
      int userId,
      {int page = 1}) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/pengaduan/$userId?page=$page'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return ApiResponse.fromJson(
          jsonResponse,
          (data) =>
              PaginatedData.fromJson(data, (item) => Pengaduan.fromJson(item)),
        );
      } else {
        throw Exception('Failed to load pengaduan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> apiLogout(String token) async {
    final url = Uri.parse('$baseUrl/client/logout');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['error'] == false;
    } else {
      return false;
    }
  }

  Future<KartuKeluargaDetail?> fetchKartuKeluargaDetail(int kkId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/kk/$kkId'));

      // Log response mentah untuk debug
      debugPrint('📋 Response mentah: ${response.body}');

      if (response.statusCode == 200) {
        // Cek format response
        final String responseBody = response.body;

        // Debug response type dan content
        debugPrint('📋 Response type: ${responseBody.runtimeType}');
        debugPrint('📋 Response content: $responseBody');

        try {
          final decoded = jsonDecode(responseBody);
          debugPrint('📋 Decoded JSON type: ${decoded.runtimeType}');
          debugPrint('📋 Decoded JSON: $decoded');

          return KartuKeluargaDetail.fromJson(decoded);
        } catch (jsonError) {
          debugPrint('Error parsing JSON: $jsonError');
          return null;
        }
      } else {
        debugPrint('Gagal fetch KK: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint("Terjadi error saat fetch KK: $e");
      return null;
    }
  }

  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  // Get user ID from SharedPreferences
  Future<String?> getUserIdFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final clientId = prefs.getInt('client_id');
    return clientId?.toString();
  }

  void _debugRequest(
      String method, String url, dynamic body, Map<String, String> headers) {
    _logger.d('📤 REQUEST: $method $url');
    _logger.d('📤 HEADERS: $headers');
    _logger.d('📤 BODY: $body');
  }

  void _debugResponse(http.Response response) {
    _logger.d('📥 RESPONSE [${response.statusCode}]: ${response.body}');

    // Log additional details if error
    if (response.statusCode >= 400) {
      _logger.e('📥 ERROR RESPONSE [${response.statusCode}]: ${response.body}');

      try {
        final errorData = jsonDecode(response.body);
        _logger.e('📥 ERROR DATA: $errorData');
      } catch (e) {
        _logger.e('📥 Could not parse error response: $e');
      }
    }
  }

  void _handleHttpError(http.Response response) {
    if (response.statusCode == 401) {
      throw Exception("Tidak terotentikasi. Silakan login kembali.");
    } else if (response.statusCode == 403) {
      throw Exception("Tidak memiliki akses.");
    } else if (response.statusCode == 404) {
      throw Exception("Data tidak ditemukan.");
    } else if (response.statusCode >= 500) {
      throw Exception("Terjadi kesalahan pada server.");
    } else {
      try {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? "Terjadi kesalahan.");
      } catch (e) {
        throw Exception("Terjadi kesalahan: ${response.reasonPhrase}");
      }
    }
  }

  Future<ClientDetail> getDetailUser(int id) async {
    try {
      final token = await _getToken();
      final headers = token != null ? {'Authorization': 'Bearer $token'} : null;

      _debugRequest('GET', "$baseUrl/user/$id", null, headers ?? {});

      final response = await http
          .get(
            Uri.parse("$baseUrl/user/$id"),
            headers: headers,
          )
          .timeout(const Duration(seconds: 15));

      _debugResponse(response);

      if (response.statusCode == 200) {
        return ClientDetail.fromJson(jsonDecode(response.body));
      } else {
        _handleHttpError(response);
        throw Exception("Gagal mendapatkan data user.");
      }
    } on SocketException {
      throw Exception(
          "Tidak dapat terhubung ke server. Periksa koneksi internet Anda.");
    } on FormatException {
      throw Exception("Format data tidak valid.");
    } on http.ClientException {
      throw Exception("Gagal melakukan request ke server.");
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception("Terjadi kesalahan: ${e.toString()}");
    }
  }

  Future<bool> login(String phone, String password) async {
    try {
      final headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
      };
      final body = jsonEncode({
        'nomor_telepon': phone,
        'password': password,
      });

      _debugRequest('POST', '$baseUrl/client/login', body, headers);

      final response = await http
          .post(Uri.parse('$baseUrl/client/login'),
              headers: headers, body: body)
          .timeout(const Duration(seconds: 12));

      _debugResponse(response);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();

        // Debug struktur respons
        if (kDebugMode) {
          print('Response received: $data');
        }

        // Simpan token
        if (data.containsKey('token')) {
          await prefs.setString('token', data['token']);
        } else {
          print("Warning: Token tidak ditemukan di response.");
        }

        // Simpan client_id
        if (data.containsKey('client_id')) {
          await prefs.setInt('client_id', data['client_id']);
        }

        // Simpan kk_id jika ada
        if (data.containsKey('kk_id')) {
          await prefs.setInt('kk_id', data['kk_id']);
        }

        return true;
      } else if (response.statusCode == 401) {
        print("Login gagal: Nomor telepon atau password salah.");
        return false;
      } else {
        _handleHttpError(response);
        return false;
      }
    } on SocketException {
      print("Network error: Socket exception");
      throw Exception(
          "Tidak dapat terhubung ke server. Periksa koneksi internet Anda.");
    } on FormatException {
      print("Format error: Invalid JSON");
      throw Exception("Format data tidak valid.");
    } on http.ClientException catch (e) {
      print("HTTP client error: $e");
      throw Exception("Gagal melakukan request ke server.");
    } catch (e) {
      print("Login error: ${e.toString()}");
      throw Exception("Terjadi kesalahan: ${e.toString()}");
    }
  }
}
