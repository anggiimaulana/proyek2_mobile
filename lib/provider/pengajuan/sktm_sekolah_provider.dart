import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:proyek2/data/api/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SktmSekolahProvider extends ChangeNotifier {
  final namaOrtuController = TextEditingController();
  final tempatLahirOrtuController = TextEditingController();
  final tanggalLahirOrtuController = TextEditingController();
  final alamatController = TextEditingController();
  final namaAnakController = TextEditingController();
  final tempatLahirAnakController = TextEditingController();
  final tanggalLahirAnakController = TextEditingController();
  final namaSekolahController = TextEditingController();
  final kelasAnakController = TextEditingController();

  int? selectedHubunganId;
  int? selectedKelaminId;
  int? selectedAgamaId;
  int? selectedPekerjaanId;

  DateTime? selectedDateOrtu;
  DateTime? selectedDateAnak;

  PlatformFile? selectedFile;
  String? selectedFileName;
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

  Future<void> pickKKFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      selectedFile = result.files.single;
      selectedFileName = selectedFile!.name;
      notifyListeners();
    }
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

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<int> submitForm(BuildContext context) async {
    setLoading(true); 

    try {
      if (selectedHubunganId == null ||
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
      setLoading(false); // ⬅️ SELESAI loading (berhasil/gagal tetap off)
    }
  }

  void resetForm() {
    selectedHubunganId = null;
    namaAnakController.clear();
    tempatLahirOrtuController.clear();
    tanggalLahirOrtuController.clear();
    selectedKelaminId = null;
    tempatLahirAnakController.clear();
    selectedAgamaId = null;
    namaOrtuController.clear();
    tanggalLahirAnakController.clear();
    selectedPekerjaanId = null;
    alamatController.clear();
    selectedFile = null;
    selectedFileName = null;
    notifyListeners();
  }

  void disposeControllers() {
    namaAnakController.dispose();
    tempatLahirOrtuController.dispose();
    tanggalLahirOrtuController.dispose();
    tempatLahirAnakController.dispose();
    namaOrtuController.dispose();
    tanggalLahirAnakController.dispose();
    alamatController.dispose();
  }
}
