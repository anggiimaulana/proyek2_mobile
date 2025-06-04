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

class SktmBeasiswaEditProvider extends ChangeNotifier {
  final baseUrl = ApiServices.baseUrl;

  // Text Controllers
  final nikController = TextEditingController();
  final tempatLahirController = TextEditingController();
  final sukuController = TextEditingController();
  final namaAnakController = TextEditingController();
  final namaAyahController = TextEditingController();
  final namaIbuController = TextEditingController();
  final alamatController = TextEditingController();
  final tanggalLahirController = TextEditingController();
  final catatanController = TextEditingController();

  // Selected Values
  int? selectedHubunganId;
  int? selectedKelaminId;
  int? selectedAgamaId;
  int? selectedPekerjaanOrtuId;
  int? selectedPekerjaanAnakId;
  int? selectedNikIndex;
  int? selectedNikId;
  DateTime? selectedDate;
  PlatformFile? selectedFile;
  String? selectedFileName;

  // State
  bool isLoading = false;
  List<NikHive> nikDataList = [];

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

  void setSelectedAgamaId(int? value) {
    selectedAgamaId = value;
    notifyListeners();
  }

  void setSelectedPekerjaanAnakId(int? value) {
    selectedPekerjaanAnakId = value;
    notifyListeners();
  }

  void setSelectedPekerjaanOrtuId(int? value) {
    selectedPekerjaanOrtuId = value;
    notifyListeners();
  }

  void setSelectedNik(int index, int id, NikHive anggota,
      {required List<AgamaData> agamaList,
      required List<Datum> jkList,
      required List<PekerjaanData> pekerjaanList}) {
    selectedNikIndex = index;
    selectedNikId = id;

    nikController.text = anggota.nomorNik;
    namaAnakController.text = anggota.name;
    alamatController.text = anggota.alamat;
    tempatLahirController.text = anggota.tempatLahir;
    tanggalLahirController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(anggota.tanggalLahir));
    selectedAgamaId = anggota.agama;
    selectedHubunganId = anggota.hubungan;
    selectedKelaminId = anggota.jk;
    selectedPekerjaanAnakId = anggota.pekerjaan;

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

  Future<Map<String, dynamic>?> fetchSktmBeasiswaById(String detailId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan');
      }

      final uri = Uri.parse('$baseUrl/sktm-beasiswa/$detailId');
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 30));

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
    required Map<String, dynamic> sktmBeasiswa,
    required List<Datum> jkList,
    required List<PekerjaanData> pekerjaanList,
    required List<AgamaData> agamaList,
    required List<HubunganData> hubunganList,
    List<NikHive>? nikList,
  }) {
    try {
      // Fill text controllers
      namaAyahController.text = sktmBeasiswa['nama']?.toString().trim() ?? '';
      namaIbuController.text =
          sktmBeasiswa['nama_ibu']?.toString().trim() ?? '';
      namaAnakController.text =
          sktmBeasiswa['nama_anak']?.toString().trim() ?? '';
      tempatLahirController.text =
          sktmBeasiswa['tempat_lahir']?.toString().trim() ?? '';
      alamatController.text = sktmBeasiswa['alamat']?.toString().trim() ?? '';
      sukuController.text = sktmBeasiswa['suku']?.toString().trim() ?? '';
      catatanController.text = sktmBeasiswa['catatan']?.toString().trim() ?? '';

      if (sktmBeasiswa['nik'] != null) {
        nikController.text = sktmBeasiswa['nik'].toString().trim();
      }

      // Set tanggal lahir
      if (sktmBeasiswa['tanggal_lahir'] != null) {
        try {
          final dateStr = sktmBeasiswa['tanggal_lahir'].toString();
          final date = DateTime.parse(dateStr);
          selectedDate = date;
          tanggalLahirController.text = DateFormat('yyyy-MM-dd').format(date);
        } catch (e) {
          // Handle error silently
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
          // Fallback: partial match
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
        sktmBeasiswa['hubungan']?.toString(),
        (item) => item.jenisHubungan,
        (item) => item.id,
      );

      selectedKelaminId = findIdByName(
        jkList,
        sktmBeasiswa['jk']?.toString(),
        (item) => item.jenisKelamin,
        (item) => item.id,
      );

      selectedPekerjaanAnakId = findIdByName(
        pekerjaanList,
        sktmBeasiswa['pekerjaan_anak']?.toString(),
        (item) => item.namaPekerjaan,
        (item) => item.id,
      );

      selectedPekerjaanOrtuId = findIdByName(
        pekerjaanList,
        sktmBeasiswa['pekerjaan_ortu']?.toString(),
        (item) => item.namaPekerjaan,
        (item) => item.id,
      );

      selectedAgamaId = findIdByName(
        agamaList,
        sktmBeasiswa['agama']?.toString(),
        (item) => item.namaAgama,
        (item) => item.id,
      );

      // NIK ID mapping
      final nikIdFromApi = extractId(sktmBeasiswa['nik_id']);

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
            if (sktmBeasiswa['nik'] != null) {
              try {
                final nikFromResponse = sktmBeasiswa['nik'].toString();
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
    } catch (e, stackTrace) {
      // Handle error silently
    }
  }

  Future<int> updateForm(BuildContext context, String detailId) async {
    setLoading(true);

    try {
      // Validasi
      if (selectedNikId == null ||
          selectedHubunganId == null ||
          selectedKelaminId == null ||
          selectedAgamaId == null ||
          selectedPekerjaanOrtuId == null ||
          selectedPekerjaanAnakId == null) {
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
        'nama_anak': namaAnakController.text,
        'tempat_lahir': tempatLahirController.text,
        'tanggal_lahir': tanggalLahirController.text,
        'jk': selectedKelaminId.toString(),
        'suku': sukuController.text,
        'agama': selectedAgamaId.toString(),
        'pekerjaan_anak': selectedPekerjaanAnakId.toString(),
        'nama': namaAyahController.text,
        'nama_ibu': namaIbuController.text,
        'pekerjaan_ortu': selectedPekerjaanOrtuId.toString(),
        'alamat': alamatController.text,
        '_method': 'PUT',
      };

      final uri = Uri.parse('$baseUrl/sktm-beasiswa/$detailId');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields.addAll(data)
        ..files.add(http.MultipartFile.fromBytes(
          'file_kk',
          selectedFile!.bytes!,
          filename: selectedFile!.name,
        ));

      final streamed =
          await request.send().timeout(const Duration(seconds: 30));
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
    namaAnakController.clear();
    namaAyahController.clear();
    namaIbuController.clear();
    nikController.clear();
    tempatLahirController.clear();
    alamatController.clear();
    catatanController.clear();
    tanggalLahirController.clear();
    sukuController.clear();

    selectedHubunganId = null;
    selectedKelaminId = null;
    selectedPekerjaanAnakId = null;
    selectedPekerjaanOrtuId = null;
    selectedAgamaId = null;
    selectedFile = null;
    selectedFileName = null;
    selectedNikIndex = null;
    selectedNikId = null;
    selectedDate = null;

    notifyListeners();
  }

  void disposeControllers() {
    nikController.dispose();
    namaAnakController.dispose();
    namaAyahController.dispose();
    namaIbuController.dispose();
    tempatLahirController.dispose();
    alamatController.dispose();
    tanggalLahirController.dispose();
    sukuController.dispose();
    catatanController.dispose();
  }
}
