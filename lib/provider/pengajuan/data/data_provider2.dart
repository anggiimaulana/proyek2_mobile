import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyek2/data/api/api_services.dart';
import 'package:proyek2/data/models/informasi_umum/agama_model.dart';
import 'package:proyek2/data/models/informasi_umum/hubungan_model.dart';
import 'package:proyek2/data/models/informasi_umum/jk_model.dart';
import 'package:proyek2/data/models/informasi_umum/kategori_pengajuan.dart';
import 'package:proyek2/data/models/informasi_umum/pekerjaan_model.dart';
import 'package:proyek2/data/models/informasi_umum/pendidikan_model.dart';
import 'package:proyek2/data/models/informasi_umum/penghasilan_model.dart';
import 'package:proyek2/data/models/informasi_umum/status_pengajuan.dart';
import 'package:proyek2/data/models/informasi_umum/status_perkawinan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<AgamaData> _agamaList = [];
  List<HubunganData> _hubunganList = [];
  List<Datum> _jenisKelaminList = [];
  List<KategoriPengajuanData> _kategoriPengajuanList = [];
  List<PekerjaanData> _pekerjaanList = [];
  List<PendidikanData> _pendidikanList = [];
  List<PenghasilanData> _penghasilanList = [];
  List<StatusPerkawinanData> _statusPerkawinanList = [];
  List<StatusPengajuanData> _statusPengajuanList = [];

  List<AgamaData> get agamaList => _agamaList;
  List<HubunganData> get hubunganList => _hubunganList;
  List<Datum> get jenisKelaminList => _jenisKelaminList;
  List<KategoriPengajuanData> get kategoriPengajuanList =>
      _kategoriPengajuanList;
  List<PekerjaanData> get pekerjaanList => _pekerjaanList;
  List<PendidikanData> get pendidikanList => _pendidikanList;
  List<PenghasilanData> get penghasilanList => _penghasilanList;
  List<StatusPerkawinanData> get statusPerkawinanList => _statusPerkawinanList;
  List<StatusPengajuanData> get statusPengajuanList => _statusPengajuanList;

  final url = ApiServices.baseUrl;

  Future<void> loadAllAndCacheData() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    // === Agama ===
    final agamaCache = prefs.getString('agama_list');
    if (agamaCache != null) {
      _agamaList = (jsonDecode(agamaCache) as List)
          .map((e) => AgamaData.fromJson(e))
          .toList();
    } else {
      await fetchAgama();
      prefs.setString(
          'agama_list', jsonEncode(_agamaList.map((e) => e.toJson()).toList()));
    }

    // === Hubungan ===
    final hubunganCache = prefs.getString('hubungan_list');
    if (hubunganCache != null) {
      _hubunganList = (jsonDecode(hubunganCache) as List)
          .map((e) => HubunganData.fromJson(e))
          .toList();
    } else {
      await fetchHubungan();
      prefs.setString('hubungan_list',
          jsonEncode(_hubunganList.map((e) => e.toJson()).toList()));
    }

    // === Jenis Kelamin ===
    final jkCache = prefs.getString('jk_list');
    if (jkCache != null) {
      _jenisKelaminList =
          (jsonDecode(jkCache) as List).map((e) => Datum.fromJson(e)).toList();
    } else {
      await fetchJenisKelamin();
      prefs.setString('jk_list',
          jsonEncode(_jenisKelaminList.map((e) => e.toJson()).toList()));
    }

    // === Kategori Pengajuan ===
    final kategoriCache = prefs.getString('kategori_pengajuan_list');
    if (kategoriCache != null) {
      _kategoriPengajuanList = (jsonDecode(kategoriCache) as List)
          .map((e) => KategoriPengajuanData.fromJson(e))
          .toList();
    } else {
      await fetchKategoriPengajuan();
      prefs.setString('kategori_pengajuan_list',
          jsonEncode(_kategoriPengajuanList.map((e) => e.toJson()).toList()));
    }

    // === Pekerjaan ===
    final pekerjaanCache = prefs.getString('pekerjaan_list');
    if (pekerjaanCache != null) {
      _pekerjaanList = (jsonDecode(pekerjaanCache) as List)
          .map((e) => PekerjaanData.fromJson(e))
          .toList();
    } else {
      await fetchPekerjaan();
      prefs.setString('pekerjaan_list',
          jsonEncode(_pekerjaanList.map((e) => e.toJson()).toList()));
    }

    // === Pendidikan ===
    final pendidikanCache = prefs.getString('pendidikan_list');
    if (pendidikanCache != null) {
      _pendidikanList = (jsonDecode(pendidikanCache) as List)
          .map((e) => PendidikanData.fromJson(e))
          .toList();
    } else {
      await fetchPendidikan();
      prefs.setString('pendidikan_list',
          jsonEncode(_pendidikanList.map((e) => e.toJson()).toList()));
    }

    // === Penghasilan ===
    final penghasilanCache = prefs.getString('penghasilan_list');
    if (penghasilanCache != null) {
      _penghasilanList = (jsonDecode(penghasilanCache) as List)
          .map((e) => PenghasilanData.fromJson(e))
          .toList();
    } else {
      await fetchPenghasilan();
      prefs.setString('penghasilan_list',
          jsonEncode(_penghasilanList.map((e) => e.toJson()).toList()));
    }

    // === Status Perkawinan ===
    final statusPerkawinanCache = prefs.getString('status_perkawinan_list');
    if (statusPerkawinanCache != null) {
      _statusPerkawinanList = (jsonDecode(statusPerkawinanCache) as List)
          .map((e) => StatusPerkawinanData.fromJson(e))
          .toList();
    } else {
      await fetchStatusPerkawinan();
      prefs.setString('status_perkawinan_list',
          jsonEncode(_statusPerkawinanList.map((e) => e.toJson()).toList()));
    }

    // === Status Pengajuan ===
    final statusPengajuanCache = prefs.getString('status_pengajuan_list');
    if (statusPengajuanCache != null) {
      _statusPengajuanList = (jsonDecode(statusPengajuanCache) as List)
          .map((e) => StatusPengajuanData.fromJson(e))
          .toList();
    } else {
      await fetchStatusPengajuan();
      prefs.setString('status_pengajuan_list',
          jsonEncode(_statusPengajuanList.map((e) => e.toJson()).toList()));
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchAgama() async {
    final response = await http.get(Uri.parse('$url/agama'));
    final jsonData = json.decode(response.body);
    final agama = Agama.fromJson(jsonData);
    _agamaList = agama.data;
    notifyListeners();
  }

  Future<void> fetchHubungan() async {
    final response = await http.get(Uri.parse('$url/hubungan'));
    final jsonData = json.decode(response.body);
    final hubungan = Hubungan.fromJson(jsonData);
    _hubunganList = hubungan.data;
    notifyListeners();
  }

  Future<void> fetchJenisKelamin() async {
    final response = await http.get(Uri.parse('$url/jk'));
    final jsonData = json.decode(response.body);
    final jk = JenisKelamin.fromJson(jsonData);
    _jenisKelaminList = jk.data;
    notifyListeners();
  }

  Future<void> fetchKategoriPengajuan() async {
    final response = await http.get(Uri.parse('$url/kategori-pengajuan'));
    final jsonData = json.decode(response.body);
    final kategori = KategoriPengajuan.fromJson(jsonData);
    _kategoriPengajuanList = kategori.data;
    notifyListeners();
  }

  Future<void> fetchPekerjaan() async {
    final response = await http.get(Uri.parse('$url/pekerjaan'));
    final jsonData = json.decode(response.body);
    final pekerjaan = Pekerjaan.fromJson(jsonData);
    _pekerjaanList = pekerjaan.data;
    notifyListeners();
  }

  Future<void> fetchPendidikan() async {
    final response = await http.get(Uri.parse('$url/pendidikan'));
    final jsonData = json.decode(response.body);
    final pendidikan = Pendidikan.fromJson(jsonData);
    _pendidikanList = pendidikan.data;
    notifyListeners();
  }

  Future<void> fetchPenghasilan() async {
    final response = await http.get(Uri.parse('$url/penghasilan'));
    final jsonData = json.decode(response.body);
    final penghasilan = Penghasilan.fromJson(jsonData);
    _penghasilanList = penghasilan.data;
    notifyListeners();
  }

  Future<void> fetchStatusPerkawinan() async {
    final response = await http.get(Uri.parse('$url/status-perkawinan'));
    final jsonData = json.decode(response.body);
    final statusPerkawinan = StatusPerkawinan.fromJson(jsonData);
    _statusPerkawinanList = statusPerkawinan.data;
    notifyListeners();
  }

  Future<void> fetchStatusPengajuan() async {
    final response = await http.get(Uri.parse('$url/status-pengajuan'));
    final jsonData = json.decode(response.body);
    final statusPengajuan = StatusPengajuan.fromJson(jsonData);
    _statusPengajuanList = statusPengajuan.data;
    notifyListeners();
  }
}
