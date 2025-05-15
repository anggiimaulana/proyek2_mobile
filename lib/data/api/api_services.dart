import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:proyek2/data/models/informasi_umum/agama_model.dart';
import 'package:proyek2/data/models/informasi_umum/hubungan_model.dart';
import 'package:proyek2/data/models/informasi_umum/jk_model.dart';
import 'package:proyek2/data/models/informasi_umum/kategori_pengajuan.dart';
import 'package:proyek2/data/models/informasi_umum/pekerjaan_model.dart';
import 'package:proyek2/data/models/informasi_umum/pendidikan_model.dart';
import 'package:proyek2/data/models/informasi_umum/penghasilan_model.dart';
import 'package:proyek2/data/models/informasi_umum/status_pengajuan.dart';
import 'package:proyek2/data/models/informasi_umum/status_perkawinan.dart';
import 'package:proyek2/data/models/pengajuan/pengajuan_surat_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyek2/data/models/pengguna/client/client_detail.dart';

class ApiServices {
  static const String baseUrl =
      "https://5eb4-103-148-130-255.ngrok-free.app/api";

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

  Future<void> preloadMasterData() async {
    final prefs = await SharedPreferences.getInstance();

    final jenisKelamin = await getJenisKelaminList();
    final hubungan = await getHubunganList();
    final agama = await getAgamaList();
    final pekerjaan = await getPekerjaanList();
    final pendidikan = await getPendidikanList();
    final penghasilan = await getPenghasilanList();
    final statusPerkawinan = await getStatusPerkawinanList();
    final statusPengajuan = await getStatusPengajuanList();
    final kategoriPengajuan = await getKategoriPengajuan();

    await prefs.setString('jk_list', jsonEncode(jenisKelamin.toJson()));
    await prefs.setString('hubungan_list', jsonEncode(hubungan.toJson()));
    await prefs.setString('agama_list', jsonEncode(agama.toJson()));
    await prefs.setString('pekerjaan_list', jsonEncode(pekerjaan.toJson()));
    await prefs.setString('pendidikan_list', jsonEncode(pendidikan.toJson()));
    await prefs.setString('penghasilan_list', jsonEncode(penghasilan.toJson()));
    await prefs.setString(
        'status_perkawinan_list', jsonEncode(statusPerkawinan.toJson()));
    await prefs.setString(
        'status_pengajuan_list', jsonEncode(statusPengajuan.toJson()));
    await prefs.setString(
        'kategori_pengajuan_list', jsonEncode(kategoriPengajuan.toJson()));
  }

  Future<T> fetchData<T>(
      String endpoint, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final url = '$baseUrl/$endpoint';
      _debugRequest('GET', url, null, {});
      final response = await http.get(Uri.parse(url));
      _debugResponse(response);

      if (response.statusCode == 200) {
        return fromJson(jsonDecode(response.body));
      } else {
        _handleHttpError(response);
        throw Exception("Gagal memuat data $endpoint.");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan: ${e.toString()}");
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

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

        // Verifikasi struktur respons
        if (kDebugMode) {
          print('Response structure check:');
          print('- Has token: ${data.containsKey('token')}');
          print('- Has client: ${data.containsKey('data')}');
          if (data.containsKey('data') && data['data'].containsKey('client')) {
            print(
                '- Client has id: ${data['data']['client'].containsKey('id')}');
            print(
                '- Client has name: ${data['data']['client'].containsKey('name')}');
          }
        }

        // Simpan token dan data client ke SharedPreferences
        if (data.containsKey('token')) {
          await prefs.setString('token', data['token']);
        } else {
          print("Warning: No token in response");
        }

        // Pastikan data client ada di dalam response
        if (data.containsKey('data') && data['data'].containsKey('client')) {
          final client = data['data']['client'];
          if (client.containsKey('id')) {
            await prefs.setInt('client_id', client['id']);
          }
          if (client.containsKey('name')) {
            await prefs.setString('name', client['name']);
          }
          if (client.containsKey('nomor_telepon')) {
            await prefs.setString('phone', client['nomor_telepon']);
          }
        } else {
          print("Warning: No client data in response");
        }

        return true;
      } else if (response.statusCode == 401) {
        print("Login failed: Invalid credentials");
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
      if (e is Exception) {
        rethrow;
      }
      throw Exception("Terjadi kesalahan: ${e.toString()}");
    }
  }

