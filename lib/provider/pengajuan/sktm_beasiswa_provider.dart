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

class SktmBeasiswaProvider extends ChangeNotifier {
  // create
  final nikControllerCreate = TextEditingController();
  final tempatLahirControllerCreate = TextEditingController();
  final sukuControllerCreate = TextEditingController();
  final namaAnakControllerCreate = TextEditingController();
  final namaAyahControllerCreate = TextEditingController();
  final namaIbuControllerCreate = TextEditingController();
  final alamatControllerCreate = TextEditingController();
  final tanggalLahirControllerCreate = TextEditingController();
  final catatanControllerCreate = TextEditingController();

  int? selectedHubunganIdCreate;
  int? selectedKelaminIdCreate;
  int? selectedAgamaIdCreate;
  int? selectedPekerjaanOrtuIdCreate;
  int? selectedPekerjaanAnakIdCreate;
  int? selectedNikIndexCreate;
  int? selectedNikIdCreate;
  DateTime? selectedDateCreate;
  PlatformFile? selectedFileCreate;
  String? selectedFileNameCreate;

  // create
  final nikControllerUpdate = TextEditingController();
  final tempatLahirControllerUpdate = TextEditingController();
  final sukuControllerUpdate = TextEditingController();
  final namaAnakControllerUpdate = TextEditingController();
  final namaAyahControllerUpdate = TextEditingController();
  final namaIbuControllerUpdate = TextEditingController();
  final alamatControllerUpdate = TextEditingController();
  final tanggalLahirControllerUpdate = TextEditingController();
  final catatanControllerUpdate = TextEditingController();

  int? selectedHubunganIdUpdate;
  int? selectedKelaminIdUpdate;
  int? selectedAgamaIdUpdate;
  int? selectedPekerjaanOrtuIdUpdate;
  int? selectedPekerjaanAnakIdUpdate;
  int? selectedNikIndexUpdate;
  int? selectedNikIdUpdate;
  DateTime? selectedDateUpdate;
  PlatformFile? selectedFileUpdate;
  String? selectedFileNameUpdate;

  final baseUrl = ApiServices.baseUrl;

  bool isLoading = false;

  List<NikHive> nikDataList = [];

  // Getters untuk current mode (update/create)
  TextEditingController nikController(bool isUpdate) =>
      isUpdate ? nikControllerUpdate : nikControllerCreate;
  TextEditingController namaAnakController(bool isUpdate) =>
      isUpdate ? namaAnakControllerUpdate : namaAnakControllerCreate;
  TextEditingController namaAyahController(bool isUpdate) =>
      isUpdate ? namaAyahControllerUpdate : namaAnakControllerCreate;
  TextEditingController namaIbuController(bool isUpdate) =>
      isUpdate ? namaIbuControllerUpdate : namaIbuControllerCreate;
  TextEditingController tempatLahirController(bool isUpdate) =>
      isUpdate ? tempatLahirControllerUpdate : tempatLahirControllerCreate;
  TextEditingController tanggalLahirController(bool isUpdate) =>
      isUpdate ? tanggalLahirControllerUpdate : tanggalLahirControllerCreate;
  TextEditingController alamatController(bool isUpdate) =>
      isUpdate ? alamatControllerUpdate : alamatControllerCreate;
  TextEditingController catatanController(bool isUpdate) =>
      isUpdate ? catatanControllerUpdate : catatanControllerCreate;
  TextEditingController sukuController(bool isUpdate) =>
      isUpdate ? sukuControllerUpdate : sukuControllerCreate;
  int? selectedHubunganId(bool isUpdate) =>
      isUpdate ? selectedHubunganIdUpdate : selectedHubunganIdCreate;
  int? selectedKelaminId(bool isUpdate) =>
      isUpdate ? selectedKelaminIdUpdate : selectedKelaminIdCreate;
  int? selectedAgamaId(bool isUpdate) =>
      isUpdate ? selectedAgamaIdUpdate : selectedAgamaIdCreate;
  int? selectedPekerjaanAnakId(bool isUpdate) =>
      isUpdate ? selectedPekerjaanAnakIdUpdate : selectedPekerjaanAnakIdCreate;
  int? selectedPekerjaanOrtuId(bool isUpdate) =>
      isUpdate ? selectedPekerjaanOrtuIdUpdate : selectedPekerjaanOrtuIdCreate;
  int? selectedNikId(bool isUpdate) =>
      isUpdate ? selectedNikIdUpdate : selectedNikIdCreate;
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

