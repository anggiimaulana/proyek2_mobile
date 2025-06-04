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

class SktmListrikCreateProvider extends ChangeNotifier {
  final nikController = TextEditingController();
  final namaController = TextEditingController();
  final umurController = TextEditingController();
  final alamatController = TextEditingController();
  final namaPlnController = TextEditingController();
  final catatanController = TextEditingController();

  int? selectedHubunganId;
  int? selectedKelaminId;
  int? selectedAgamaId;
  int? selectedPekerjaanId;
  int? selectedPenghasilanId;
  PlatformFile? selectedFile;
  String? selectedFileName;
  int? selectedNikIndex;
  int? selectedNikId;

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

  void setSelectedPenghasilanId(int? value) {
    selectedPenghasilanId = value;
    notifyListeners();
  }

  void setSelectedNik(int index, int id, NikHive anggota,
      {required List<Datum> jkList,
      required List<AgamaData> agamaList,
      required List<PekerjaanData> pekerjaanList}) {
    selectedNikIndex = index;
    selectedNikId = id;

    nikController.text = anggota.nomorNik;
    namaController.text = anggota.name;
    alamatController.text = anggota.alamat;

    selectedAgamaId = anggota.agama;
    selectedHubunganId = anggota.hubungan;
    selectedKelaminId = anggota.jk;
    selectedPekerjaanId = anggota.pekerjaan;

    notifyListeners();
  }

  Future<void> pickFile(BuildContext context) async {
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
          selectedPekerjaanId == null ||
          selectedPenghasilanId == null) {
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
        'kk_id': prefs.getInt('kk_id'),
        'nik_id': selectedNikId,
        'nama': namaController.text,
        'umur': umurController.text,
        'alamat': alamatController.text,
        'nama_pln': namaPlnController.text,
        'hubungan': selectedHubunganId,
        'jk': selectedKelaminId,
        'agama': selectedAgamaId,
        'pekerjaan': selectedPekerjaanId,
        'penghasilan': selectedPenghasilanId,
      };

      final uri = Uri.parse('$baseUrl/sktm-listrik');
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
    namaController.clear();
    nikController.clear();
    alamatController.clear();
    namaPlnController.clear();
    catatanController.clear();
    umurController.clear();
    selectedHubunganId = null;
    selectedKelaminId = null;
    selectedPekerjaanId = null;
    selectedAgamaId = null;
    selectedFile = null;
    selectedFileName = null;
    selectedNikIndex = null;
    selectedNikId = null;
    selectedPenghasilanId = null;
    notifyListeners();
  }

  void disposeControllers() {
    nikController.dispose();
    namaController.dispose();
    alamatController.dispose();
    namaPlnController.dispose();
    umurController.dispose();
    catatanController.dispose();
    selectedFile = null;
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }
}
