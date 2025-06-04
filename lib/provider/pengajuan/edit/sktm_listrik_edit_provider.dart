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
import 'package:proyek2/data/models/informasi_umum/penghasilan_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SktmListrikEditProvider extends ChangeNotifier {
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

  void setSelectedNik(int index, int id, NikHive anggota) {
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

  Future<Map<String, dynamic>?> fetchSktmListrikById(String detailId) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login ulang.');
      }

      final uri = Uri.parse('$baseUrl/sktm-listrik/$detailId');
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
    required Map<String, dynamic> sktmListrikData,
    required List<Datum> jkList,
    required List<AgamaData> agamaList,
    required List<PekerjaanData> pekerjaanList,
    required List<PenghasilanData> penghasilanList,
    required List<HubunganData> hubunganList,
    List<NikHive>? nikList,
  }) {
    try {
      namaController.text = sktmListrikData['nama']?.toString().trim() ?? '';
      alamatController.text =
          sktmListrikData['alamat']?.toString().trim() ?? '';
      namaPlnController.text =
          sktmListrikData['nama_pln']?.toString().trim() ?? '';
      umurController.text = sktmListrikData['umur']?.toString().trim() ?? '';
      catatanController.text =
          sktmListrikData['catatan']?.toString().trim() ?? '';

      if (sktmListrikData['nik'] != null) {
        nikController.text = sktmListrikData['nik'].toString().trim();
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
        } catch (e) {
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

      selectedHubunganId = findIdByName(
        hubunganList,
        sktmListrikData['hubungan']?.toString(),
        (item) => item.jenisHubungan,
        (item) => item.id,
      );

      selectedKelaminId = findIdByName(
        jkList,
        sktmListrikData['jk']?.toString(),
        (item) => item.jenisKelamin,
        (item) => item.id,
      );

      selectedPekerjaanId = findIdByName(
        pekerjaanList,
        sktmListrikData['pekerjaan']?.toString(),
        (item) => item.namaPekerjaan,
        (item) => item.id,
      );

      selectedPenghasilanId = findIdByName(
        penghasilanList,
        sktmListrikData['penghasilan']?.toString(),
        (item) => item.rentangPenghasilan,
        (item) => item.id,
      );

      selectedAgamaId = findIdByName(
        agamaList,
        sktmListrikData['agama']?.toString(),
        (item) => item.namaAgama,
        (item) => item.id,
      );

      final nikIdFromApi = extractId(sktmListrikData['nik_id']);

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
            if (sktmListrikData['nik'] != null) {
              try {
                final nikFromResponse = sktmListrikData['nik'].toString();
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

  Future<int> updateForm(BuildContext context, String detailId) async {
    setLoading(true);

    try {
      List<String> missingFields = [];

      if (selectedHubunganId == null)
        missingFields.add('Status dalam Keluarga');
      if (selectedKelaminId == null) missingFields.add('Jenis Kelamin');
      if (selectedPenghasilanId == null) missingFields.add('Penghasilan');
      if (selectedPekerjaanId == null) missingFields.add('Pekerjaan');
      if (selectedAgamaId == null) missingFields.add('Agama');
      if (selectedNikId == null) missingFields.add('NIK');
      if (namaController.text.trim().isEmpty) missingFields.add('Nama Lengkap');
      if (alamatController.text.trim().isEmpty) missingFields.add('Alamat');
      if (namaPlnController.text.trim().isEmpty) missingFields.add('Nama PLN');
      if (umurController.text.trim().isEmpty) missingFields.add('Umur');
      if (selectedFileName == null || selectedFile == null) {
        missingFields.add('File KK');
      }

      if (missingFields.isNotEmpty) {
        throw Exception("Field yang belum diisi: ${missingFields.join(', ')}");
      }

      if (selectedFile == null || selectedFile!.bytes == null) {
        throw Exception("File KK belum dipilih atau tidak valid.");
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
        'kk_id': kkId.toString(),
        'nik_id': selectedNikId?.toString() ?? '',
        'nama': namaController.text,
        'umur': umurController.text,
        'alamat': alamatController.text,
        'nama_pln': namaPlnController.text,
        'hubungan': selectedHubunganId?.toString() ?? '',
        'jk': selectedKelaminId?.toString() ?? '',
        'agama': selectedAgamaId?.toString() ?? '',
        'pekerjaan': selectedPekerjaanId?.toString() ?? '',
        'penghasilan': selectedPenghasilanId?.toString() ?? '',
      };

      final requiredFields = [
        'hubungan',
        'nik_id',
        'kk_id',
        'nama',
        'umur',
        'nama_pln',
        'jk',
        'agama',
        'penghasilan',
        'pekerjaan',
        'alamat'
      ];

      final emptyRequiredFields = requiredFields
          .where((field) => !data.containsKey(field) || data[field]!.isEmpty)
          .toList();

      if (emptyRequiredFields.isNotEmpty) {
        throw Exception(
            'Field required yang kosong: ${emptyRequiredFields.join(', ')}');
      }

      final uri = Uri.parse('$baseUrl/sktm-listrik/$detailId');
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.fields['_method'] = 'PUT';
      request.fields.addAll(data);

      request.files.add(http.MultipartFile.fromBytes(
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
    alamatController.clear();
    namaPlnController.clear();
    umurController.clear();
    catatanController.clear();
    selectedAgamaId = null;
    selectedHubunganId = null;
    selectedKelaminId = null;
    selectedPekerjaanId = null;
    selectedPenghasilanId = null;
    selectedFile = null;
    selectedFileName = null;
    selectedNikIndex = null;
    selectedNikId = null;
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
    selectedFileName = null;
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }
}