  void setSelectedPekerjaanAnakIdCreate(int? value) {
    selectedPekerjaanAnakIdCreate = value;
    notifyListeners();
  }

  void setSelectedPekerjaanOrtuIdCreate(int? value) {
    selectedPekerjaanOrtuIdCreate = value;
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

  void setSelectedPekerjaanAnakIdUpdate(int? value) {
    selectedPekerjaanAnakIdUpdate = value;
    notifyListeners();
  }

  void setSelectedPekerjaanOrtuIdUpdate(int? value) {
    selectedPekerjaanOrtuIdUpdate = value;
    notifyListeners();
  }

  void setSelectedNikCreate(int index, int id, NikHive anggota,
      {required List<AgamaData> agamaList,
      required List<Datum> jkList,
      required List<PekerjaanData> pekerjaanList}) {
    selectedNikIndexCreate = index;
    selectedNikIdCreate = id;

    // Set data text field
    nikControllerCreate.text = anggota.nomorNik;
    namaAnakControllerCreate.text = anggota.name;
    alamatControllerCreate.text = anggota.alamat;
    tempatLahirControllerCreate.text = anggota.tempatLahir;
    tanggalLahirControllerCreate.text =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(anggota.tanggalLahir));
    selectedAgamaIdCreate = anggota.agama;
    selectedHubunganIdCreate = anggota.hubungan;
    selectedKelaminIdCreate = anggota.jk;
    selectedPekerjaanAnakIdCreate = anggota.pekerjaan;

    notifyListeners();
  }

  void setSelectedNikUpdate(int index, int id, NikHive anggota,
      {required List<AgamaData> agamaList,
      required List<Datum> jkList,
      required List<PekerjaanData> pekerjaanList}) {
    selectedNikIndexCreate = index;
    selectedNikIdCreate = id;

    // Set data text field
    nikControllerUpdate.text = anggota.nomorNik;
    namaAnakControllerUpdate.text = anggota.name;
    alamatControllerUpdate.text = anggota.alamat;
    tempatLahirControllerUpdate.text = anggota.tempatLahir;
    tanggalLahirControllerUpdate.text =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(anggota.tanggalLahir));
    selectedAgamaIdUpdate = anggota.agama;
    selectedHubunganIdUpdate = anggota.hubungan;
    selectedKelaminIdUpdate = anggota.jk;
    selectedPekerjaanAnakIdUpdate = anggota.pekerjaan;

