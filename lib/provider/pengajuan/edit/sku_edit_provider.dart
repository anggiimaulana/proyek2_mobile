import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:proyek2/data/api/api_services.dart';
import 'package:proyek2/data/models/informasi_umum/data_kk_hive_model.dart';
import 'package:proyek2/data/models/informasi_umum/hubungan_model.dart';
import 'package:proyek2/data/models/informasi_umum/jk_model.dart';
import 'package:proyek2/data/models/informasi_umum/pekerjaan_model.dart';
import 'package:proyek2/data/models/informasi_umum/status_perkawinan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SkuEditProvider extends ChangeNotifier {
  // Controllers
  final nikController = TextEditingController();
  final namaController = TextEditingController();
  final tempatLahirController = TextEditingController();
  final tanggalLahirController = TextEditingController();
  final alamatController = TextEditingController();
  final namaUsahaController = TextEditingController();
  final catatanController = TextEditingController();

  // Selected values
  int? selectedHubunganId;
  int? selectedKelaminId;
  int? selectedPekerjaanId;
  int? selectedStatusId;
  int? selectedNikIndex;
  int? selectedNikId;
  DateTime? selectedDate;
  PlatformFile? selectedFile;
  String? selectedFileName;

  final baseUrl = ApiServices.baseUrl;
  bool isLoading = false;
  List<NikHive> nikDataList = [];

  // Setters
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setNikDataList(List<NikHive> data) {
    nikDataList = data;
    notifyListeners();
  }

  void setSelectedHubunganId(int? value) {
    selectedHubunganId = value;
    notifyListeners();
  }

  void setSelectedKelaminId(int? value) {
    selectedKelaminId = value;
    notifyListeners();
  }

  void setSelectedPekerjaanId(int? value) {
    selectedPekerjaanId = value;
    notifyListeners();
  }

  void setSelectedStatusId(int? value) {
    selectedStatusId = value;
    notifyListeners();
  }

  void setSelectedNikId(int? value) {
    selectedNikId = value;
    notifyListeners();
  }

  // Method untuk mengatur NIK yang dipilih
  void setSelectedNik(int index, int id, NikHive anggota,
      {required List<Datum> jkList,
      required List<StatusPerkawinanData> statusList,
      required List<PekerjaanData> pekerjaanList}) {
    selectedNikIndex = index;
    selectedNikId = id;

    nikController.text = anggota.nomorNik;
    namaController.text = anggota.name;
    alamatController.text = anggota.alamat;
    tempatLahirController.text = anggota.tempatLahir;
    tanggalLahirController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(anggota.tanggalLahir));
    selectedHubunganId = anggota.hubungan;
    selectedKelaminId = anggota.jk;
    selectedPekerjaanId = anggota.pekerjaan;
    selectedStatusId = anggota.status;
    notifyListeners();
  }

  Future<void> pickKKFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;

      if (file.size > 100 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ukuran file tidak boleh lebih dari 100MB'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      selectedFile = file;
      selectedFileName = file.name;
      notifyListeners();
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      tanggalLahirController.text = DateFormat('yyyy-MM-dd').format(picked);
      notifyListeners();
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Method untuk mengambil data SKU berdasarkan detail_id
  Future<Map<String, dynamic>?> fetchSkuById(String detailId) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login ulang.');
      }

      final uri = Uri.parse('$baseUrl/sku/$detailId');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['data'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Helper method untuk extract ID
  int? extractId(dynamic data) {
    try {
      if (data == null) return null;
      if (data is int) return data;
      if (data is String) return int.tryParse(data);
      if (data is double) return data.toInt();
      if (data is Map && data.containsKey('id')) {
        return extractId(data['id']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Method untuk mengisi form dengan data yang sudah ada
  void fillFormWithExistingData({
    required Map<String, dynamic> skuData,
    required List<Datum> jkList,
    required List<PekerjaanData> pekerjaanList,
    required List<StatusPerkawinanData> statusList,
    required List<HubunganData> hubunganList,
    List<NikHive>? nikList,
  }) {
    try {
      // Fill text controllers
      namaController.text = skuData['nama']?.toString().trim() ?? '';
      tempatLahirController.text =
          skuData['tempat_lahir']?.toString().trim() ?? '';
      alamatController.text = skuData['alamat']?.toString().trim() ?? '';
      namaUsahaController.text = skuData['nama_usaha']?.toString().trim() ?? '';
      catatanController.text = skuData['catatan']?.toString().trim() ?? '';

      // Set NIK text
      if (skuData['nik'] != null) {
        nikController.text = skuData['nik'].toString().trim();
      }

      // Set tanggal lahir
      if (skuData['tanggal_lahir'] != null) {
        try {
          final dateStr = skuData['tanggal_lahir'].toString();
          final date = DateTime.parse(dateStr);
          selectedDate = date;
          tanggalLahirController.text = DateFormat('yyyy-MM-dd').format(date);
        } catch (e) {
          // Handle date parsing error silently
        }
      }

      // Helper function untuk find ID berdasarkan nama
      int? findIdByName<T>(List<T> list, String? targetName,
          String Function(T) getName, int Function(T) getId) {
        if (targetName == null || targetName.isEmpty) return null;

        try {
          final targetLower = targetName.toLowerCase().trim();
          final item = list.firstWhere(
            (element) => getName(element).toLowerCase().trim() == targetLower,
          );
          return getId(item);
        } catch (e) {
          // Try partial match
          try {
            final targetLower = targetName.toLowerCase().trim();
            final item = list.firstWhere(
              (element) =>
                  getName(element).toLowerCase().contains(targetLower) ||
                  targetLower.contains(getName(element).toLowerCase()),
            );
            return getId(item);
          } catch (e2) {
            return null;
          }
        }
      }

      // Map nama ke ID untuk masing-masing dropdown
      selectedHubunganId = findIdByName(
        hubunganList,
        skuData['hubungan']?.toString(),
        (item) => item.jenisHubungan,
        (item) => item.id,
      );

      selectedKelaminId = findIdByName(
        jkList,
        skuData['jk']?.toString(),
        (item) => item.jenisKelamin,
        (item) => item.id,
      );

      selectedPekerjaanId = findIdByName(
        pekerjaanList,
        skuData['pekerjaan']?.toString(),
        (item) => item.namaPekerjaan,
        (item) => item.id,
      );

      selectedStatusId = findIdByName(
        statusList,
        skuData['status_perkawinan']?.toString(),
        (item) => item.statusPerkawinan,
        (item) => item.id,
      );

      // NIK ID mapping
      final nikIdFromApi = extractId(skuData['nik_id']);
      if (nikIdFromApi != null && nikList != null) {
        final foundById =
            nikList.where((nik) => nik.id == nikIdFromApi).toList();

        if (foundById.isNotEmpty) {
          selectedNikId = nikIdFromApi;
        } else {
          try {
            final nikItem = nikList.firstWhere(
              (nik) => nik.nomorNik == nikIdFromApi.toString(),
            );
            selectedNikId = nikItem.id;
          } catch (e) {
            if (skuData['nik'] != null) {
              try {
                final nikFromResponse = skuData['nik'].toString();
                final nikItem = nikList.firstWhere(
                  (nik) => nik.nomorNik == nikFromResponse,
                );
                selectedNikId = nikItem.id;
              } catch (e2) {
                selectedNikId = null;
              }
            } else {
              selectedNikId = null;
            }
          }
        }
      } else {
        selectedNikId = nikIdFromApi;
      }

      notifyListeners();
    } catch (e) {
      // Handle error silently or show user-friendly message
    }
  }

  // UPDATE form submission
  Future<int> updateForm(BuildContext context, String detailId) async {
    setLoading(true);

    try {
      // Validation
      List<String> missingFields = [];

      if (selectedHubunganId == null)
        missingFields.add('Status dalam Keluarga');
      if (selectedKelaminId == null) missingFields.add('Jenis Kelamin');
      if (selectedPekerjaanId == null) missingFields.add('Pekerjaan');
      if (selectedStatusId == null) missingFields.add('Status Perkawinan');
      if (selectedNikId == null) missingFields.add('NIK');
      if (namaController.text.trim().isEmpty) missingFields.add('Nama Lengkap');
      if (tempatLahirController.text.trim().isEmpty)
        missingFields.add('Tempat Lahir');
      if (tanggalLahirController.text.trim().isEmpty)
        missingFields.add('Tanggal Lahir');
      if (alamatController.text.trim().isEmpty) missingFields.add('Alamat');
      if (namaUsahaController.text.trim().isEmpty)
        missingFields.add('Nama Usaha');

      if (missingFields.isNotEmpty) {
        throw Exception("Field yang belum diisi: ${missingFields.join(', ')}");
      }

      if (selectedFile == null || selectedFile!.bytes == null) {
        throw Exception("File KTP belum dipilih atau tidak valid.");
      }

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('client_id')?.toString();
      final kkId = prefs.getInt('kk_id');

      if (userId == null) throw Exception('User belum login');
      if (kkId == null) throw Exception('KK ID tidak ditemukan');

      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login ulang.');
      }

      final Map<String, String> data = {
        'hubungan': selectedHubunganId?.toString() ?? '',
        'kk_id': kkId.toString(),
        'nik_id': selectedNikId?.toString() ?? '',
        'nama': namaController.text.trim(),
        'tempat_lahir': tempatLahirController.text.trim(),
        'tanggal_lahir': tanggalLahirController.text.trim(),
        'jk': selectedKelaminId?.toString() ?? '',
        'pekerjaan': selectedPekerjaanId?.toString() ?? '',
        'status_perkawinan': selectedStatusId?.toString() ?? '',
        'nama_usaha': namaUsahaController.text.trim(),
        'alamat': alamatController.text.trim(),
      };

      final uri = Uri.parse('$baseUrl/sku/$detailId');
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.fields['_method'] = 'PUT';
      request.fields.addAll(data);

      request.files.add(http.MultipartFile.fromBytes(
        'file_ktp',
        selectedFile!.bytes!,
        filename: selectedFile!.name,
      ));

      final streamed =
          await request.send().timeout(const Duration(seconds: 30));
      final status = streamed.statusCode;
      final body = await streamed.stream.bytesToString();

      if (status == 200 || status == 201) {
        final json = jsonDecode(body);
        return 1;
      } else {
        try {
          final errorJson = jsonDecode(body);
          final message = errorJson['message'] ?? 'Unknown error';
          final errors = errorJson['data'] ?? errorJson['errors'] ?? {};
          throw Exception('$message - Details: $errors');
        } catch (parseError) {
          throw Exception('HTTP $status: $body');
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  void resetForm() {
    namaController.clear();
    nikController.clear();
    tempatLahirController.clear();
    tanggalLahirController.clear();
    alamatController.clear();
    namaUsahaController.clear();
    catatanController.clear();
    selectedHubunganId = null;
    selectedKelaminId = null;
    selectedPekerjaanId = null;
    selectedStatusId = null;
    selectedFile = null;
    selectedFileName = null;
    selectedNikIndex = null;
    selectedNikId = null;
    selectedDate = null;
    notifyListeners();
  }

  @override
  void dispose() {
    nikController.dispose();
    namaController.dispose();
    tempatLahirController.dispose();
    tanggalLahirController.dispose();
    alamatController.dispose();
    namaUsahaController.dispose();
    catatanController.dispose();
    super.dispose();
  }
}