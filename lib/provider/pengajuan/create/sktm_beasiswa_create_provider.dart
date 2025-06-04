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

class SktmBeasiswaCreateProvider extends ChangeNotifier {
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

  void setSelectedNikWithMapping(int index, int id, NikHive anggota,
      {required List<AgamaData> agamaList,
      required List<HubunganData> hubunganList,
      required List<Datum> jkList,
      required List<PekerjaanData> pekerjaanList}) {
    selectedNikIndex = index;
    selectedNikId = id;

    AgamaData? matchingAgama;
    Datum? matchingJk;
    PekerjaanData? matchingPekerjaan;
    HubunganData? matchingHubungan;

    try {
      matchingAgama = agamaList.firstWhere(
        (agama) =>
            agama.id == anggota.agama ||
            agama.namaAgama.toLowerCase() == anggota.agama,
      );
    } catch (e) {
      matchingAgama = null;
    }

    try {
      matchingHubungan = hubunganList.firstWhere(
        (hubungan) =>
            hubungan.id == anggota.hubungan ||
            hubungan.jenisHubungan.toLowerCase() == anggota.hubungan,
      );
    } catch (e) {
      matchingHubungan = null;
    }

    try {
      matchingJk = jkList.firstWhere(
        (jk) =>
            jk.id == anggota.jk || jk.jenisKelamin.toLowerCase() == anggota.jk,
      );
    } catch (e) {
      matchingJk = null;
    }

    try {
      matchingPekerjaan = pekerjaanList.firstWhere(
        (pekerjaan) =>
            pekerjaan.id == anggota.pekerjaan ||
            pekerjaan.namaPekerjaan.toLowerCase() == anggota.pekerjaan,
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

    selectedKelaminId = jk?.id;
    selectedAgamaId = agama?.id;
    selectedPekerjaanAnakId = pekerjaan?.id;
    selectedHubunganId = hubungan?.id;

    if (nikData.tanggalLahir.isNotEmpty) {
      try {
        selectedDate = DateFormat('yyyy-MM-dd').parse(nikData.tanggalLahir);
      } catch (e) {
        try {
          selectedDate = DateFormat('dd/MM/yyyy').parse(nikData.tanggalLahir);
          tanggalLahirController.text =
              DateFormat('yyyy-MM-dd').format(selectedDate!);
        } catch (e2) {
          // Handle error silently
        }
      }
    }

    notifyListeners();
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

    if (tanggalLahirController.text.isEmpty) {
      throw Exception("Tanggal lahir belum diisi.");
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
          selectedPekerjaanAnakId == null ||
          selectedPekerjaanOrtuId == null) {
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
        'nama_anak': namaAnakController.text,
        'tempat_lahir': tempatLahirController.text,
        'tanggal_lahir': tanggalLahirController.text,
        'jk': selectedKelaminId,
        'suku': sukuController.text,
        'agama': selectedAgamaId,
        'pekerjaan_anak': selectedPekerjaanAnakId,
        'nama': namaAyahController.text,
        'nama_ibu': namaIbuController.text,
        'pekerjaan_ortu': selectedPekerjaanOrtuId,
        'alamat': alamatController.text,
      };

      final uri = Uri.parse('$baseUrl/sktm-beasiswa');
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
