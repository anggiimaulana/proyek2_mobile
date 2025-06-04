import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:proyek2/data/api/api_services.dart';
import 'package:proyek2/data/models/informasi_umum/agama_model.dart';
import 'package:proyek2/data/models/informasi_umum/data_kk_hive_model.dart';
import 'package:proyek2/data/models/informasi_umum/jk_model.dart';
import 'package:proyek2/data/models/informasi_umum/pekerjaan_model.dart';
import 'package:proyek2/data/models/informasi_umum/penghasilan_model.dart';
import 'package:proyek2/data/models/informasi_umum/hubungan_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SkpotEditProvider extends ChangeNotifier {
  final nikController = TextEditingController();
  final namaAnakController = TextEditingController();
  final tempatLahirController = TextEditingController();
  final tanggalLahirController = TextEditingController();
  final namaOrtuController = TextEditingController();
  final alamatController = TextEditingController();
  final catatanController = TextEditingController();

  int? selectedHubunganId;
  int? selectedKelaminId;
  int? selectedAgamaId;
  int? selectedPekerjaanOrtuId;
  int? selectedPenghasilanOrtuId;
  int? selectedNikIndex;
  int? selectedNikId;
  DateTime? selectedDate;
  PlatformFile? selectedFile;
  String? selectedFileName;

  final baseUrl = ApiServices.baseUrl;
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

  void setSelectedPenghasilanOrtuId(int? value) {
    selectedPenghasilanOrtuId = value;
    notifyListeners();
  }

  void setSelectedPekerjaanOrtuId(int? value) {
    selectedPekerjaanOrtuId = value;
    notifyListeners();
  }

  void setSelectedNik(
    int index,
    int id,
    NikHive anggota,
  ) {
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

  Future<Map<String, dynamic>?> fetchSkpotById(String detailId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null || token.isEmpty)
        throw Exception('Token tidak ditemukan');
      final uri = Uri.parse('$baseUrl/skpot/$detailId');
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
    } catch (_) {
      return null;
    }
  }

  int? extractId(dynamic data) {
    if (data == null) return null;
    if (data is int) return data;
    if (data is String) return int.tryParse(data);
    if (data is double) return data.toInt();
    if (data is Map && data.containsKey('id')) return extractId(data['id']);
    return null;
  }

  void fillFormWithExistingDataUpdate({
    required Map<String, dynamic> skpotBeasiswa,
    required List<Datum> jkList,
    required List<PekerjaanData> pekerjaanList,
    required List<AgamaData> agamaList,
    required List<HubunganData> hubunganList,
    required List<PenghasilanData> penghasilanList,
    List<NikHive>? nikList,
  }) {
    namaOrtuController.text =
        skpotBeasiswa['nama_ortu']?.toString().trim() ?? '';
    namaAnakController.text = skpotBeasiswa['nama']?.toString().trim() ?? '';
    tempatLahirController.text =
        skpotBeasiswa['tempat_lahir']?.toString().trim() ?? '';
    alamatController.text = skpotBeasiswa['alamat']?.toString().trim() ?? '';
    catatanController.text = skpotBeasiswa['catatan']?.toString().trim() ?? '';
    if (skpotBeasiswa['nik'] != null) {
      nikController.text = skpotBeasiswa['nik'].toString().trim();
    }
    if (skpotBeasiswa['tanggal_lahir'] != null) {
      try {
        final dateStr = skpotBeasiswa['tanggal_lahir'].toString();
        final date = DateTime.parse(dateStr);
        selectedDate = date;
        tanggalLahirController.text = DateFormat('yyyy-MM-dd').format(date);
      } catch (_) {}
    }

    int? findIdByName<T>(List<T> list, String? targetName,
        String Function(T) getName, int Function(T) getId) {
      if (targetName == null || targetName.isEmpty) return null;
      try {
        final targetLower = targetName.toLowerCase().trim();
        final item = list.firstWhere(
          (element) => getName(element).toLowerCase().trim() == targetLower,
        );
        return getId(item);
      } catch (_) {
        try {
          final targetLower = targetName.toLowerCase().trim();
          final item = list.firstWhere(
            (element) =>
                getName(element).toLowerCase().contains(targetLower) ||
                targetLower.contains(getName(element).toLowerCase()),
          );
          return getId(item);
        } catch (_) {
          return null;
        }
      }
    }

    selectedHubunganId = findIdByName(
      hubunganList,
      skpotBeasiswa['hubungan']?.toString(),
      (item) => item.jenisHubungan,
      (item) => item.id,
    );
    selectedKelaminId = findIdByName(
      jkList,
      skpotBeasiswa['jk']?.toString(),
      (item) => item.jenisKelamin,
      (item) => item.id,
    );
    selectedPekerjaanOrtuId = findIdByName(
      pekerjaanList,
      skpotBeasiswa['pekerjaan']?.toString(),
      (item) => item.namaPekerjaan,
      (item) => item.id,
    );
    selectedPenghasilanOrtuId = findIdByName(
      penghasilanList,
      skpotBeasiswa['penghasilan']?.toString(),
      (item) => item.rentangPenghasilan,
      (item) => item.id,
    );
    selectedAgamaId = findIdByName(
      agamaList,
      skpotBeasiswa['agama']?.toString(),
      (item) => item.namaAgama,
      (item) => item.id,
    );

    final nikIdFromApi = extractId(skpotBeasiswa['nik_id']);
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
        } catch (_) {
          if (skpotBeasiswa['nik'] != null) {
            try {
              final nikFromResponse = skpotBeasiswa['nik'].toString();
              final nikItem = nikList.firstWhere(
                (nik) => nik.nomorNik == nikFromResponse,
              );
              selectedNikId = nikItem.id;
            } catch (_) {
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
  }

  Future<int> updateForm(BuildContext context, String detailId) async {
    setLoading(true);
    try {
      if (selectedNikId == null ||
          selectedHubunganId == null ||
          selectedKelaminId == null ||
          selectedAgamaId == null ||
          selectedPenghasilanOrtuId == null ||
          selectedPekerjaanOrtuId == null) {
        throw Exception("Mohon lengkapi semua data dropdown dengan benar.");
      }
      if (selectedFile == null || selectedFile!.bytes == null) {
        throw Exception("File KK belum dipilih.");
      }
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final kkId = prefs.getInt('kk_id');
      if (token == null || kkId == null) throw Exception("Login ulang!");

      final Map<String, String> data = {
        'hubungan': selectedHubunganId.toString(),
        'kk_id': kkId.toString(),
        'nik_id': selectedNikId.toString(),
        'nama': namaAnakController.text,
        'tempat_lahir': tempatLahirController.text,
        'tanggal_lahir': tanggalLahirController.text,
        'jk': selectedKelaminId.toString(),
        'agama': selectedAgamaId.toString(),
        'nama_ortu': namaOrtuController.text,
        'pekerjaan': selectedPekerjaanOrtuId.toString(),
        'penghasilan': selectedPenghasilanOrtuId.toString(),
        'alamat': alamatController.text,
        if (catatanController.text.isNotEmpty)
          'catatan': catatanController.text,
        '_method': 'PUT',
      };

      final uri = Uri.parse('$baseUrl/skpot/$detailId');
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
    nikController.clear();
    namaOrtuController.clear();
    alamatController.clear();
    namaAnakController.clear();
    tempatLahirController.clear();
    tanggalLahirController.clear();
    catatanController.clear();
    selectedHubunganId = null;
    selectedKelaminId = null;
    selectedAgamaId = null;
    selectedPekerjaanOrtuId = null;
    selectedPenghasilanOrtuId = null;
    selectedNikId = null;
    selectedFile = null;
    selectedFileName = null;
    selectedDate = null;
    notifyListeners();
  }

  void disposeControllers() {
    nikController.dispose();
    namaAnakController.dispose();
    namaOrtuController.dispose();
    tempatLahirController.dispose();
    tanggalLahirController.dispose();
    alamatController.dispose();
    catatanController.dispose();
  }
}
