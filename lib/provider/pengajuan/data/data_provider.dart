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

    await fetchAgama();
    prefs.setString(
        'agama_list', jsonEncode(_agamaList.map((e) => e.toJson()).toList()));

    await fetchHubungan();
    prefs.setString('hubungan_list',
        jsonEncode(_hubunganList.map((e) => e.toJson()).toList()));

    await fetchJenisKelamin();
    prefs.setString('jk_list',
        jsonEncode(_jenisKelaminList.map((e) => e.toJson()).toList()));

    await fetchKategoriPengajuan();
    prefs.setString('kategori_pengajuan_list',
        jsonEncode(_kategoriPengajuanList.map((e) => e.toJson()).toList()));

    await fetchPekerjaan();
    prefs.setString('pekerjaan_list',
        jsonEncode(_pekerjaanList.map((e) => e.toJson()).toList()));

    await fetchPendidikan();
    prefs.setString('pendidikan_list',
        jsonEncode(_pendidikanList.map((e) => e.toJson()).toList()));

    await fetchPenghasilan();
    prefs.setString('penghasilan_list',
        jsonEncode(_penghasilanList.map((e) => e.toJson()).toList()));

    await fetchStatusPerkawinan();
    prefs.setString('status_perkawinan_list',
        jsonEncode(_statusPerkawinanList.map((e) => e.toJson()).toList()));

    await fetchStatusPengajuan();
    prefs.setString('status_pengajuan_list',
        jsonEncode(_statusPengajuanList.map((e) => e.toJson()).toList()));

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
