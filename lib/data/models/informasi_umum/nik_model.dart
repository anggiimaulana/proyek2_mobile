import 'package:proyek2/data/models/informasi_umum/agama_model.dart';
import 'package:proyek2/data/models/informasi_umum/hubungan_model.dart';
import 'package:proyek2/data/models/informasi_umum/jk_model.dart';
import 'package:proyek2/data/models/informasi_umum/kartu_keluarga_model.dart';
import 'package:proyek2/data/models/informasi_umum/pekerjaan_model.dart';
import 'package:proyek2/data/models/informasi_umum/pendidikan_model.dart';
import 'package:proyek2/data/models/informasi_umum/status_perkawinan.dart';

class NikModel {
  bool error;
  String message;
  List<DataNik> data;

  NikModel({
    required this.error,
    required this.message,
    required this.data,
  });

  factory NikModel.fromJson(Map<String, dynamic> json) => NikModel(
        error: json["error"],
        message: json["message"],
        data: List<DataNik>.from(
          json["data"].map((x) => DataNik.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DataNik {
  int id;
  String nomorNik;
  KartuKeluarga kkId;
  String name;
  JenisKelamin jk;
  Hubungan hubungan;
  Agama agama;
  String tempatLahir;
  DateTime tanggalLahir;
  Pekerjaan pekerjaan;
  Pendidikan pendidikan;
  StatusPerkawinan status;
  String alamat;

  DataNik({
    required this.id,
    required this.nomorNik,
    required this.kkId,
    required this.name,
    required this.jk,
    required this.hubungan,
    required this.agama,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.pekerjaan,
    required this.pendidikan,
    required this.status,
    required this.alamat,
  });

  factory DataNik.fromJson(Map<String, dynamic> json) => DataNik(
        id: json["id"],
        nomorNik: json["nomor_nik"],
        kkId: KartuKeluarga.fromJson(json["kk_id"]),
        name: json["name"],
        jk: JenisKelamin.fromJson(json["jk"]),
        hubungan: Hubungan.fromJson(json["hubungan"]),
        agama: Agama.fromJson(json["agama"]),
        tempatLahir: json["tempat_lahir"],
        tanggalLahir: DateTime.parse(json["tanggal_lahir"]),
        pekerjaan: Pekerjaan.fromJson(json["pekerjaan"]),
        pendidikan: Pendidikan.fromJson(json["pendidikan"]),
        status: StatusPerkawinan.fromJson(json["status"]),
        alamat: json["alamat"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nomor_nik": nomorNik,
        "kk_id": kkId.toJson(),
        "name": name,
        "jk": jk.toJson(),
        "hubungan": hubungan.toJson(),
        "agama": agama.toJson(),
        "tempat_lahir": tempatLahir,
        "tanggal_lahir":
            "${tanggalLahir.year.toString().padLeft(4, '0')}-${tanggalLahir.month.toString().padLeft(2, '0')}-${tanggalLahir.day.toString().padLeft(2, '0')}",
        "pekerjaan": pekerjaan.toJson(),
        "pendidikan": pendidikan.toJson(),
        "status": status.toJson(),
        "alamat": alamat,
      };
}
