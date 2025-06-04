import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:proyek2/data/api/api_services.dart';
import 'package:proyek2/data/models/informasi_umum/agama_model.dart';
import 'package:proyek2/data/models/informasi_umum/data_kk_hive_model.dart';
import 'package:proyek2/data/models/informasi_umum/jk_model.dart';
import 'package:proyek2/data/models/informasi_umum/pekerjaan_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SkpotCreateProvider extends ChangeNotifier {
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

  void setSelectedNik(int index, int id, NikHive anggota,
      {required List<Datum> jkList,
      required List<PekerjaanData> pekerjaanList,
      required List<AgamaData> agamaList}) {
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

  Future<int> submitForm(BuildContext context) async {
    setLoading(true);
    try {
      if (selectedHubunganId == null ||
          selectedKelaminId == null ||
          selectedNikIndex == null ||
          selectedAgamaId == null ||
          selectedPenghasilanOrtuId == null ||
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
        'nama': namaAnakController.text,
        'tempat_lahir': tempatLahirController.text,
        'tanggal_lahir': tanggalLahirController.text,
        'jk': selectedKelaminId,
        'agama': selectedAgamaId,
        'nama_ortu': namaOrtuController.text,
        'pekerjaan': selectedPekerjaanOrtuId,
        'penghasilan': selectedPenghasilanOrtuId,
        'alamat': alamatController.text,
      };

      final uri = Uri.parse('$baseUrl/skpot');
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
    tempatLahirController.clear();
    tanggalLahirController.clear();
    alamatController.clear();
    catatanController.clear();
    selectedHubunganId = null;
    selectedKelaminId = null;
    selectedPekerjaanOrtuId = null;
    selectedPenghasilanOrtuId = null;
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
    namaOrtuController.dispose();
    tempatLahirController.dispose();
    tanggalLahirController.dispose();
    alamatController.dispose();
    catatanController.dispose();
  }
}
