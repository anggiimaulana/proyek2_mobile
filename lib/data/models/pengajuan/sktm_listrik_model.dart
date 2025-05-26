import 'package:proyek2/data/models/informasi_umum/agama_model.dart';
import 'package:proyek2/data/models/informasi_umum/hubungan_model.dart';
import 'package:proyek2/data/models/informasi_umum/jk_model.dart';
import 'package:proyek2/data/models/informasi_umum/kartu_keluarga_detail.dart';
import 'package:proyek2/data/models/informasi_umum/kartu_keluarga_model.dart';
import 'package:proyek2/data/models/informasi_umum/pekerjaan_model.dart';
import 'package:proyek2/data/models/informasi_umum/penghasilan_model.dart';

class SktmListrik {
  bool error;
  String message;
  Data data;

  SktmListrik({
    required this.error,
    required this.message,
    required this.data,
  });

  factory SktmListrik.fromJson(Map<String, dynamic> json) => SktmListrik(
        error: json["error"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Pengajuan pengajuan;
  DetailSktmListrik detail;
  String fileUrl;

  Data({
    required this.pengajuan,
    required this.detail,
    required this.fileUrl,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        pengajuan: Pengajuan.fromJson(json["pengajuan"]),
        detail: DetailSktmListrik.fromJson(json["detail"]),
        fileUrl: json["file_url"],
      );

  Map<String, dynamic> toJson() => {
        "pengajuan": pengajuan.toJson(),
        "detail": detail.toJson(),
        "file_url": fileUrl,
      };
}

class DetailSktmListrik {
  KartuKeluarga kkId;
  Nik nikId;
  Hubungan hubungan;
  String nama;
  String nik;
  String alamat;
  Agama agama;
  JenisKelamin jk;
  String umur;
  Pekerjaan pekerjaan;
  Penghasilan penghasilan;
  String namaPln;
  String fileKk;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  DetailSktmListrik({
    required this.hubungan,
    required this.kkId,
    required this.nikId,
    required this.nama,
    required this.nik,
    required this.alamat,
    required this.agama,
    required this.jk,
    required this.umur,
    required this.pekerjaan,
    required this.penghasilan,
    required this.namaPln,
    required this.fileKk,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory DetailSktmListrik.fromJson(Map<String, dynamic> json) =>
      DetailSktmListrik(
        kkId: KartuKeluarga.fromJson(json["kk_id"]),
        nikId: Nik.fromJson(json["nik_id"]),
        hubungan: Hubungan.fromJson(json["hubungan"]),
        nama: json["nama"],
        nik: json["nik"],
        alamat: json["alamat"],
        agama: Agama.fromJson(json["agama"]),
        jk: JenisKelamin.fromJson(json["jk"]),
        umur: json["umur"],
        pekerjaan: Pekerjaan.fromJson(json["pekerjaan"]),
        penghasilan: Penghasilan.fromJson(json["penghasilan"]),
        namaPln: json["nama_pln"],
        fileKk: json["file_kk"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "hubungan": hubungan.toJson(),
        "kk_id": kkId.toJson(),
        "nik_id": nikId.toJson(),
        "nama": nama,
        "nik": nik,
        "alamat": alamat,
        "agama": agama.toJson(),
        "jk": jk.toJson(),
        "umur": umur,
        "pekerjaan": pekerjaan.toJson(),
        "penghasilan": penghasilan.toJson(),
        "nama_pln": namaPln,
        "file_kk": fileKk,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}

class Pengajuan {
  int idUserPengajuan;
  int? idAdmin;
  int kategoriPengajuan;
  String detailType;
  int statusPengajuan;
  String? catatan;
  int idAdminUpdated;
  int idKuwuUpdated;
  int detailId;
  int id;

  Pengajuan({
    required this.idUserPengajuan,
    this.idAdmin,
    required this.kategoriPengajuan,
    required this.detailType,
    required this.statusPengajuan,
    this.catatan,
    required this.idAdminUpdated,
    required this.idKuwuUpdated,
    required this.detailId,
    required this.id,
  });

  factory Pengajuan.fromJson(Map<String, dynamic> json) => Pengajuan(
        idUserPengajuan: json["id_user_pengajuan"],
        idAdmin: json["id_admin"],
        kategoriPengajuan: json["kategori_pengajuan"],
        detailType: json["detail_type"],
        statusPengajuan: json["status_pengajuan"],
        catatan: json["catatan"],
        idAdminUpdated: json["id_admin_updated"],
        idKuwuUpdated: json["id_kuwu_updated"],
        detailId: json["detail_id"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id_user_pengajuan": idUserPengajuan,
        "id_admin": idAdmin,
        "kategori_pengajuan": kategoriPengajuan,
        "detail_type": detailType,
        "status_pengajuan": statusPengajuan,
        "catatan": catatan,
        "id_admin_updated": idAdminUpdated,
        "id_kuwu_updated": idKuwuUpdated,
        "detail_id": detailId,
        "id": id,
      };
}
