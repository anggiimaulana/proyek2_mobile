import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:proyek2/data/models/informasi_umum/data_kk_hive_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyek2/data/api/api_services.dart';

class KartuKeluargaProvider with ChangeNotifier {
  final ApiServices _api = ApiServices();
  KartuKeluargaHive? _data;
  bool _isLoading = false;
  String? _errorMessage;

  KartuKeluargaHive? get data => _data;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAndCacheKK() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final kkId = prefs.getInt('kk_id');

      if (kkId == null) {
        _errorMessage = "kk_id tidak ditemukan";
        _isLoading = false;
        notifyListeners();
        return;
      }

      final detail = await _api.fetchKartuKeluargaDetail(kkId);

      if (detail == null) {
        debugPrint("Detail KK null");
        _errorMessage = "Data kartu keluarga tidak ditemukan";
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Konversi dari model KartuKeluargaDetail ke KartuKeluargaHive
      final anggotaList = detail.data.niks.map((nik) {
        return NikHive(
          id: nik.id ?? 0,
          name: nik.name,
          nomorNik: nik.nomorNik,
          tempatLahir: nik.tempatLahir,
          tanggalLahir: nik.tanggalLahir.toIso8601String(),
          jk: nik.jkId ?? 0,
          hubungan: nik.hubunganId ?? 0,
          status: nik.statusId ?? 0,
          agama: nik.agamaId ?? 0,
          alamat: nik.alamat,
          pendidikan: nik.pendidikanId ?? 0,
          pekerjaan: nik.pekerjaanId ?? 0,
        );
      }).toList();

      final kk = KartuKeluargaHive(
        id: detail.data.id,
        nomorKk: detail.data.nomorKk,
        kepalaKeluarga: detail.data.kepalaKeluarga,
        anggota: anggotaList,
      );

      final box = await Hive.openBox<KartuKeluargaHive>('kartuKeluarga');
      await box.clear(); // simpan satu saja
      await box.put('kk', kk);

      _data = kk;
      debugPrint("✅ KK berhasil disimpan ke Hive: ${kk.nomorKk}");
    } catch (e) {
      _errorMessage = "Gagal fetch KK: $e";
      debugPrint("❌ Gagal fetch KK: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadFromCache() async {
    try {
      final box = await Hive.openBox<KartuKeluargaHive>('kartuKeluarga');
      _data = box.get('kk');
      if (_data != null) {
        debugPrint("✅ KK berhasil dimuat dari cache: ${_data!.nomorKk}");
      } else {
        debugPrint("❗ KK tidak ditemukan di cache");
      }
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Gagal memuat KK dari cache: $e");
    }
  }
}
