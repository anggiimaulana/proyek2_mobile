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
import 'package:proyek2/data/models/informasi_umum/status_perkawinan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SkuProvider extends ChangeNotifier {
  // Controllers untuk CREATE
  final nikControllerCreate = TextEditingController();
  final namaControllerCreate = TextEditingController();
  final tempatLahirControllerCreate = TextEditingController();
  final tanggalLahirControllerCreate = TextEditingController();
  final alamatControllerCreate = TextEditingController();
  final namaUsahaCreate = TextEditingController();
  final catatanControllerCreate = TextEditingController();

  // Controllers untuk UPDATE
  final nikControllerUpdate = TextEditingController();
  final namaControllerUpdate = TextEditingController();
  final tempatLahirControllerUpdate = TextEditingController();
  final tanggalLahirControllerUpdate = TextEditingController();
  final alamatControllerUpdate = TextEditingController();
  final namaUsahaUpdate = TextEditingController();
  final catatanControllerUpdate = TextEditingController();

  // Selected values untuk CREATE
  int? selectedHubunganIdCreate;
  int? selectedKelaminIdCreate;
  int? selectedPekerjaanIdCreate;
  int? selectedStatusIdCreate;
  int? selectedNikIndexCreate;
  int? selectedNikIdCreate;
  DateTime? selectedDateCreate;
  PlatformFile? selectedFileCreate;
  String? selectedFileNameCreate;

  // Selected values untuk UPDATE
  int? selectedHubunganIdUpdate;
  int? selectedKelaminIdUpdate;
  int? selectedPekerjaanIdUpdate;
  int? selectedStatusIdUpdate;
  int? selectedNikIndexUpdate;
  int? selectedNikIdUpdate;
  DateTime? selectedDateUpdate;
  PlatformFile? selectedFileUpdate;
  String? selectedFileNameUpdate;

  final baseUrl = ApiServices.baseUrl;
  bool isLoading = false;
  List<NikHive> nikDataList = [];

  // Getters untuk mendapatkan controller yang tepat berdasarkan mode
  TextEditingController nikController(bool isUpdate) =>
      isUpdate ? nikControllerUpdate : nikControllerCreate;
  TextEditingController namaController(bool isUpdate) =>
      isUpdate ? namaControllerUpdate : namaControllerCreate;
  TextEditingController tempatLahirController(bool isUpdate) =>
      isUpdate ? tempatLahirControllerUpdate : tempatLahirControllerCreate;
  TextEditingController tanggalLahirController(bool isUpdate) =>
      isUpdate ? tanggalLahirControllerUpdate : tanggalLahirControllerCreate;
  TextEditingController alamatController(bool isUpdate) =>
      isUpdate ? alamatControllerUpdate : alamatControllerCreate;
  TextEditingController namaUsaha(bool isUpdate) =>
      isUpdate ? namaUsahaUpdate : namaUsahaCreate;
  TextEditingController catatanController(bool isUpdate) =>
      isUpdate ? catatanControllerUpdate : catatanControllerCreate;

  // Getters untuk selected values
  int? selectedHubunganId(bool isUpdate) =>
      isUpdate ? selectedHubunganIdUpdate : selectedHubunganIdCreate;
  int? selectedKelaminId(bool isUpdate) =>
      isUpdate ? selectedKelaminIdUpdate : selectedKelaminIdCreate;
  int? selectedPekerjaanId(bool isUpdate) =>
      isUpdate ? selectedPekerjaanIdUpdate : selectedPekerjaanIdCreate;
  int? selectedStatusId(bool isUpdate) =>
      isUpdate ? selectedStatusIdUpdate : selectedStatusIdCreate;
  int? selectedNikIndex(bool isUpdate) =>
      isUpdate ? selectedNikIndexUpdate : selectedNikIndexCreate;
  int? selectedNikId(bool isUpdate) =>
      isUpdate ? selectedNikIdUpdate : selectedNikIdCreate;
  DateTime? selectedDate(bool isUpdate) =>
      isUpdate ? selectedDateUpdate : selectedDateCreate;
  PlatformFile? selectedFile(bool isUpdate) =>
      isUpdate ? selectedFileUpdate : selectedFileCreate;
  String? selectedFileName(bool isUpdate) =>
      isUpdate ? selectedFileNameUpdate : selectedFileNameCreate;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setNikDataList(List<NikHive> data) {
    nikDataList = data;
    notifyListeners();
  }

  // Setters untuk CREATE
  void setSelectedHubunganIdCreate(int? value) {
    selectedHubunganIdCreate = value;
    notifyListeners();
  }

  void setSelectedKelaminIdCreate(int? value) {
    selectedKelaminIdCreate = value;
    notifyListeners();
  }

  void setSelectedPekerjaanIdCreate(int? value) {
    selectedPekerjaanIdCreate = value;
    notifyListeners();
  }

  void setSelectedStatusIdCreate(int? value) {
    selectedStatusIdCreate = value;
    notifyListeners();
  }

  // Setters untuk UPDATE
  void setSelectedHubunganIdUpdate(int? value) {
    selectedHubunganIdUpdate = value;
    notifyListeners();
  }

  void setSelectedKelaminIdUpdate(int? value) {
    selectedKelaminIdUpdate = value;
    notifyListeners();
  }

  void setSelectedPekerjaanIdUpdate(int? value) {
    selectedPekerjaanIdUpdate = value;
    notifyListeners();
  }

  void setSelectedStatusIdUpdate(int? value) {
    selectedStatusIdUpdate = value;
    notifyListeners();
  }

  // Method untuk mengatur NIK yang dipilih (CREATE)
  void setSelectedNikCreate(int index, int id, NikHive anggota,
      {required List<Datum> jkList,
      required List<StatusPerkawinanData> statusList,
      required List<PekerjaanData> pekerjaanList}) {
    selectedNikIndexCreate = index;
    selectedNikIdCreate = id;

    nikControllerCreate.text = anggota.nomorNik;
    namaControllerCreate.text = anggota.name;
    alamatControllerCreate.text = anggota.alamat;
    tempatLahirControllerCreate.text = anggota.tempatLahir;
    tanggalLahirControllerCreate.text =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(anggota.tanggalLahir));
    selectedHubunganIdCreate = anggota.hubungan;
    selectedKelaminIdCreate = anggota.jk;
    selectedPekerjaanIdCreate = anggota.pekerjaan;
    selectedStatusIdCreate = anggota.status;
    notifyListeners();
  }

  // Method untuk mengatur NIK yang dipilih (UPDATE)
  void setSelectedNikUpdate(int index, int id, NikHive anggota,
      {required List<Datum> jkList,
      required List<StatusPerkawinanData> statusList,
      required List<PekerjaanData> pekerjaanList}) {
    selectedNikIndexUpdate = index;
    selectedNikIdUpdate = id;

    nikControllerUpdate.text = anggota.nomorNik;
    namaControllerUpdate.text = anggota.name;
    alamatControllerUpdate.text = anggota.alamat;
    tempatLahirControllerUpdate.text = anggota.tempatLahir;
    tanggalLahirControllerUpdate.text =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(anggota.tanggalLahir));
    selectedHubunganIdUpdate = anggota.hubungan;
    selectedKelaminIdUpdate = anggota.jk;
    selectedPekerjaanIdUpdate = anggota.pekerjaan;
    selectedStatusIdUpdate = anggota.status;
    notifyListeners();
  }

  Future<String?> _getKkId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('kk_id')?.toString();
  }

  Future<void> pickKKFileCreate(BuildContext context) async {
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

      if (file.size > 100 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ukuran file tidak boleh lebih dari 100MB'),
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

  Future<void> selectDateCreate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateCreate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDateCreate) {
      selectedDateCreate = picked;
      tanggalLahirControllerCreate.text =
          DateFormat('yyyy-MM-dd').format(picked);
      notifyListeners();
    }
  }

  Future<void> selectDateUpdate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateUpdate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDateUpdate) {
      selectedDateUpdate = picked;
      tanggalLahirControllerUpdate.text =
          DateFormat('yyyy-MM-dd').format(picked);
      notifyListeners();
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // CREATE form submission
  Future<int> submitFormCreate(BuildContext context) async {
    setLoading(true);

    try {
      if (selectedHubunganIdCreate == null ||
          selectedKelaminIdCreate == null ||
          selectedNikIndexCreate == null ||
          selectedPekerjaanIdCreate == null ||
          selectedStatusIdCreate == null) {
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
        'hubungan': selectedHubunganIdCreate,
        'kk_id': prefs.getInt('kk_id'),
        'nik_id': selectedNikIdCreate,
        'nama': namaControllerCreate.text,
        'tempat_lahir': tempatLahirControllerCreate.text,
        'tanggal_lahir': tanggalLahirControllerCreate.text,
        'jk': selectedKelaminIdCreate,
        'pekerjaan': selectedPekerjaanIdCreate,
        'status_perkawinan': selectedStatusIdCreate,
        'nama_usaha': namaUsahaCreate.text,
        'alamat': alamatControllerCreate.text,
      };

      final uri = Uri.parse('$baseUrl/sku');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields.addAll(data.map((k, v) => MapEntry(k, v.toString())))
        ..files.add(http.MultipartFile.fromBytes(
          'file_ktp',
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

  // Method untuk mengambil data SKU berdasarkan detail_id
  Future<Map<String, dynamic>?> fetchSkuById(String detailId) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login ulang.');
      }

      final uri = Uri.parse('$baseUrl/sku/$detailId');
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

// Method untuk mengisi form UPDATE dengan data yang sudah ada
  // Perbaikan di fillFormWithExistingDataUpdate method

  void fillFormWithExistingDataUpdate({
    required Map<String, dynamic> skuData,
    required List<Datum> jkList,
    required List<PekerjaanData> pekerjaanList,
    required List<StatusPerkawinanData> statusList,
    required List<HubunganData> hubunganList,
    List<NikHive>? nikList,
  }) {
    try {
      debugPrint('=== FILLING FORM WITH EXISTING DATA ===');
      debugPrint('Raw skuData: $skuData');

      // Fill text controllers untuk UPDATE - dengan null safety
      namaControllerUpdate.text = skuData['nama']?.toString().trim() ?? '';
      tempatLahirControllerUpdate.text =
          skuData['tempat_lahir']?.toString().trim() ?? '';
      alamatControllerUpdate.text = skuData['alamat']?.toString().trim() ?? '';
      namaUsahaUpdate.text = skuData['nama_usaha']?.toString().trim() ?? '';
      catatanControllerUpdate.text =
          skuData['catatan']?.toString().trim() ?? '';

      // Set NIK text (kalau ada)
      if (skuData['nik'] != null) {
        nikControllerUpdate.text = skuData['nik'].toString().trim();
      }

      // Set tanggal lahir untuk UPDATE
      if (skuData['tanggal_lahir'] != null) {
        try {
          final dateStr = skuData['tanggal_lahir'].toString();
          final date = DateTime.parse(dateStr);
          selectedDateUpdate = date;
          tanggalLahirControllerUpdate.text =
              DateFormat('yyyy-MM-dd').format(date);
          debugPrint(
              'Date set: $dateStr -> ${tanggalLahirControllerUpdate.text}');
        } catch (e) {
          debugPrint('Error parsing date: $e');
        }
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
        skuData['hubungan']?.toString(),
        (item) => item.jenisHubungan,
        (item) => item.id,
      );
      debugPrint('selectedHubunganIdUpdate: $selectedHubunganIdUpdate');

      selectedKelaminIdUpdate = findIdByName(
        jkList,
        skuData['jk']?.toString(),
        (item) => item.jenisKelamin,
        (item) => item.id,
      );
      debugPrint('selectedKelaminIdUpdate: $selectedKelaminIdUpdate');

      selectedPekerjaanIdUpdate = findIdByName(
        pekerjaanList,
        skuData['pekerjaan']?.toString(),
        (item) => item.namaPekerjaan,
        (item) => item.id,
      );
      debugPrint('selectedPekerjaanIdUpdate: $selectedPekerjaanIdUpdate');

      selectedStatusIdUpdate = findIdByName(
        statusList,
        skuData['status_perkawinan']?.toString(),
        (item) => item.statusPerkawinan,
        (item) => item.id,
      );
      debugPrint('selectedStatusIdUpdate: $selectedStatusIdUpdate');

      // PERBAIKAN: NIK ID mapping dengan logging
      final nikIdFromApi = extractId(skuData['nik_id']);
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
            if (skuData['nik'] != null) {
              try {
                final nikFromResponse = skuData['nik'].toString();
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
          'tempatLahirControllerUpdate.text: "${tempatLahirControllerUpdate.text}"');
      debugPrint(
          'alamatControllerUpdate.text: "${alamatControllerUpdate.text}"');
      debugPrint('namaUsahaUpdate.text: "${namaUsahaUpdate.text}"');

// Cek apakah ada yang null
      if (selectedHubunganIdUpdate == null)
        debugPrint('❌ selectedHubunganIdUpdate is NULL!');
      if (selectedKelaminIdUpdate == null)
        debugPrint('❌ selectedKelaminIdUpdate is NULL!');
      if (selectedNikIdUpdate == null)
        debugPrint('❌ selectedNikIdUpdate is NULL!');
      if (namaControllerUpdate.text == '')
        debugPrint('❌ namaControllerUpdate is EMPTY!');
      if (tempatLahirControllerUpdate.text == '')
        debugPrint('❌ tempatLahirControllerUpdate is EMPTY!');
      if (alamatControllerUpdate.text == '')
        debugPrint('❌ alamatControllerUpdate is EMPTY!');
      if (namaUsahaUpdate.text == '') debugPrint('❌ namaUsahaUpdate is EMPTY!');
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('Error filling form with existing data: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  void setSelectedNikIdUpdate(int? value) {
    selectedNikIdUpdate = value;
    notifyListeners();
  }

  // UPDATE form submission
  // UPDATE form submission - FIXED VERSION
  Future<int> updateForm(BuildContext context, String detailId) async {
    setLoading(true);

    try {
      // Debug: Print semua nilai sebelum validasi
      debugPrint('=== DEBUG UPDATE FORM ===');
      debugPrint('selectedHubunganIdUpdate: $selectedHubunganIdUpdate');
      debugPrint('selectedKelaminIdUpdate: $selectedKelaminIdUpdate');
      debugPrint('selectedPekerjaanIdUpdate: $selectedPekerjaanIdUpdate');
      debugPrint('selectedStatusIdUpdate: $selectedStatusIdUpdate');
      debugPrint('selectedNikIdUpdate: $selectedNikIdUpdate');
      debugPrint('namaControllerUpdate.text: "${namaControllerUpdate.text}"');
      debugPrint(
          'tempatLahirControllerUpdate.text: "${tempatLahirControllerUpdate.text}"');
      debugPrint(
          'tanggalLahirControllerUpdate.text: "${tanggalLahirControllerUpdate.text}"');
      debugPrint(
          'alamatControllerUpdate.text: "${alamatControllerUpdate.text}"');
      debugPrint('namaUsahaUpdate.text: "${namaUsahaUpdate.text}"');
      debugPrint(
          'catatanControllerUpdate.text: "${catatanControllerUpdate.text}"');

      // Validasi dengan pesan error yang lebih spesifik
      List<String> missingFields = [];

      if (selectedHubunganIdUpdate == null)
        missingFields.add('Status dalam Keluarga');
      if (selectedKelaminIdUpdate == null) missingFields.add('Jenis Kelamin');
      if (selectedPekerjaanIdUpdate == null) missingFields.add('Pekerjaan');
      if (selectedStatusIdUpdate == null)
        missingFields.add('Status Perkawinan');
      if (selectedNikIdUpdate == null) missingFields.add('NIK');
      if (namaControllerUpdate.text.trim().isEmpty)
        missingFields.add('Nama Lengkap');
      if (tempatLahirControllerUpdate.text.trim().isEmpty)
        missingFields.add('Tempat Lahir');
      if (tanggalLahirControllerUpdate.text.trim().isEmpty)
        missingFields.add('Tanggal Lahir');
      if (alamatControllerUpdate.text.trim().isEmpty)
        missingFields.add('Alamat');
      if (namaUsahaUpdate.text.trim().isEmpty) missingFields.add('Nama Usaha');

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
        'hubungan': selectedHubunganIdUpdate?.toString() ?? '',
        'kk_id': kkId.toString(),
        'nik_id': selectedNikIdUpdate?.toString() ?? '',
        'nama': namaControllerUpdate.text.trim(),
        'tempat_lahir': tempatLahirControllerUpdate.text.trim(),
        'tanggal_lahir': tanggalLahirControllerUpdate.text.trim(),
        'jk': selectedKelaminIdUpdate?.toString() ?? '',
        'pekerjaan': selectedPekerjaanIdUpdate?.toString() ?? '',
        'status_perkawinan': selectedStatusIdUpdate?.toString() ?? '',
        'nama_usaha': namaUsahaUpdate.text.trim(),
        'alamat': alamatControllerUpdate.text.trim(),
        // Tambahkan catatan jika ada
        // if (catatanControllerUpdate.text.trim().isNotEmpty)
        //   'catatan': catatanControllerUpdate.text.trim(),
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
        'tempat_lahir',
        'tanggal_lahir',
        'jk',
        'status_perkawinan',
        'pekerjaan',
        'alamat',
        'nama_usaha'
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
      final uri = Uri.parse('$baseUrl/sku/$detailId');
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
        'file_ktp', // Pastikan nama field sesuai dengan API
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
    tempatLahirControllerCreate.clear();
    tanggalLahirControllerCreate.clear();
    alamatControllerCreate.clear();
    namaUsahaCreate.clear();
    catatanControllerCreate.clear();
    selectedHubunganIdCreate = null;
    selectedKelaminIdCreate = null;
    selectedPekerjaanIdCreate = null;
    selectedStatusIdCreate = null;
    selectedFileCreate = null;
    selectedFileNameCreate = null;
    selectedNikIndexCreate = null;
    selectedNikIdCreate = null;
    selectedDateCreate = null;
    notifyListeners();
  }

  void resetFormUpdate() {
    namaControllerUpdate.clear();
    nikControllerUpdate.clear();
    tempatLahirControllerUpdate.clear();
    tanggalLahirControllerUpdate.clear();
    alamatControllerUpdate.clear();
    namaUsahaUpdate.clear();
    catatanControllerUpdate.clear();
    selectedHubunganIdUpdate = null;
    selectedKelaminIdUpdate = null;
    selectedPekerjaanIdUpdate = null;
    selectedStatusIdUpdate = null;
    selectedFileUpdate = null;
    selectedFileNameUpdate = null;
    selectedNikIndexUpdate = null;
    selectedNikIdUpdate = null;
    selectedDateUpdate = null;
    notifyListeners();
  }

  void disposeControllers() {
    // Dispose CREATE controllers
    nikControllerCreate.dispose();
    namaControllerCreate.dispose();
    tempatLahirControllerCreate.dispose();
    tanggalLahirControllerCreate.dispose();
    alamatControllerCreate.dispose();
    namaUsahaCreate.dispose();
    catatanControllerCreate.dispose();

    // Dispose UPDATE controllers
    nikControllerUpdate.dispose();
    selectedFileUpdate = null;
    selectedFileNameUpdate = null;
    namaControllerUpdate.dispose();
    tempatLahirControllerUpdate.dispose();
    tanggalLahirControllerUpdate.dispose();
    alamatControllerUpdate.dispose();
    namaUsahaUpdate.dispose();
    catatanControllerUpdate.dispose();
  }
}
