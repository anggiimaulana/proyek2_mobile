import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:proyek2/data/api/api_services.dart';
import 'package:proyek2/data/models/informasi_umum/agama_model.dart';
import 'package:proyek2/data/models/informasi_umum/data_kk_hive_model.dart';
import 'package:proyek2/data/models/informasi_umum/hubungan_model.dart';
import 'package:proyek2/data/models/informasi_umum/jk_model.dart';
import 'package:proyek2/data/models/informasi_umum/pekerjaan_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SktmSekolahEditProvider extends ChangeNotifier {
  // Text Controllers
  final nikController = TextEditingController();
  final namaOrtuController = TextEditingController();
  final tempatLahirOrtuController = TextEditingController();
  final tanggalLahirOrtuController = TextEditingController();
  final alamatController = TextEditingController();
  final namaAnakController = TextEditingController();
  final tempatLahirAnakController = TextEditingController();
  final tanggalLahirAnakController = TextEditingController();
  final namaSekolahController = TextEditingController();
  final kelasAnakController = TextEditingController();
  final catatanController = TextEditingController();

  // Dropdown Selections
  int? selectedHubunganId;
  int? selectedKelaminId;
  int? selectedAgamaId;
  int? selectedPekerjaanId;
  int? selectedNikId;

  // Date Selections
  DateTime? selectedDateOrtu;
  DateTime? selectedDateAnak;

  // File Selections
  PlatformFile? selectedFile;
  String? selectedFileName;

  // State Variables
  final baseUrl = ApiServices.baseUrl;
  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
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

  void setSelectedAgamaId(int? value) {
    selectedAgamaId = value;
    notifyListeners();
  }

  void setSelectedPekerjaanId(int? value) {
    selectedPekerjaanId = value;
    notifyListeners();
  }

  void setSelectedNikId(int? value) {
    selectedNikId = value;
    notifyListeners();
  }

  Future<void> selectDateOrtu(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateOrtu ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != selectedDateOrtu) {
      selectedDateOrtu = picked;
      tanggalLahirOrtuController.text = DateFormat('yyyy-MM-dd').format(picked);
      notifyListeners();
    }
    
    if (tanggalLahirOrtuController.text.isEmpty) {
      throw Exception("Tanggal lahir belum diisi.");
    }
  }

  Future<void> selectDateAnak(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateAnak ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != selectedDateAnak) {
      selectedDateAnak = picked;
      tanggalLahirAnakController.text = DateFormat('yyyy-MM-dd').format(picked);
      notifyListeners();
    }
    
    if (tanggalLahirAnakController.text.isEmpty) {
      throw Exception("Tanggal lahir belum diisi.");
    }
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

  Future<Map<String, dynamic>?> fetchSktmSekolahById(String detailId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan');
      }
      
      final uri = Uri.parse('$baseUrl/sktm-sekolah/$detailId');
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

  void fillFormWithExistingData({
    required Map<String, dynamic> sktmData,
    required List<Datum> jkList,
    required List<PekerjaanData> pekerjaanList,
    required List<AgamaData> agamaList,
    required List<HubunganData> hubunganList,
    List<NikHive>? nikList,
  }) {
    try {
      // Fill text controllers
      namaOrtuController.text = sktmData['nama']?.toString().trim() ?? '';
      namaAnakController.text = sktmData['nama_anak']?.toString().trim() ?? '';
      tempatLahirAnakController.text = sktmData['tempat_lahir']?.toString().trim() ?? '';
      tempatLahirOrtuController.text = sktmData['tempat_lahir_ortu']?.toString().trim() ?? '';
      alamatController.text = sktmData['alamat']?.toString().trim() ?? '';
      namaSekolahController.text = sktmData['asal_sekolah']?.toString().trim() ?? '';
      kelasAnakController.text = sktmData['kelas']?.toString().trim() ?? '';
      catatanController.text = sktmData['catatan']?.toString().trim() ?? '';

      if (sktmData['nik'] != null) {
        nikController.text = sktmData['nik'].toString().trim();
      }

      // Set dates
      if (sktmData['tanggal_lahir'] != null) {
        try {
          final dateStr = sktmData['tanggal_lahir'].toString();
          final date = DateTime.parse(dateStr);
          selectedDateAnak = date;
          tanggalLahirAnakController.text = DateFormat('yyyy-MM-dd').format(date);
        } catch (e) {
          // Handle date parsing error
        }
      }

      if (sktmData['tanggal_lahir_ortu'] != null) {
        try {
          final dateStr = sktmData['tanggal_lahir_ortu'].toString();
          final date = DateTime.parse(dateStr);
          selectedDateOrtu = date;
          tanggalLahirOrtuController.text = DateFormat('yyyy-MM-dd').format(date);
        } catch (e) {
          // Handle date parsing error
        }
      }

      // Helper function to find ID by name
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

      // Map dropdown values
      selectedHubunganId = findIdByName(
        hubunganList,
        sktmData['hubungan']?.toString(),
        (item) => item.jenisHubungan,
        (item) => item.id,
      );

      selectedKelaminId = findIdByName(
        jkList,
        sktmData['jk']?.toString(),
        (item) => item.jenisKelamin,
        (item) => item.id,
      );

      selectedPekerjaanId = findIdByName(
        pekerjaanList,
        sktmData['pekerjaan']?.toString(),
        (item) => item.namaPekerjaan,
        (item) => item.id,
      );
      
      selectedAgamaId = findIdByName(
        agamaList,
        sktmData['agama']?.toString(),
        (item) => item.namaAgama,
        (item) => item.id,
      );

      // Handle NIK ID mapping
      final nikIdFromApi = extractId(sktmData['nik_id']);

      if (nikIdFromApi != null && nikList != null) {
        final foundById = nikList.where((nik) => nik.id == nikIdFromApi).toList();

        if (foundById.isNotEmpty) {
          selectedNikId = nikIdFromApi;
        } else {
          try {
            final nikItem = nikList.firstWhere(
              (nik) => nik.nomorNik == nikIdFromApi.toString(),
            );
            selectedNikId = nikItem.id;
          } catch (e) {
            if (sktmData['nik'] != null) {
              try {
                final nikFromResponse = sktmData['nik'].toString();
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
      // Handle form filling error
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<int> updateForm(BuildContext context, String detailId) async {
    setLoading(true);
    
    try {
      // Validation
      if (selectedNikId == null ||
          selectedHubunganId == null ||
          selectedKelaminId == null ||
          selectedAgamaId == null ||
          selectedPekerjaanId == null) {
        throw Exception("Mohon lengkapi semua data dropdown dengan benar.");
      }
      
      if (selectedFile == null || selectedFile!.bytes == null) {
        throw Exception("File KK belum dipilih.");
      }
      
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final kkId = prefs.getInt('kk_id');
      
      if (token == null || kkId == null) {
        throw Exception("Login ulang!");
      }

      final Map<String, String> data = {
        'hubungan': selectedHubunganId.toString(),
        'kk_id': kkId.toString(),
        'nik_id': selectedNikId.toString(),
        'nama': namaOrtuController.text,
        'tempat_lahir_ortu': tempatLahirOrtuController.text,
        'tanggal_lahir_ortu': tanggalLahirOrtuController.text,
        'agama': selectedAgamaId.toString(),
        'pekerjaan': selectedPekerjaanId.toString(),
        'alamat': alamatController.text,
        'nama_anak': namaAnakController.text,
        'tempat_lahir': tempatLahirAnakController.text,
        'tanggal_lahir': tanggalLahirAnakController.text,
        'jk': selectedKelaminId.toString(),
        'asal_sekolah': namaSekolahController.text,
        'kelas': kelasAnakController.text,
        if (catatanController.text.isNotEmpty) 'catatan': catatanController.text,
        '_method': 'PUT',
      };

      final uri = Uri.parse('$baseUrl/sktm-sekolah/$detailId');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields.addAll(data)
        ..files.add(http.MultipartFile.fromBytes(
          'file_kk',
          selectedFile!.bytes!,
          filename: selectedFile!.name,
        ));

      final streamed = await request.send().timeout(const Duration(seconds: 30));
      final status = streamed.statusCode;
      final body = await streamed.stream.bytesToString();

      if (status == 200 || status == 201) {
        return 1;
      } else {
        final error = jsonDecode(body);
        final msg = error['message'] ?? 'Unknown error';
        throw Exception('Gagal update: $msg (Status $status)');
      }
    } finally {
      setLoading(false);
    }
  }

  void resetForm() {
    nikController.clear();
    namaOrtuController.clear();
    tempatLahirOrtuController.clear();
    tanggalLahirOrtuController.clear();
    alamatController.clear();
    namaAnakController.clear();
    tempatLahirAnakController.clear();
    tanggalLahirAnakController.clear();
    namaSekolahController.clear();
    kelasAnakController.clear();
    catatanController.clear();
    
    selectedHubunganId = null;
    selectedKelaminId = null;
    selectedAgamaId = null;
    selectedPekerjaanId = null;
    selectedNikId = null;
    selectedFile = null;
    selectedFileName = null;
    selectedDateOrtu = null;
    selectedDateAnak = null;
    
    notifyListeners();
  }

  void disposeControllers() {
    nikController.dispose();
    namaOrtuController.dispose();
    tempatLahirOrtuController.dispose();
    tanggalLahirOrtuController.dispose();
    alamatController.dispose();
    namaAnakController.dispose();
    tempatLahirAnakController.dispose();
    tanggalLahirAnakController.dispose();
    namaSekolahController.dispose();
    kelasAnakController.dispose();
    catatanController.dispose();
  }
} 