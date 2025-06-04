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

class SktmSekolahCreateProvider extends ChangeNotifier {
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
  int? selectedNikIndex;
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

  void setSelectedPekerjaanId(int? value) {
    selectedPekerjaanId = value;
    notifyListeners();
  }

  void setSelectedNik(int index, int id, NikHive anggota,
      {required List<Datum> jkList,
      required List<AgamaData> agamaList,
      required List<PekerjaanData> pekerjaanList,
      required List<HubunganData> hubunganList}) {
    selectedNikIndex = index;
    selectedNikId = id;

    // Find matching data
    AgamaData? matchingAgama;
    Datum? matchingJk;
    PekerjaanData? matchingPekerjaan;
    HubunganData? matchingHubungan;

    try {
      matchingAgama = agamaList.firstWhere(
        (agama) =>
            agama.id == anggota.agama ||
            agama.namaAgama.toLowerCase() ==
                anggota.agama.toString().toLowerCase(),
      );
    } catch (e) {
      matchingAgama = null;
    }

    try {
      matchingHubungan = hubunganList.firstWhere(
        (hubungan) =>
            hubungan.id == anggota.hubungan ||
            hubungan.jenisHubungan.toLowerCase() ==
                anggota.hubungan.toString().toLowerCase(),
      );
    } catch (e) {
      matchingHubungan = null;
    }

    try {
      matchingJk = jkList.firstWhere(
        (jk) =>
            jk.id == anggota.jk ||
            jk.jenisKelamin.toLowerCase() ==
                anggota.jk.toString().toLowerCase(),
      );
    } catch (e) {
      matchingJk = null;
    }

    try {
      matchingPekerjaan = pekerjaanList.firstWhere(
        (pekerjaan) =>
            pekerjaan.id == anggota.pekerjaan ||
            pekerjaan.namaPekerjaan.toLowerCase() ==
                anggota.pekerjaan.toString().toLowerCase(),
      );
    } catch (e) {
      matchingPekerjaan = null;
    }

    fillDataFromKartuKeluarga(anggota, matchingAgama, matchingJk,
        matchingPekerjaan, matchingHubungan);
    notifyListeners();
  }

  void fillDataFromKartuKeluarga(NikHive nikData, AgamaData? agama, Datum? jk,
      PekerjaanData? pekerjaan, HubunganData? hubungan) {
    nikController.text = nikData.nomorNik;
    namaAnakController.text = nikData.name;
    alamatController.text = nikData.alamat;
    tempatLahirAnakController.text = nikData.tempatLahir;
    tanggalLahirAnakController.text = nikData.tanggalLahir;

    selectedKelaminId = jk?.id;
    selectedAgamaId = agama?.id;
    selectedPekerjaanId = pekerjaan?.id;
    selectedHubunganId = hubungan?.id;

    if (nikData.tanggalLahir.isNotEmpty) {
      try {
        selectedDateAnak = DateFormat('yyyy-MM-dd').parse(nikData.tanggalLahir);
      } catch (e) {
        try {
          selectedDateAnak =
              DateFormat('dd/MM/yyyy').parse(nikData.tanggalLahir);
          tanggalLahirAnakController.text =
              DateFormat('yyyy-MM-dd').format(selectedDateAnak!);
        } catch (e2) {
          // Handle date parsing error
        }
      }
    }

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

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<int> submitForm(BuildContext context) async {
    setLoading(true);

    try {
      if (selectedHubunganId == null ||
          selectedNikIndex == null ||
          selectedKelaminId == null ||
          selectedAgamaId == null ||
          selectedPekerjaanId == null) {
        throw Exception("Semua dropdown harus dipilih.");
      }

      if (selectedFile == null || selectedFile!.bytes == null) {
        throw Exception("File KK belum dipilih atau tidak valid.");
      }

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('client_id')?.toString();
      if (userId == null) throw Exception('User belum login');

      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login ulang.');
      }

      final Map<String, dynamic> data = {
        'hubungan': selectedHubunganId,
        'kk_id': prefs.getInt('kk_id'),
        'nik_id': selectedNikId,
        'nama': namaOrtuController.text,
        'tempat_lahir_ortu': tempatLahirOrtuController.text,
        'tanggal_lahir_ortu': tanggalLahirOrtuController.text,
        'agama': selectedAgamaId,
        'pekerjaan': selectedPekerjaanId,
        'alamat': alamatController.text,
        'nama_anak': namaAnakController.text,
        'tempat_lahir': tempatLahirAnakController.text,
        'tanggal_lahir': tanggalLahirAnakController.text,
        'jk': selectedKelaminId,
        'asal_sekolah': namaSekolahController.text,
        'kelas': kelasAnakController.text,
      };

      final uri = Uri.parse('$baseUrl/sktm-sekolah');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields.addAll(data.map((k, v) => MapEntry(k, v.toString())))
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
        final json = jsonDecode(body);
        final data = json['data'];
        if (data == null) throw Exception("Tidak ada data dalam respons.");
        await Future.delayed(const Duration(seconds: 2));
        return 1;
      } else {
        final error = jsonDecode(body);
        final msg = error['message'] ?? 'Unknown error';
        throw Exception('Gagal upload: $msg (Status $status)');
      }
    } finally {
      setLoading(false);
    }
  }

  void resetForm() {
    namaAnakController.clear();
    namaOrtuController.clear();
    nikController.clear();
    tempatLahirAnakController.clear();
    tempatLahirOrtuController.clear();
    tanggalLahirOrtuController.clear();
    tanggalLahirAnakController.clear();
    alamatController.clear();
    namaSekolahController.clear();
    kelasAnakController.clear();
    catatanController.clear();

    selectedHubunganId = null;
    selectedKelaminId = null;
    selectedAgamaId = null;
    selectedPekerjaanId = null;
    selectedNikIndex = null;
    selectedNikId = null;
    selectedDateOrtu = null;
    selectedDateAnak = null;
    selectedFile = null;
    selectedFileName = null;

    notifyListeners();
  }

  void disposeControllers() {
    nikController.dispose();
    namaAnakController.dispose();
    namaOrtuController.dispose();
    tempatLahirAnakController.dispose();
    tempatLahirOrtuController.dispose();
    tanggalLahirOrtuController.dispose();
    tanggalLahirAnakController.dispose();
    alamatController.dispose();
    namaSekolahController.dispose();
    kelasAnakController.dispose();
    catatanController.dispose();
  }
}
