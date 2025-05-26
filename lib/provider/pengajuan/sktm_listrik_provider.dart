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

class SktmListrikProvider extends ChangeNotifier {
  // create
  final nikControllerCreate = TextEditingController();
  final namaControllerCreate = TextEditingController();
  final umurControllerCreate = TextEditingController();
  final alamatControllerCreate = TextEditingController();
  final namaPlnControllerCreate = TextEditingController();
  final catatanControllerCreate = TextEditingController();

  int? selectedHubunganIdCreate;
  int? selectedKelaminIdCreate;
  int? selectedAgamaIdCreate;
  int? selectedPekerjaanIdCreate;
  int? selectedPenghasilanIdCreate;
  PlatformFile? selectedFileCreate;
  String? selectedFileNameCreate;
  int? selectedNikIndexCreate;
  int? selectedNikIdCreate;

  // update
  final nikControllerUpdate = TextEditingController();
  final namaControllerUpdate = TextEditingController();
  final umurControllerUpdate = TextEditingController();
  final alamatControllerUpdate = TextEditingController();
  final namaPlnControllerUpdate = TextEditingController();
  final catatanControllerUpdate = TextEditingController();

  int? selectedHubunganIdUpdate;
  int? selectedKelaminIdUpdate;
  int? selectedAgamaIdUpdate;
  int? selectedPekerjaanIdUpdate;
  int? selectedPenghasilanIdUpdate;
  PlatformFile? selectedFileUpdate;
  String? selectedFileNameUpdate;
  int? selectedNikIndexUpdate;
  int? selectedNikIdUpdate;

  final baseUrl = ApiServices.baseUrl;
  bool isLoading = false;
  List<NikHive> nikDataList = [];

  // Getters untuk mendapatkan controller yang tepat berdasarkan mode
  TextEditingController nikController(bool isUpdate) =>
      isUpdate ? nikControllerUpdate : nikControllerCreate;
  TextEditingController namaController(bool isUpdate) =>
      isUpdate ? namaControllerUpdate : namaControllerCreate;
  TextEditingController alamatController(bool isUpdate) =>
      isUpdate ? alamatControllerUpdate : alamatControllerCreate;
  TextEditingController namaUsaha(bool isUpdate) =>
      isUpdate ? namaPlnControllerUpdate : namaPlnControllerCreate;
  TextEditingController catatanController(bool isUpdate) =>
      isUpdate ? catatanControllerUpdate : catatanControllerCreate;

  // Getters untuk selected values
  int? selectedHubunganId(bool isUpdate) =>
      isUpdate ? selectedHubunganIdUpdate : selectedHubunganIdCreate;
  int? selectedKelaminId(bool isUpdate) =>
      isUpdate ? selectedKelaminIdUpdate : selectedKelaminIdCreate;
  int? selectedPekerjaanId(bool isUpdate) =>
      isUpdate ? selectedPekerjaanIdUpdate : selectedPekerjaanIdCreate;
  int? selectedNikIndex(bool isUpdate) =>
      isUpdate ? selectedNikIndexUpdate : selectedNikIndexCreate;
  int? selectedNikId(bool isUpdate) =>
      isUpdate ? selectedNikIdUpdate : selectedNikIdCreate;
  int? selectedAgamaId(bool isUpdate) =>
      isUpdate ? selectedAgamaIdUpdate : selectedAgamaIdCreate;
  int? selectedPenghasilanId(bool isUpdate) =>
      isUpdate ? selectedPenghasilanIdUpdate : selectedPenghasilanIdCreate;
  PlatformFile? selectedFile(bool isUpdate) =>
      isUpdate ? selectedFileUpdate : selectedFileCreate;
  String? selectedFileName(bool isUpdate) =>
      isUpdate ? selectedFileNameUpdate : selectedFileNameCreate;