  Future<Agama> getAgamaList() =>
      fetchData("agama", (json) => Agama.fromJson(json));

  Future<Hubungan> getHubunganList() =>
      fetchData("hubungan", (json) => Hubungan.fromJson(json));

  Future<JenisKelamin> getJenisKelaminList() =>
      fetchData("jk", (json) => JenisKelamin.fromJson(json));

  Future<Pekerjaan> getPekerjaanList() =>
      fetchData("pekerjaan", (json) => Pekerjaan.fromJson(json));

  Future<KategoriPengajuan> getKategoriPengajuan() => fetchData(
      "kategori-pengajuan", (json) => KategoriPengajuan.fromJson(json));

  Future<Pendidikan> getPendidikanList() =>
      fetchData("pendidikan", (json) => Pendidikan.fromJson(json));

  Future<Penghasilan> getPenghasilanList() =>
      fetchData("penghasilan", (json) => Penghasilan.fromJson(json));

  Future<StatusPerkawinan> getStatusPerkawinanList() =>
      fetchData("status-perkawinan", (json) => StatusPerkawinan.fromJson(json));

  Future<StatusPengajuan> getStatusPengajuanList() =>
      fetchData("status-pengajuan", (json) => StatusPengajuan.fromJson(json));

  Future<Map<String, dynamic>> postPengajuanSKTMListrik({
    required String nik,
    required String namaLengkap,
    required String umur,
    required String alamat,
    required String namaPln,
    required int hubunganId,
    required int jenisKelaminId,
    required int agamaId,
    required int pekerjaanId,
    required int penghasilanId,
    required PlatformFile fileKK,
  }) async {
    try {
      final token = await _getToken();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/sktm-listrik'),
      );

      if (token == null) {
        throw Exception("Token not found.");
      }

      // Authorization
      request.headers['Authorization'] = 'Bearer $token';

      // Field input (11 total, TANPA client_id)
      request.fields.addAll({
        'nik': nik,
        'nama': namaLengkap,
        'umur': umur,
        'alamat': alamat,
        'nama_pln': namaPln,
        'hubungan': hubunganId.toString(),
        'jk': jenisKelaminId.toString(),
        'agama': agamaId.toString(),
        'pekerjaan': pekerjaanId.toString(),
        'penghasilan': penghasilanId.toString(),
      });

      // MIME type
      String? mimeType = lookupMimeType(fileKK.name);
      final extension = fileKK.name.split('.').last.toLowerCase();
      mimeType ??= {
            'jpg': 'image/jpeg',
            'jpeg': 'image/jpeg',
            'png': 'image/png',
            'pdf': 'application/pdf',
          }[extension] ??
          'application/octet-stream';

      // Tambah file KK
      if (fileKK.bytes != null && fileKK.bytes!.isNotEmpty) {
        final multipartFile = http.MultipartFile.fromBytes(
          'file_kk',
          fileKK.bytes!,
          filename: fileKK.name,
          contentType: MediaType.parse(mimeType),
        );
        request.files.add(multipartFile);
      } else {
        throw Exception("File KK kosong atau tidak valid.");
      }

      // Kirim request
      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 30));
      final streamed = await request.send();
      print('STATUS: ${streamed.statusCode}');
      final respBody = await streamed.stream.bytesToString();
      print('BODY: $respBody');

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception("Gagal: ${error['message'] ?? 'Unknown error'}");
      }
    } on TimeoutException {
      throw Exception("Timeout: Server tidak merespons.");
    } on SocketException {
      throw Exception("Tidak bisa konek ke server.");
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<Map<String, dynamic>> postPengajuanSKTMBeasiswa({
    required int hubunganId,
    required String namaAnak,
    required String tempatLahir,
    required String tanggalLahir,
    required int jenisKelaminId,
    required String suku,
    required int agamaId,
    required int pekerjaanAnakId,
    required String namaAyah,
    required String namaIbu,
    required int pekerjaanOrtuId,
    required String alamat,
    required PlatformFile fileKK,
  }) async {
    try {
      final token = await _getToken();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/sktm-beasiswa'),
      );

      if (token == null) throw Exception("Token tidak ditemukan.");

      // Authorization header
      request.headers['Authorization'] = 'Bearer $token';

      // Data field
      request.fields.addAll({
        'hubungan': hubunganId.toString(),
        'nama_anak': namaAnak,
        'tempat_lahir': tempatLahir,
        'tanggal_lahir': tanggalLahir,
        'jk': jenisKelaminId.toString(),
        'suku': suku,
        'agama': agamaId.toString(),
        'pekerjaan_anak': pekerjaanAnakId.toString(),
        'nama': namaAyah,
        'nama_ibu': namaIbu,
        'pekerjaan_ortu': pekerjaanOrtuId.toString(),
        'alamat': alamat,
      });

      // Handle file mime type
      String? mimeType = lookupMimeType(fileKK.name);
      final extension = fileKK.name.split('.').last.toLowerCase();
      mimeType ??= {
            'jpg': 'image/jpeg',
            'jpeg': 'image/jpeg',
            'png': 'image/png',
            'pdf': 'application/pdf',
          }[extension] ??
          'application/octet-stream';

      if (fileKK.bytes != null && fileKK.bytes!.isNotEmpty) {
        final multipartFile = http.MultipartFile.fromBytes(
          'file_kk',
          fileKK.bytes!,
          filename: fileKK.name,
          contentType: MediaType.parse(mimeType),
        );
        request.files.add(multipartFile);
      } else {
        throw Exception("File KK kosong atau tidak valid.");
      }

      // Kirim request
      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);

      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception("Gagal: ${error['message'] ?? 'Unknown error'}");
      }
    } on TimeoutException {
      throw Exception("Timeout: Server tidak merespons.");
    } on SocketException {
      throw Exception("Tidak bisa konek ke server.");
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  static Future<Map<String, dynamic>> postPengajuanSktmSekolah({
    required int hubunganId,
    required String namaOrtu,
    required String tempatLahirOrtu,
    required String tanggalLahirOrtu,
    required int agamaId,
    required int pekerjaanId,
    required String alamat,
    required String namaAnak,
    required String tempatLahirAnak,
    required String tanggalLahirAnak,
    required int jenisKelaminId,
    required String asalSekolah,
    required String kelas,
    required PlatformFile fileKK,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception("Token tidak ditemukan.");

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/sktm-sekolah'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      request.fields.addAll({
        'hubungan': hubunganId.toString(),
        'nama': namaOrtu,
        'tempat_lahir_ortu': tempatLahirOrtu,
        'tanggal_lahir_ortu': tanggalLahirOrtu,
        'agama': agamaId.toString(),
        'pekerjaan': pekerjaanId.toString(),
        'alamat': alamat,
        'nama_anak': namaAnak,
        'tempat_lahir': tempatLahirAnak,
        'tanggal_lahir': tanggalLahirAnak,
        'jk': jenisKelaminId.toString(),
        'asal_sekolah': asalSekolah,
        'kelas': kelas,
      });

      // Tambahkan file KK
      String? mimeType = lookupMimeType(fileKK.name);
      final ext = fileKK.name.split('.').last.toLowerCase();
      mimeType ??= {
            'jpg': 'image/jpeg',
            'jpeg': 'image/jpeg',
            'png': 'image/png',
            'pdf': 'application/pdf',
          }[ext] ??
          'application/octet-stream';

      if (fileKK.bytes == null || fileKK.bytes!.isEmpty) {
        throw Exception("File KK kosong atau tidak valid.");
      }

      final multipartFile = http.MultipartFile.fromBytes(
        'file_kk',
        fileKK.bytes!,
        filename: fileKK.name,
        contentType: MediaType.parse(mimeType),
      );

      request.files.add(multipartFile);

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception("Gagal: ${error['message'] ?? 'Unknown error'}");
      }
    } on TimeoutException {
      throw Exception("Timeout: Server tidak merespons.");
    } on SocketException {
      throw Exception("Tidak bisa konek ke server.");
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  static Future<Map<String, dynamic>> postPengajuanSkpot({
    required int hubunganId,
    required String nama,
    required String nik,
    required String tempatLahir,
    required String tanggalLahir,
    required int jenisKelaminId,
    required int agamaId,
    required String namaOrtu,
    required int pekerjaanId,
    required int penghasilanId,
    required String alamat,
    required PlatformFile fileKK,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception("Token tidak ditemukan.");

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/skpot'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      request.fields.addAll({
        'hubungan': hubunganId.toString(),
        'nama': nama,
        'nik': nik,
        'tempat_lahir': tempatLahir,
        'tanggal_lahir': tanggalLahir,
        'jk': jenisKelaminId.toString(),
        'agama': agamaId.toString(),
        'nama_ortu': namaOrtu,
        'pekerjaan': pekerjaanId.toString(),
        'penghasilan': penghasilanId.toString(),
        'alamat': alamat,
      });

      // Deteksi mime type dan siapkan file
      String? mimeType = lookupMimeType(fileKK.name);
      final ext = fileKK.name.split('.').last.toLowerCase();
      mimeType ??= {
            'jpg': 'image/jpeg',
            'jpeg': 'image/jpeg',
            'png': 'image/png',
            'pdf': 'application/pdf',
          }[ext] ??
          'application/octet-stream';

      if (fileKK.bytes == null || fileKK.bytes!.isEmpty) {
        throw Exception("File KK kosong atau tidak valid.");
      }

      final multipartFile = http.MultipartFile.fromBytes(
        'file_kk',
        fileKK.bytes!,
        filename: fileKK.name,
        contentType: MediaType.parse(mimeType),
      );

      request.files.add(multipartFile);

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception("Gagal: ${error['message'] ?? 'Unknown error'}");
      }
    } on TimeoutException {
      throw Exception("Timeout: Server tidak merespons.");
    } on SocketException {
      throw Exception("Tidak bisa konek ke server.");
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  static Future<Map<String, dynamic>> postPengajuanSkstatus({
    required int hubunganId,
    required String nama,
    required String tempatLahir,
    required String tanggalLahir,
    required int jenisKelaminId,
    required int agamaId,
    required int statusPerkawinanId,
    required int pekerjaanId,
    required String alamat,
    required PlatformFile fileKK,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception("Token tidak ditemukan.");

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/sks'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      // Fields yang dikirim
      request.fields.addAll({
        'hubungan': hubunganId.toString(),
        'nama': nama,
        'tempat_lahir': tempatLahir,
        'tanggal_lahir': tanggalLahir,
        'jk': jenisKelaminId.toString(),
        'agama': agamaId.toString(),
        'status_perkawinan': statusPerkawinanId.toString(),
        'pekerjaan': pekerjaanId.toString(),
        'alamat': alamat,
      });

      // Cek dan kirim file KK
      String? mimeType = lookupMimeType(fileKK.name);
      final ext = fileKK.name.split('.').last.toLowerCase();
      mimeType ??= {
            'jpg': 'image/jpeg',
            'jpeg': 'image/jpeg',
            'png': 'image/png',
            'pdf': 'application/pdf',
          }[ext] ??
          'application/octet-stream';

      if (fileKK.bytes == null || fileKK.bytes!.isEmpty) {
        throw Exception("File KK kosong atau tidak valid.");
      }

      final multipartFile = http.MultipartFile.fromBytes(
        'file_kk',
        fileKK.bytes!,
        filename: fileKK.name,
        contentType: MediaType.parse(mimeType),
      );

      request.files.add(multipartFile);

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception("Gagal: ${error['message'] ?? 'Unknown error'}");
      }
    } on TimeoutException {
      throw Exception("Timeout: Server tidak merespons.");
    } on SocketException {
      throw Exception("Tidak bisa konek ke server.");
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  static Future<Map<String, dynamic>> postPengajuanSkbm({
    required int hubunganId,
    required String nama,
    required String nik,
    required String tempatLahir,
    required String tanggalLahir,
    required int jenisKelaminId,
    required int agamaId,
    required int statusPerkawinanId,
    required int pekerjaanId,
    required String alamat,
    required PlatformFile fileKK,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception("Token tidak ditemukan.");

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/skbm'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      // Fields yang dikirim
      request.fields.addAll({
        'hubungan': hubunganId.toString(),
        'nik': nik,
        'nama': nama,
        'tempat_lahir': tempatLahir,
        'tanggal_lahir': tanggalLahir,
        'jk': jenisKelaminId.toString(),
        'agama': agamaId.toString(),
        'status_perkawinan': statusPerkawinanId.toString(),
        'pekerjaan': pekerjaanId.toString(),
        'alamat': alamat,
      });

      // Cek dan kirim file KK
      String? mimeType = lookupMimeType(fileKK.name);
      final ext = fileKK.name.split('.').last.toLowerCase();
      mimeType ??= {
            'jpg': 'image/jpeg',
            'jpeg': 'image/jpeg',
            'png': 'image/png',
            'pdf': 'application/pdf',
          }[ext] ??
          'application/octet-stream';

      if (fileKK.bytes == null || fileKK.bytes!.isEmpty) {
        throw Exception("File KK kosong atau tidak valid.");
      }

      final multipartFile = http.MultipartFile.fromBytes(
        'file_kk',
        fileKK.bytes!,
        filename: fileKK.name,
        contentType: MediaType.parse(mimeType),
      );

      request.files.add(multipartFile);

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception("Gagal: ${error['message'] ?? 'Unknown error'}");
      }
    } on TimeoutException {
      throw Exception("Timeout: Server tidak merespons.");
    } on SocketException {
      throw Exception("Tidak bisa konek ke server.");
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  static Future<Map<String, dynamic>> postPengajuanSkp({
    required int hubunganId,
    required String nama,
    required String nik,
    required String tempatLahir,
    required String tanggalLahir,
    required int jenisKelaminId,
    required int statusPerkawinanId,
    required int pekerjaanTerdahuluId,
    required int pekerjaanSekarangId,
    required String alamat,
    required PlatformFile fileKK,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception("Token tidak ditemukan.");

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/skp'), // Sesuaikan endpoint
      );

      request.headers['Authorization'] = 'Bearer $token';

      // Tambahkan data form
      request.fields.addAll({
        'hubungan': hubunganId.toString(),
        'nama': nama,
        'nik': nik,
        'tempat_lahir': tempatLahir,
        'tanggal_lahir': tanggalLahir, // Format: yyyy-MM-dd
        'jk': jenisKelaminId.toString(),
        'status_perkawinan': statusPerkawinanId.toString(),
        'pekerjaan_terdahulu': pekerjaanTerdahuluId.toString(),
        'pekerjaan_sekarang': pekerjaanSekarangId.toString(),
        'alamat': alamat,
      });

      // Handle upload file KK
      String? mimeType = lookupMimeType(fileKK.name);
      final ext = fileKK.name.split('.').last.toLowerCase();
      mimeType ??= {
            'jpg': 'image/jpeg',
            'jpeg': 'image/jpeg',
            'png': 'image/png',
            'pdf': 'application/pdf',
          }[ext] ??
          'application/octet-stream';

      if (fileKK.bytes == null || fileKK.bytes!.isEmpty) {
        throw Exception("File KK kosong atau tidak valid.");
      }

      final multipartFile = http.MultipartFile.fromBytes(
        'file_kk',
        fileKK.bytes!,
        filename: fileKK.name,
        contentType: MediaType.parse(mimeType),
      );

      request.files.add(multipartFile);

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception("Gagal: ${error['message'] ?? 'Unknown error'}");
      }
    } on TimeoutException {
      throw Exception("Timeout: Server tidak merespons.");
    } on SocketException {
      throw Exception("Tidak bisa konek ke server.");
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  static Future<Map<String, dynamic>> postPengajuanSku({
    required int hubunganId,
    required String nama,
    required String nik,
    required String tempatLahir,
    required String tanggalLahir, // Format: yyyy-MM-dd
    required int jenisKelaminId,
    required int statusPerkawinanId,
    required int pekerjaanId,
    required String alamat,
    required String namaUsaha,
    required PlatformFile fileKtp,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception("Token tidak ditemukan.");

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/sku'), // Ganti sesuai endpoint SKU kamu
      );

      request.headers['Authorization'] = 'Bearer $token';

      request.fields.addAll({
        'hubungan': hubunganId.toString(),
        'nama': nama,
        'nik': nik,
        'tempat_lahir': tempatLahir,
        'tanggal_lahir': tanggalLahir,
        'jk': jenisKelaminId.toString(),
        'status_perkawinan': statusPerkawinanId.toString(),
        'pekerjaan': pekerjaanId.toString(),
        'alamat': alamat,
        'nama_usaha': namaUsaha,
      });

      String? mimeType = lookupMimeType(fileKtp.name);
      final ext = fileKtp.name.split('.').last.toLowerCase();
      mimeType ??= {
            'jpg': 'image/jpeg',
            'jpeg': 'image/jpeg',
            'png': 'image/png',
            'pdf': 'application/pdf',
          }[ext] ??
          'application/octet-stream';

      if (fileKtp.bytes == null || fileKtp.bytes!.isEmpty) {
        throw Exception("File KTP kosong atau tidak valid.");
      }

      final multipartFile = http.MultipartFile.fromBytes(
        'file_ktp',
        fileKtp.bytes!,
        filename: fileKtp.name,
        contentType: MediaType.parse(mimeType),
      );

      request.files.add(multipartFile);

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception("Gagal: ${error['message'] ?? 'Unknown error'}");
      }
    } on TimeoutException {
      throw Exception("Timeout: Server tidak merespons.");
    } on SocketException {
      throw Exception("Tidak bisa konek ke server.");
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<List<PengajuanDetail>> getPengajuanByUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userId = prefs.getInt('client_id');

      if (token == null || userId == null) {
        throw Exception("User belum login atau token tidak ditemukan.");
      }

      final response = await http.get(
        Uri.parse('$baseUrl/pengajuan/user/$userId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      debugPrint("📡 [API] Status Code: ${response.statusCode}");
      debugPrint("📡 [API] Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final pengajuan = PengajuanSuratModel.fromJson(jsonBody);
        return pengajuan.data;
      } else if (response.statusCode == 401) {
        throw Exception("Akses ditolak. Silakan login kembali.");
      } else {
        final error = json.decode(response.body);
        throw Exception("Gagal: ${error['message'] ?? 'Tidak diketahui'}");
      }
    } on TimeoutException {
      throw Exception("Timeout: Server tidak merespons.");
    } on SocketException {
      throw Exception("Tidak bisa terhubung ke server.");
    } catch (e, stacktrace) {
      debugPrint("❌ ERROR: $e");
      debugPrint("❌ STACKTRACE: $stacktrace");
      throw Exception("Terjadi kesalahan: $e");
    }
  }
}