    notifyListeners();
  }

  // void setSelectedNikIndexCreate(int index, int id) {
  //   selectedNikIndexCreate = index;
  //   selectedNikIdCreate = id;
  //   notifyListeners();
  // }

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

  void setSelectedNik(int index, int id, NikHive anggota,
      {required List<AgamaData> agamaList,
      required List<HubunganData> hubunganList,
      required List<Datum> jkList,
      required List<PekerjaanData> pekerjaanList}) {
    selectedNikIndexCreate = index;
    selectedNikIdCreate = id;

    // Find matching data berdasarkan NIK anggota
    AgamaData? matchingAgama;
    Datum? matchingJk;
    PekerjaanData? matchingPekerjaan;
    HubunganData? matchingHubungan;

    // Cari agama yang sesuai
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

    // Cari jenis kelamin yang sesuai
    try {
      matchingJk = jkList.firstWhere(
        (jk) =>
            jk.id == anggota.jk || jk.jenisKelamin.toLowerCase() == anggota.jk,
      );
    } catch (e) {
      matchingJk = null;
    }

    // Cari pekerjaan yang sesuai (jika ada data pekerjaan di NikHive)
    try {
      matchingPekerjaan = pekerjaanList.firstWhere(
        (pekerjaan) =>
            pekerjaan.id == anggota.pekerjaan ||
            pekerjaan.namaPekerjaan.toLowerCase() == anggota.pekerjaan,
      );
    } catch (e) {
      matchingPekerjaan = null;
    }

    // Fill form dengan data yang ditemukan
    fillDataFromKartuKeluarga(anggota, matchingAgama, matchingJk,
        matchingPekerjaan, matchingHubungan);

    notifyListeners();
  }

  void fillDataFromKartuKeluarga(NikHive nikData, AgamaData? agama, Datum? jk,
      PekerjaanData? pekerjaan, HubunganData? hubungan) {
    // Fill text controllers
    nikControllerCreate.text = nikData.nomorNik;
    namaAnakControllerCreate.text = nikData.name;
    alamatControllerCreate.text = nikData.alamat;

    // Set dropdown values

    selectedKelaminIdCreate = jk?.id;
    selectedAgamaIdCreate = agama?.id;
    selectedPekerjaanAnakIdCreate = pekerjaan?.id;
    selectedHubunganIdCreate = hubungan?.id;

    // Parse tanggal jika perlu
    if (nikData.tanggalLahir.isNotEmpty) {
      try {
        selectedDateCreate =
            DateFormat('yyyy-MM-dd').parse(nikData.tanggalLahir);
      } catch (e) {
        // If parsing fails, try other common formats
        try {
          selectedDateCreate =
              DateFormat('dd/MM/yyyy').parse(nikData.tanggalLahir);
          tanggalLahirControllerCreate.text =
              DateFormat('yyyy-MM-dd').format(selectedDateCreate!);
        } catch (e2) {
          print('Error parsing date: $e2');
        }
      }
    }

    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
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
    if (tanggalLahirControllerCreate.text.isEmpty) {
      throw Exception("Tanggal lahir belum diisi.");
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
          selectedPekerjaanAnakIdCreate == null ||
          selectedPekerjaanOrtuIdCreate == null) {
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
        'nama_anak': namaAnakControllerCreate.text,
        'tempat_lahir': tempatLahirControllerCreate.text,
        'tanggal_lahir': tanggalLahirControllerCreate.text,
        'jk': selectedKelaminIdCreate,
        'suku': sukuControllerCreate.text,
        'agama': selectedAgamaIdCreate,
        'pekerjaan_anak': selectedPekerjaanAnakIdCreate,
        'nama': namaAyahControllerCreate.text,
        'nama_ibu': namaIbuControllerCreate.text,
        'pekerjaan_ortu': selectedPekerjaanOrtuIdCreate,
        'alamat': alamatControllerCreate.text,
      };

      final uri = Uri.parse('$baseUrl/sktm-beasiswa');
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
      setLoading(false); // ⬅️ SELESAI loading (berhasil/gagal tetap off)
    }
  }

  Future<Map<String, dynamic>?> fetchSktmBeasiswaById(String detailId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null || token.isEmpty)
        throw Exception('Token tidak ditemukan');
      final uri = Uri.parse('$baseUrl/sktm-beasiswa/$detailId');
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['data'];
      } else {
        debugPrint('Failed to fetch data: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      return null;
    }
  }

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
    required Map<String, dynamic> sktmListrik,
    required List<Datum> jkList,
    required List<PekerjaanData> pekerjaanList,
    required List<AgamaData> agamaList,
    required List<HubunganData> hubunganList,
    List<NikHive>? nikList,
  }) {
    try {
      debugPrint('=== FILLING FORM WITH EXISTING DATA ===');
      debugPrint('Raw sktmListrik: $sktmListrik');

      // Fill text controllers untuk UPDATE - dengan null safety
      namaAyahControllerUpdate.text =
          sktmListrik['nama']?.toString().trim() ?? '';
      namaIbuControllerUpdate.text =
          sktmListrik['nama_ibu']?.toString().trim() ?? '';
      namaAnakControllerUpdate.text =
          sktmListrik['nama_anak']?.toString().trim() ?? '';
      tempatLahirControllerUpdate.text =
          sktmListrik['tempat_lahir']?.toString().trim() ?? '';
      alamatControllerUpdate.text =
          sktmListrik['alamat']?.toString().trim() ?? '';
      sukuControllerUpdate.text = sktmListrik['suku']?.toString().trim() ?? '';
      catatanControllerUpdate.text =
          sktmListrik['catatan']?.toString().trim() ?? '';

      // Set NIK text (kalau ada)
      if (sktmListrik['nik'] != null) {
        nikControllerUpdate.text = sktmListrik['nik'].toString().trim();
      }

      // Set tanggal lahir untuk UPDATE
      if (sktmListrik['tanggal_lahir'] != null) {
        try {
          final dateStr = sktmListrik['tanggal_lahir'].toString();
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
        sktmListrik['hubungan']?.toString(),
        (item) => item.jenisHubungan,
        (item) => item.id,
      );
      debugPrint('selectedHubunganIdUpdate: $selectedHubunganIdUpdate');

      selectedKelaminIdUpdate = findIdByName(
        jkList,
        sktmListrik['jk']?.toString(),
        (item) => item.jenisKelamin,
        (item) => item.id,
      );
      debugPrint('selectedKelaminIdUpdate: $selectedKelaminIdUpdate');

      selectedPekerjaanAnakIdUpdate = findIdByName(
        pekerjaanList,
        sktmListrik['pekerjaan_anak']?.toString(),
        (item) => item.namaPekerjaan,
        (item) => item.id,
      );
      debugPrint('selectedPekerjaanIdUpdate: $selectedPekerjaanAnakIdUpdate');

      selectedPekerjaanOrtuIdUpdate = findIdByName(
        pekerjaanList,
        sktmListrik['pekerjaan_ortu']?.toString(),
        (item) => item.namaPekerjaan,
        (item) => item.id,
      );
      debugPrint('selectedPekerjaanIdUpdate: $selectedPekerjaanOrtuIdUpdate');

      selectedAgamaIdUpdate = findIdByName(
        agamaList,
        sktmListrik['agama']?.toString(),
        (item) => item.namaAgama,
        (item) => item.id,
      );
      debugPrint('selectedAgamaIdUpdate: $selectedAgamaIdUpdate');

      // PERBAIKAN: NIK ID mapping dengan logging
      final nikIdFromApi = extractId(sktmListrik['nik_id']);
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
            if (sktmListrik['nik'] != null) {
              try {
                final nikFromResponse = sktmListrik['nik'].toString();
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
          'namaControllerUpdate.text: "${namaAyahControllerUpdate.text}" (${namaAyahControllerUpdate.text.runtimeType})');
      debugPrint(
          'namaControllerUpdate.text: "${namaIbuControllerUpdate.text}" (${namaIbuControllerUpdate.text.runtimeType})');
      debugPrint(
          'namaControllerUpdate.text: "${namaAnakControllerUpdate.text}" (${namaAnakControllerUpdate.text.runtimeType})');
      debugPrint(
          'tempatLahirControllerUpdate.text: "${tempatLahirControllerUpdate.text}"');
      debugPrint(
          'alamatControllerUpdate.text: "${alamatControllerUpdate.text}"');
      debugPrint(
          'tanggalLahirControllerUpdate.text: "${tanggalLahirControllerUpdate.text}"');
      debugPrint('sukuControllerUpdate.text: "${sukuControllerUpdate.text}"');
      debugPrint(
          'selectedAgamaIdUpdate: $selectedAgamaIdUpdate (${selectedAgamaIdUpdate.runtimeType})');
      debugPrint(
          'selectedPekerjaanAnakIdUpdate: $selectedPekerjaanAnakIdUpdate (${selectedPekerjaanAnakIdUpdate.runtimeType})');
      debugPrint(
          'selectedPekerjaanOrtuIdUpdate: $selectedPekerjaanOrtuIdUpdate (${selectedPekerjaanOrtuIdUpdate.runtimeType})');
      debugPrint(
          'selectedFileNameUpdate: $selectedFileNameUpdate (${selectedFileNameUpdate.runtimeType})');
      debugPrint(
          'selectedFileUpdate: ${selectedFileUpdate?.name} (${selectedFileUpdate?.bytes?.length ?? 0} bytes)');

// Cek apakah ada yang null
      // if (selectedHubunganIdUpdate == null)
      //   debugPrint('❌ selectedHubunganIdUpdate is NULL!');
      // if (selectedKelaminIdUpdate == null)
      //   debugPrint('❌ selectedKelaminIdUpdate is NULL!');
      // if (selectedNikIdUpdate == null)
      //   debugPrint('❌ selectedNikIdUpdate is NULL!');
      // if (namaControllerUpdate.text == '')
      //   debugPrint('❌ namaControllerUpdate is EMPTY!');
      // if (tempatLahirControllerUpdate.text == '')
      //   debugPrint('❌ tempatLahirControllerUpdate is EMPTY!');
      // if (alamatControllerUpdate.text == '')
      //   debugPrint('❌ alamatControllerUpdate is EMPTY!');
      // if (namaUsahaUpdate.text == '') debugPrint('❌ namaUsahaUpdate is EMPTY!');
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('Error filling form with existing data: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Future<int> updateForm(BuildContext context, String detailId) async {
    setLoading(true);
    try {
      // Validasi
      if (selectedNikIdUpdate == null ||
          selectedHubunganIdUpdate == null ||
          selectedKelaminIdUpdate == null ||
          selectedAgamaIdUpdate == null ||
          selectedPekerjaanOrtuIdUpdate == null ||
          selectedPekerjaanAnakIdUpdate == null) {
        throw Exception("Mohon lengkapi semua data dropdown dengan benar.");
      }
      if (selectedFileUpdate == null || selectedFileUpdate!.bytes == null) {
        throw Exception("File KK belum dipilih.");
      }
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final kkId = prefs.getInt('kk_id');
      if (token == null || kkId == null) throw Exception("Login ulang!");

      final Map<String, String> data = {
        'hubungan': selectedHubunganIdUpdate.toString(),
        'kk_id': kkId.toString(),
        'nik_id': selectedNikIdUpdate.toString(),
        'nama_anak': namaAnakControllerUpdate.text,
        'tempat_lahir': tempatLahirControllerUpdate.text,
        'tanggal_lahir': tanggalLahirControllerUpdate.text,
        'jk': selectedKelaminIdUpdate.toString(),
        'suku': sukuControllerUpdate.text,
        'agama': selectedAgamaIdUpdate.toString(),
        'pekerjaan_anak': selectedPekerjaanAnakIdUpdate.toString(),
        'nama': namaAyahControllerUpdate.text,
        'nama_ibu': namaIbuControllerUpdate.text,
        'pekerjaan_ortu': selectedPekerjaanOrtuIdUpdate.toString(),
        'alamat': alamatControllerUpdate.text,
        '_method': 'PUT',
      };

      final uri = Uri.parse('$baseUrl/sktm-beasiswa/$detailId');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields.addAll(data)
        ..files.add(http.MultipartFile.fromBytes(
          'file_kk',
          selectedFileUpdate!.bytes!,
          filename: selectedFileUpdate!.name,
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

  void resetFormCreate() {
    namaAnakControllerCreate.clear();
    namaAyahControllerCreate.clear();
    namaIbuControllerCreate.clear();
    nikControllerCreate.clear();
    tempatLahirControllerCreate.clear();
    alamatControllerCreate.clear();
    catatanControllerCreate.clear();
    selectedHubunganIdCreate = null;
    selectedKelaminIdCreate = null;
    selectedPekerjaanAnakIdCreate = null;
    selectedPekerjaanOrtuIdCreate = null;
    selectedAgamaIdCreate = null;
    selectedFileCreate = null;
    selectedFileNameCreate = null;
    selectedNikIndexCreate = null;
    selectedNikIdCreate = null;
    selectedDateCreate = null;
    tanggalLahirControllerCreate.clear();
    sukuControllerCreate.clear();
    selectedAgamaIdCreate = null;
    notifyListeners();
  }

  void resetFormUpdate() {
    namaAnakControllerUpdate.clear();
    namaAyahControllerUpdate.clear();
    namaIbuControllerUpdate.clear();
    nikControllerUpdate.clear();
    tempatLahirControllerUpdate.clear();
    alamatControllerUpdate.clear();
    catatanControllerUpdate.clear();
    selectedHubunganIdUpdate = null;
    selectedKelaminIdUpdate = null;
    selectedPekerjaanAnakIdUpdate = null;
    selectedPekerjaanOrtuIdUpdate = null;
    selectedAgamaIdUpdate = null;
    selectedFileUpdate = null;
    selectedFileNameUpdate = null;
    selectedNikIndexUpdate = null;
    selectedNikIdUpdate = null;
    selectedDateUpdate = null;
    tanggalLahirControllerUpdate.clear();
    sukuControllerUpdate.clear();
    selectedAgamaIdUpdate = null;
    notifyListeners();
  }

  void disposeControllers() {
    // Dispose CREATE controllers
    nikControllerCreate.dispose();
    namaAnakControllerCreate.dispose();
    namaAyahControllerCreate.dispose();
    namaIbuControllerCreate.dispose();
    tempatLahirControllerCreate.dispose();
    tempatLahirControllerCreate.dispose();
    alamatControllerCreate.dispose();
    tanggalLahirControllerCreate.dispose();
    sukuControllerCreate.dispose();
    catatanControllerCreate.dispose();

    // Dispose UPDATE controllers
    nikControllerUpdate.dispose();
    selectedFileUpdate = null;
    selectedFileNameUpdate = null;
    namaAnakControllerUpdate.dispose();
    namaAyahControllerUpdate.dispose();
    namaIbuControllerUpdate.dispose();
    tempatLahirControllerUpdate.dispose();
    tanggalLahirControllerUpdate.dispose();
    sukuControllerUpdate.dispose();

    alamatControllerUpdate.dispose();
    catatanControllerUpdate.dispose();
  }
}