  // void CreateIdCreate(int id) {
  //   selectedNikIdCreate = id;
  //   notifyListeners();
  // }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setNikDataList(List<NikHive> data) {
    nikDataList = data;
    notifyListeners();
  }

  void setSelectedHubunganIdCreate(int? value) {
    selectedHubunganIdCreate = value;
    notifyListeners();
  }

  void setSelectedKelaminIdCreate(int? value) {
    selectedKelaminIdCreate = value;
    notifyListeners();
  }

  void setSelectedAgamaIdCreate(int? value) {
    selectedAgamaIdCreate = value;
    notifyListeners();
  }

  void setSelectedPekerjaanIdCreate(int? value) {
    selectedPekerjaanIdCreate = value;
    notifyListeners();
  }

  void setSelectedPenghasilanIdCreate(int? value) {
    selectedPenghasilanIdCreate = value;
    notifyListeners();
  }

  void setSelectedHubunganIdUpdate(int? value) {
    selectedHubunganIdUpdate = value;
    notifyListeners();
  }

  void setSelectedKelaminIdUpdate(int? value) {
    selectedKelaminIdUpdate = value;
    notifyListeners();
  }

  void setSelectedAgamaIdUpdate(int? value) {
    selectedAgamaIdUpdate = value;
    notifyListeners();
  }

  void setSelectedPekerjaanIdUpdate(int? value) {
    selectedPekerjaanIdUpdate = value;
    notifyListeners();
  }

  void setSelectedPenghasilanIdUpdate(int? value) {
    selectedPenghasilanIdUpdate = value;
    notifyListeners();
  }

  // Method baru untuk mengatur NIK yang dipilih dan mengisi data otomatis
  void setSelectedNikCreate(int index, int id, NikHive anggota,
      {required List<AgamaData> agamaList,
      required List<Datum> jkList,
      required List<PekerjaanData> pekerjaanList}) {
    selectedNikIndexCreate = index;
    selectedNikIdCreate = id;

    // Set data text field
    nikControllerCreate.text = anggota.nomorNik;
    namaControllerCreate.text = anggota.name;
    alamatControllerCreate.text = anggota.alamat;

    selectedAgamaIdCreate = anggota.agama;
    selectedHubunganIdCreate = anggota.hubungan;
    selectedKelaminIdCreate = anggota.jk;
    selectedPekerjaanIdCreate = anggota.pekerjaan;

    notifyListeners();
  }

  void setSelectedNikUpdate(int index, int id, NikHive anggota,
      {required List<AgamaData> agamaList,
      required List<Datum> jkList,
      required List<PekerjaanData> pekerjaanList}) {
    selectedNikIndexUpdate = index;
    selectedNikIdUpdate = id;

    // Set data text field
    nikControllerUpdate.text = anggota.nomorNik;
    namaControllerUpdate.text = anggota.name;
    alamatControllerUpdate.text = anggota.alamat;

    selectedAgamaIdUpdate = anggota.agama;
    selectedHubunganIdUpdate = anggota.hubungan;
    selectedKelaminIdUpdate = anggota.jk;
    selectedPekerjaanIdUpdate = anggota.pekerjaan;

    notifyListeners();
  }

  Future<String?> _getKkId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('kk_id')?.toString();
  }

  // void createIndexCreate(int index, int id) {
  //   selectedNikIndexCreate = index;
  //   selectedNikIdCreate = id;
  //   notifyListeners();
  // }

  Future<void> pickKKFileCreate(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;

      // Validasi ukuran maksimal 2MB (2 * 1024 * 1024 bytes)
      if (file.size > 100 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ukuran file tidak boleh lebih dari 2MB'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      selectedFileCreate = file;
      selectedFileNameCreate = file.name;
      notifyListeners();
    }
  }

  Future<void> pickKKFileUpdate(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;

      // Validasi ukuran maksimal 2MB (2 * 1024 * 1024 bytes)
      if (file.size > 100 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ukuran file tidak boleh lebih dari 2MB'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      selectedFileUpdate = file;
      selectedFileNameUpdate = file.name;
      notifyListeners();
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<int> submitFormCreate(BuildContext context) async {
    setLoading(true); // ⬅️ MULAI loading

    try {
      if (selectedHubunganIdCreate == null ||
          selectedNikIndexCreate == null ||
          selectedKelaminIdCreate == null ||
          selectedAgamaIdCreate == null ||
          selectedPekerjaanIdCreate == null ||
          selectedPenghasilanIdCreate == null) {
        throw Exception("Semua dropdown harus dipilih.");
      }

      if (selectedFileCreate == null || selectedFileCreate!.bytes == null) {
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
        'nik_id': selectedNikIdCreate, // Ganti ini
        'nama': namaControllerCreate.text,
        'umur': umurControllerCreate.text,
        'alamat': alamatControllerCreate.text,
        'nama_pln': namaPlnControllerCreate.text,
        'hubungan': selectedHubunganIdCreate,
        'jk': selectedKelaminIdCreate,
        'agama': selectedAgamaIdCreate,
        'pekerjaan': selectedPekerjaanIdCreate,
        'penghasilan': selectedPenghasilanIdCreate,
      };

      final uri = Uri.parse('$baseUrl/sktm-listrik');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields.addAll(data.map((k, v) => MapEntry(k, v.toString())))
        ..files.add(http.MultipartFile.fromBytes(
          'file_kk',
          selectedFileCreate!.bytes!,
          filename: selectedFileCreate!.name,
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
        print('STATUS: $status');
        print('RESPONSE BODY: $body');
        final error = jsonDecode(body);
        final msg = error['message'] ?? 'Unknown error';
        throw Exception('Gagal upload: $msg (Status $status)');
      }
    } finally {
      setLoading(false);
    }
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
        print('Failed to fetch SKU data: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching SKU data: $e');
      return null;
    }
  }

  // Improved extractId method
  int? extractId(dynamic data) {
    try {
      if (data == null) {
        debugPrint('[extractId] data is null');
        return null;
      }

      if (data is int) {
        return data;
      }

      if (data is String) {
        final parsed = int.tryParse(data);
        if (parsed == null) {
          debugPrint('[extractId] Failed to parse string "$data" to int');
        }
        return parsed;
      }

      if (data is double) {
        return data.toInt();
      }

      if (data is Map) {
        if (data.containsKey('id')) {
          return extractId(data['id']); // Recursive call
        } else {
          debugPrint('[extractId] Map without "id" key: $data');
        }
      }

      debugPrint(
          '[extractId] Cannot extract id from type ${data.runtimeType}: $data');
      return null;
    } catch (e, stackTrace) {
      debugPrint('[extractId] Exception: $e');
      debugPrint('[extractId] Stack trace: $stackTrace');
      return null;
    }
  }

  void fillFormWithExistingDataUpdate({
    required Map<String, dynamic> sktmListrikData,
    required List<Datum> jkList,
    required List<AgamaData> agamaList,
    required List<PekerjaanData> pekerjaanList,
    required List<PenghasilanData> penghasilanList,
    required List<HubunganData> hubunganList,
    List<NikHive>? nikList,
  }) {
    try {
      debugPrint('=== FILLING FORM WITH EXISTING DATA ===');
      debugPrint('Raw sktmListrikData: $sktmListrikData');

      // Fill text controllers untuk UPDATE - dengan null safety
      namaControllerUpdate.text =
          sktmListrikData['nama']?.toString().trim() ?? '';
      alamatControllerUpdate.text =
          sktmListrikData['alamat']?.toString().trim() ?? '';
      namaPlnControllerUpdate.text =
          sktmListrikData['nama_pln']?.toString().trim() ?? '';
      umurControllerUpdate.text =
          sktmListrikData['umur']?.toString().trim() ?? '';
      catatanControllerUpdate.text =
          sktmListrikData['catatan']?.toString().trim() ?? '';

      // Set NIK text (kalau ada)
      if (sktmListrikData['nik'] != null) {
        nikControllerUpdate.text = sktmListrikData['nik'].toString().trim();
      }

      // Helper function untuk find ID berdasarkan nama dengan case-insensitive matching
      int? findIdByName<T>(List<T> list, String? targetName,
          String Function(T) getName, int Function(T) getId) {
        if (targetName == null || targetName.isEmpty) {
          debugPrint('Target name is null or empty');
          return null;
        }

        try {
          final targetLower = targetName.toLowerCase().trim();
          debugPrint(
              'Looking for: "$targetLower" in list: ${list.map((e) => getName(e)).toList()}');

          final item = list.firstWhere(
            (element) => getName(element).toLowerCase().trim() == targetLower,
          );
          final foundId = getId(item);
          debugPrint('Found match: "${getName(item)}" with ID: $foundId');
          return foundId;
        } catch (e) {
          debugPrint(
              'Item not found for name: $targetName in list: ${list.map((e) => getName(e)).toList()}');

          // Fallback: coba cari dengan partial match
          try {
            final targetLower = targetName.toLowerCase().trim();
            final item = list.firstWhere(
              (element) =>
                  getName(element).toLowerCase().contains(targetLower) ||
                  targetLower.contains(getName(element).toLowerCase()),
            );
            final foundId = getId(item);
            debugPrint(
                'Found partial match: "${getName(item)}" with ID: $foundId');
            return foundId;
          } catch (e2) {
            debugPrint('No partial match found either');
            return null;
          }
        }
      }

      // Map nama ke ID untuk masing-masing dropdown dengan logging
      selectedHubunganIdUpdate = findIdByName(
        hubunganList,
        sktmListrikData['hubungan']?.toString(),
        (item) => item.jenisHubungan,
        (item) => item.id,
      );
      debugPrint('selectedHubunganIdUpdate: $selectedHubunganIdUpdate');

      selectedKelaminIdUpdate = findIdByName(
        jkList,
        sktmListrikData['jk']?.toString(),
        (item) => item.jenisKelamin,
        (item) => item.id,
      );
      debugPrint('selectedKelaminIdUpdate: $selectedKelaminIdUpdate');

      selectedPekerjaanIdUpdate = findIdByName(
        pekerjaanList,
        sktmListrikData['pekerjaan']?.toString(),
        (item) => item.namaPekerjaan,
        (item) => item.id,
      );
      debugPrint('selectedPekerjaanIdUpdate: $selectedPekerjaanIdUpdate');

      selectedPenghasilanIdUpdate = findIdByName(
        penghasilanList,
        sktmListrikData['penghasilan']?.toString(),
        (item) => item.rentangPenghasilan,
        (item) => item.id,
      );
      debugPrint('selectedPenghasilanIdUpdate: $selectedPenghasilanIdUpdate');

      selectedAgamaIdUpdate = findIdByName(
        agamaList,
        sktmListrikData['agama']?.toString(),
        (item) => item.namaAgama,
        (item) => item.id,
      );
      debugPrint('selectedStatusIdUpdate: $selectedAgamaIdUpdate');

      // PERBAIKAN: NIK ID mapping dengan logging
      final nikIdFromApi = extractId(sktmListrikData['nik_id']);
      debugPrint('nikIdFromApi from extractId: $nikIdFromApi');

      if (nikIdFromApi != null && nikList != null) {
        // Debug: print semua NIK di list
        debugPrint(
            'Available NIKs: ${nikList.map((e) => 'ID:${e.id} NIK:${e.nomorNik}').toList()}');

        // Cek apakah nikIdFromApi adalah ID yang valid (ada di list)
        final foundById =
            nikList.where((nik) => nik.id == nikIdFromApi).toList();
        debugPrint('Found by ID ($nikIdFromApi): $foundById');

        if (foundById.isNotEmpty) {
          // Jika ID ditemukan langsung, gunakan itu
          selectedNikIdUpdate = nikIdFromApi;
          debugPrint('Using direct ID match: $selectedNikIdUpdate');
        } else {
          // Jika tidak ditemukan, berarti nikIdFromApi mungkin adalah NIK number
          // Cari ID berdasarkan NIK number
          try {
            final nikItem = nikList.firstWhere(
              (nik) => nik.nomorNik == nikIdFromApi.toString(),
            );
            selectedNikIdUpdate = nikItem.id;
            debugPrint(
                'Found by NIK number: ${nikItem.nomorNik} -> ID: ${nikItem.id}');
          } catch (e) {
            debugPrint('NIK not found for number: $nikIdFromApi');
            // Last attempt: cari berdasarkan NIK dari API response
            if (sktmListrikData['nik'] != null) {
              try {
                final nikFromResponse = sktmListrikData['nik'].toString();
                final nikItem = nikList.firstWhere(
                  (nik) => nik.nomorNik == nikFromResponse,
                );
                selectedNikIdUpdate = nikItem.id;
                debugPrint(
                    'Found by response NIK: $nikFromResponse -> ID: ${nikItem.id}');
              } catch (e2) {
                debugPrint('NIK not found by response NIK either');
                selectedNikIdUpdate = null;
              }
            } else {
              selectedNikIdUpdate = null;
            }
          }
        }
      } else {
        selectedNikIdUpdate = nikIdFromApi;
        debugPrint(
            'Using nikIdFromApi directly (no nikList): $selectedNikIdUpdate');
      }

      debugPrint('=== FINAL CHECK SEBELUM KIRIM ===');
      debugPrint(
          'selectedHubunganIdUpdate: $selectedHubunganIdUpdate (${selectedHubunganIdUpdate.runtimeType})');
      debugPrint(
          'selectedKelaminIdUpdate: $selectedKelaminIdUpdate (${selectedKelaminIdUpdate.runtimeType})');
      debugPrint(
          'selectedNikIdUpdate: $selectedNikIdUpdate (${selectedNikIdUpdate.runtimeType})');
      debugPrint(
          'namaControllerUpdate.text: "${namaControllerUpdate.text}" (${namaControllerUpdate.text.runtimeType})');
      debugPrint(
          'alamatControllerUpdate.text: "${alamatControllerUpdate.text}"');
      debugPrint(
          'namaPlnControllerUpdate.text: "${namaPlnControllerUpdate.text}"');
      debugPrint('umurControllerUpdate.text: "${umurControllerUpdate.text}"');
      debugPrint(
          'catatanControllerUpdate.text: "${catatanControllerUpdate.text}"');
      debugPrint(
          'selectedAgamaIdUpdate: $selectedAgamaIdUpdate (${selectedAgamaIdUpdate.runtimeType})');
      debugPrint(
          'selectedPekerjaanIdUpdate: $selectedPekerjaanIdUpdate (${selectedPekerjaanIdUpdate.runtimeType})');
      debugPrint(
          'selectedPenghasilanIdUpdate: $selectedPenghasilanIdUpdate (${selectedPenghasilanIdUpdate.runtimeType})');
      debugPrint(
          'selectedFileNameUpdate: $selectedFileNameUpdate (${selectedFileNameUpdate.runtimeType})');
      debugPrint(
          'selectedFileUpdate: $selectedFileUpdate (${selectedFileUpdate.runtimeType})');
      debugPrint(
          'selectedNikIndexUpdate: $selectedNikIndexUpdate (${selectedNikIndexUpdate.runtimeType})');
      debugPrint(
          'selectedNikIdUpdate: $selectedNikIdUpdate (${selectedNikIdUpdate.runtimeType})');
      debugPrint('=== END OF FINAL CHECK ===');

// Cek apakah ada yang null
      if (selectedHubunganIdUpdate == null)
        debugPrint('❌ selectedHubunganIdUpdate is NULL!');
      if (selectedKelaminIdUpdate == null)
        debugPrint('❌ selectedKelaminIdUpdate is NULL!');
      if (selectedNikIdUpdate == null)
        debugPrint('❌ selectedNikIdUpdate is NULL!');
      if (namaControllerUpdate.text == '')
        debugPrint('❌ namaControllerUpdate is EMPTY!');
      if (umurControllerUpdate.text == '')
        debugPrint('❌ umurControllerUpdate is EMPTY!');
      if (catatanControllerUpdate.text == '')
        debugPrint('❌ catatanControllerUpdate is EMPTY!');
      if (selectedAgamaIdUpdate == null)
        debugPrint('❌ selectedAgamaIdUpdate is NULL!');
      if (selectedPekerjaanIdUpdate == null)
        debugPrint('❌ selectedPekerjaanIdUpdate is NULL!');
      if (selectedPenghasilanIdUpdate == null)
        debugPrint('❌ selectedPenghasilanIdUpdate is NULL!');
      if (selectedFileNameUpdate == null)
        debugPrint('❌ selectedFileNameUpdate is NULL!');
      if (selectedFileUpdate == null)
        debugPrint('❌ selectedFileUpdate is NULL!');
      if (selectedNikIndexUpdate == null)
        debugPrint('❌ selectedNikIndexUpdate is NULL!');
      if (alamatControllerUpdate.text == '')
        debugPrint('❌ alamatControllerUpdate is EMPTY!');
      if (namaPlnControllerUpdate.text == '')
        debugPrint('❌ namaPlnControllerUpdate is EMPTY!');
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('Error filling form with existing data: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Future<int> updateForm(BuildContext context, String detailId) async {
    setLoading(true);

    try {
      // Debug: Print semua nilai sebelum validasi
      debugPrint('=== DEBUG UPDATE FORM ===');
      debugPrint('selectedHubunganIdUpdate: $selectedHubunganIdUpdate');
      debugPrint('selectedKelaminIdUpdate: $selectedKelaminIdUpdate');
      debugPrint('selectedPekerjaanIdUpdate: $selectedPekerjaanIdUpdate');
      debugPrint('selectedNikIdUpdate: $selectedNikIdUpdate');
      debugPrint('namaControllerUpdate.text: "${namaControllerUpdate.text}"');
      debugPrint(
          'alamatControllerUpdate.text: "${alamatControllerUpdate.text}"');
      debugPrint(
          'catatanControllerUpdate.text: "${catatanControllerUpdate.text}"');

      // Validasi dengan pesan error yang lebih spesifik
      List<String> missingFields = [];

      if (selectedHubunganIdUpdate == null)
        missingFields.add('Status dalam Keluarga');
      if (selectedKelaminIdUpdate == null) missingFields.add('Jenis Kelamin');
      if (selectedPenghasilanIdUpdate == null) missingFields.add('Penghasilan');
      if (selectedPekerjaanIdUpdate == null) missingFields.add('Pekerjaan');
      if (selectedAgamaIdUpdate == null) missingFields.add('Status Perkawinan');
      if (selectedNikIdUpdate == null) missingFields.add('NIK');
      if (namaControllerUpdate.text.trim().isEmpty)
        missingFields.add('Nama Lengkap');
      if (alamatControllerUpdate.text.trim().isEmpty)
        missingFields.add('Alamat');
      if (namaPlnControllerUpdate.text.trim().isEmpty)
        missingFields.add('Nama Usaha');
      if (umurControllerUpdate.text.trim().isEmpty) missingFields.add('Umur');
      if (selectedFileNameUpdate == null || selectedFileUpdate == null)
        missingFields.add('File KTP');
      if (missingFields.isNotEmpty) {
        throw Exception("Field yang belum diisi: ${missingFields.join(', ')}");
      }

      if (selectedFileUpdate == null || selectedFileUpdate!.bytes == null) {
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

      // PERBAIKAN UTAMA: Pastikan data tidak null dan tidak kosong
      final Map<String, String> data = {
        'kk_id': kkId.toString(),
        'nik_id': selectedNikIdUpdate?.toString() ?? '', // Ganti ini
        'nama': namaControllerUpdate.text,
        'umur': umurControllerUpdate.text,
        'alamat': alamatControllerUpdate.text,
        'nama_pln': namaPlnControllerUpdate.text,
        'hubungan': selectedHubunganIdUpdate?.toString() ?? '',
        'jk': selectedKelaminIdUpdate?.toString() ?? '',
        'agama': selectedAgamaIdUpdate?.toString() ?? '',
        'pekerjaan': selectedPekerjaanIdUpdate?.toString() ?? '',
        'penghasilan': selectedPenghasilanIdUpdate?.toString() ?? '',
      };

      // Debug: Print data yang akan dikirim
      debugPrint('=== DATA YANG AKAN DIKIRIM ===');
      data.forEach((key, value) {
        debugPrint('$key: "$value" (length: ${value.length})');
      });

      // VALIDASI FINAL: Cek apakah ada field required yang kosong
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
        'alamat',
        'nama_pln'
      ];

      final emptyRequiredFields = requiredFields
          .where((field) => !data.containsKey(field) || data[field]!.isEmpty)
          .toList();

      if (emptyRequiredFields.isNotEmpty) {
        debugPrint('❌ EMPTY REQUIRED FIELDS: $emptyRequiredFields');
        throw Exception(
            'Field required yang kosong: ${emptyRequiredFields.join(', ')}');
      }

      // PERBAIKAN: Gunakan POST dengan _method override atau PATCH
      // Beberapa server tidak support PUT untuk multipart
      final uri = Uri.parse('$baseUrl/sktm-listrik/$detailId');
      final request = http.MultipartRequest('POST', uri); // Ubah ke POST

      // Set headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // PENTING: Tambahkan _method untuk Laravel method spoofing
      request.fields['_method'] = 'PUT';

      // Add all fields
      request.fields.addAll(data);

      // Add file dengan nama field yang benar
      request.files.add(http.MultipartFile.fromBytes(
        'file_kk', // Pastikan nama field sesuai dengan API
        selectedFileUpdate!.bytes!,
        filename: selectedFileUpdate!.name,
      ));

      // Debug: Print semua fields yang dikirim
      debugPrint('=== REQUEST FIELDS FINAL ===');
      debugPrint('Total fields: ${request.fields.length}');
      debugPrint('Total files: ${request.files.length}');
      request.fields.forEach((key, value) {
        debugPrint('$key: "$value"');
      });
      request.files.forEach((file) {
        debugPrint(
            'File: ${file.field} - ${file.filename} (${file.length} bytes)');
      });

      final streamed =
          await request.send().timeout(const Duration(seconds: 30));
      final status = streamed.statusCode;
      final body = await streamed.stream.bytesToString();

      debugPrint('=== RESPONSE ===');
      debugPrint('STATUS: $status');
      debugPrint('BODY: $body');

      if (status == 200 || status == 201) {
        final json = jsonDecode(body);
        debugPrint('Success response: $json');
        return 1;
      } else {
        // Parse error response untuk debugging
        try {
          final errorJson = jsonDecode(body);
          final message = errorJson['message'] ?? 'Unknown error';
          final errors = errorJson['data'] ?? errorJson['errors'] ?? {};

          debugPrint('Error message: $message');
          debugPrint('Error details: $errors');

          throw Exception('$message - Details: $errors');
        } catch (parseError) {
          throw Exception('HTTP $status: $body');
        }
      }
    } catch (e, stackTrace) {
      debugPrint('Error in updateForm: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  void resetFormCreate() {
    namaControllerCreate.clear();
    nikControllerCreate.clear();
    alamatControllerCreate.clear();
    namaPlnControllerCreate.clear();
    catatanControllerCreate.clear();
    umurControllerCreate.clear();
    selectedHubunganIdCreate = null;
    selectedKelaminIdCreate = null;
    selectedPekerjaanIdCreate = null;
    selectedAgamaIdCreate = null;
    selectedFileCreate = null;
    selectedFileNameCreate = null;
    selectedNikIndexCreate = null;
    selectedNikIdCreate = null;
    selectedPenghasilanIdCreate = null;
    notifyListeners();
  }

  void resetFormUpdate() {
    namaControllerUpdate.clear();
    nikControllerUpdate.clear();
    alamatControllerUpdate.clear();
    namaPlnControllerUpdate.clear();
    umurControllerUpdate.clear();
    catatanControllerUpdate.clear();
    selectedAgamaIdUpdate = null;
    selectedHubunganIdUpdate = null;
    selectedKelaminIdUpdate = null;
    selectedPekerjaanIdUpdate = null;
    selectedPenghasilanIdUpdate = null;
    selectedFileUpdate = null;
    selectedFileNameUpdate = null;
    selectedNikIndexUpdate = null;
    selectedNikIdUpdate = null;
    selectedAgamaIdUpdate = null;
    notifyListeners();
  }

  void disposeControllers() {
    // Dispose CREATE controllers
    nikControllerCreate.dispose();
    namaControllerCreate.dispose();
    alamatControllerCreate.dispose();
    namaPlnControllerCreate.dispose();
    umurControllerCreate.dispose();
    selectedFileCreate = null;
    catatanControllerCreate.dispose();

    // Dispose UPDATE controllers
    nikControllerUpdate.dispose();
    selectedFileUpdate = null;
    selectedFileNameUpdate = null;
    namaControllerUpdate.dispose();
    alamatControllerUpdate.dispose();
    namaPlnControllerUpdate.dispose();
    umurControllerUpdate.dispose();
    catatanControllerUpdate.dispose();
  }
}
