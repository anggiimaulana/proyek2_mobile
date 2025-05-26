import 'package:proyek2/data/models/informasi_umum/agama_model.dart';
import 'package:proyek2/data/models/informasi_umum/hubungan_model.dart';
import 'package:proyek2/data/models/informasi_umum/jk_model.dart';
import 'package:proyek2/data/models/informasi_umum/pekerjaan_model.dart';
import 'package:proyek2/data/models/informasi_umum/pendidikan_model.dart';
import 'package:proyek2/data/models/informasi_umum/status_perkawinan.dart';

class KartuKeluargaDetail {
  bool error;
  String message;
  DataDetailKk data;

  KartuKeluargaDetail({
    required this.error,
    required this.message,
    required this.data,
  });

  factory KartuKeluargaDetail.fromJson(Map<String, dynamic> json) =>
      KartuKeluargaDetail(
        error: json["error"],
        message: json["message"],
        data: DataDetailKk.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data.toJson(),
      };
}

class DataDetailKk {
  int id;
  String nomorKk;
  String kepalaKeluarga;
  DateTime createdAt;
  DateTime updatedAt;
  List<Nik> niks;

  DataDetailKk({
    required this.id,
    required this.nomorKk,
    required this.kepalaKeluarga,
    required this.createdAt,
    required this.updatedAt,
    required this.niks,
  });

  factory DataDetailKk.fromJson(Map<String, dynamic> json) => DataDetailKk(
        id: json["id"],
        nomorKk: json["nomor_kk"],
        kepalaKeluarga: json["kepala_keluarga"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        niks: List<Nik>.from(json["niks"].map((x) => Nik.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nomor_kk": nomorKk,
        "kepala_keluarga": kepalaKeluarga,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "niks": List<dynamic>.from(niks.map((x) => x.toJson())),
      };
}

class Nik {
  int id;
  String nomorNik; 
  int kkId;
  String name;
  String tempatLahir;
  int hubunganId; // Simpan ID saja
  DateTime tanggalLahir;
  int jkId; // Simpan ID saja
  int statusId; // Simpan ID saja
  int agamaId; // Simpan ID saja
  String alamat;
  int pendidikanId; // Simpan ID saja
  int pekerjaanId; // Simpan ID saja
  DateTime createdAt;
  DateTime updatedAt;

  // Properti untuk menyimpan data referensi yang akan diisi setelah load
  HubunganData? hubungan;
  Datum? jk;
  StatusPerkawinanData? status;
  AgamaData? agama;
  PendidikanData? pendidikan;
  PekerjaanData? pekerjaan;

  Nik({
    required this.id,
    required this.nomorNik,
    required this.kkId,
    required this.name,
    required this.tempatLahir,
    required this.hubunganId,
    required this.tanggalLahir,
    required this.jkId,
    required this.statusId,
    required this.agamaId,
    required this.alamat,
    required this.pendidikanId,
    required this.pekerjaanId,
    required this.createdAt,
    required this.updatedAt,
    this.hubungan,
    this.jk,
    this.status,
    this.agama,
    this.pendidikan,
    this.pekerjaan,
  });

  factory Nik.fromJson(Map<String, dynamic> json) => Nik(
        id: json["id"],
        nomorNik: json["nomor_nik"].toString(), // Konversi ke string jika belum
        kkId: json["kk_id"],
        name: json["name"],
        tempatLahir: json["tempat_lahir"],
        hubunganId: json["hubungan"], // Simpan ID saja
        tanggalLahir: DateTime.parse(json["tanggal_lahir"]),
        jkId: json["jk"], // Simpan ID saja
        statusId: json["status"], // Simpan ID saja
        agamaId: json["agama"], // Simpan ID saja
        alamat: json["alamat"],
        pendidikanId: json["pendidikan"], // Simpan ID saja
        pekerjaanId: json["pekerjaan"], // Simpan ID saja
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nomor_nik": nomorNik,
        "kk_id": kkId,
        "name": name,
        "tempat_lahir": tempatLahir,
        "hubungan": hubunganId,
        "tanggal_lahir":
            "${tanggalLahir.year.toString().padLeft(4, '0')}-${tanggalLahir.month.toString().padLeft(2, '0')}-${tanggalLahir.day.toString().padLeft(2, '0')}",
        "jk": jkId,
        "status": statusId,
        "agama": agamaId,
        "alamat": alamat,
        "pendidikan": pendidikanId,
        "pekerjaan": pekerjaanId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
