import 'package:proyek2/data/models/pengajuan/sk_belum_menikah_model.dart';
import 'package:proyek2/data/models/pengajuan/sk_pekerjaan_model.dart';
import 'package:proyek2/data/models/pengajuan/sk_status_model.dart';
import 'package:proyek2/data/models/pengajuan/sk_usaha_model.dart';
import 'package:proyek2/data/models/pengajuan/skpot_beasiswa_model.dart';
import 'package:proyek2/data/models/pengajuan/sktm_beasiswa_model.dart';
import 'package:proyek2/data/models/pengajuan/sktm_listrik_model.dart';

class Pengajuan {
  final List<SktmListrikModel> sktmListrik;
  final List<SktmBeasiswaModel> sktmBeasiswa;
  final List<SkpotBeasiswaModel> sktmSekolah;
  final List<SkStatusModel> skStatus;
  final List<SkBelumMenikahModel> skBelumMenikah;
  final List<SkPekerjaanModel> skPekerjaan;
  final List<SkpotBeasiswaModel> skpotBeasiswa;
  final List<SkUsahaModel> skUsaha;
  final List<SkBelumMenikahModel> skpBantuan;

  Pengajuan({
    required this.sktmListrik,
    required this.sktmBeasiswa,
    required this.sktmSekolah,
    required this.skStatus,
    required this.skBelumMenikah,
    required this.skPekerjaan,
    required this.skpotBeasiswa,
    required this.skUsaha,
    required this.skpBantuan,
  });

  factory Pengajuan.fromJson(Map<String, dynamic> json) => Pengajuan(
        sktmListrik: _safeList(json['sktm_listrik'], SktmListrikModel.fromJson),
        sktmBeasiswa: _safeList(json['sktm_beasiswa'], SktmBeasiswaModel.fromJson),
        sktmSekolah: _safeList(json['sktm_sekolah'], SkpotBeasiswaModel.fromJson),
        skStatus: _safeList(json['sk_status'], SkStatusModel.fromJson),
        skBelumMenikah:
            _safeList(json['sk_belum_menikah'], SkBelumMenikahModel.fromJson),
        skPekerjaan: _safeList(json['sk_pekerjaan'], SkPekerjaanModel.fromJson),
        skpotBeasiswa:
            _safeList(json['skpot_beasiswa'], SkpotBeasiswaModel.fromJson),
        skUsaha: _safeList(json['sk_usaha'], SkUsahaModel.fromJson),
        skpBantuan: _safeList(json['skp_bantuan'], SkBelumMenikahModel.fromJson),
      );

  Map<String, dynamic> toJson() => {
        "sktm_listrik": sktmListrik.map((x) => x.toJson()).toList(),
        "sktm_beasiswa": sktmBeasiswa.map((x) => x.toJson()).toList(),
        "sktm_sekolah": sktmSekolah.map((x) => x.toJson()).toList(),
        "sk_status": skStatus.map((x) => x.toJson()).toList(),
        "sk_belum_menikah": skBelumMenikah.map((x) => x.toJson()).toList(),
        "sk_pekerjaan": skPekerjaan.map((x) => x.toJson()).toList(),
        "skpot_beasiswa": skpotBeasiswa.map((x) => x.toJson()).toList(),
        "sk_usaha": skUsaha.map((x) => x.toJson()).toList(),
        "skp_bantuan": skpBantuan.map((x) => x.toJson()).toList(),
      };

  /// Helper untuk handle null atau key kosong
  static List<T> _safeList<T>(
      dynamic data, T Function(Map<String, dynamic>) fromJson) {
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(data).map(fromJson).toList();
  }
}
