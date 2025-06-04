import 'package:proyek2/data/models/informasi_umum/agama_model.dart';
import 'package:proyek2/data/models/informasi_umum/jk_model.dart';
import 'package:proyek2/data/models/informasi_umum/pekerjaan_model.dart';
import 'package:proyek2/data/models/informasi_umum/pendidikan_model.dart';
import 'package:proyek2/data/models/informasi_umum/status_perkawinan.dart';

class ClientDetail {
  final bool error;
  final String message;
  final DataClient data;

  ClientDetail({
    required this.error,
    required this.message,
    required this.data,
  });

  factory ClientDetail.fromJson(Map<String, dynamic> json) => ClientDetail(
        error: json["error"],
        message: json["message"],
        data: DataClient.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data.toJson(),
      };
}

class DataClient {
  final int id;
  final String nik;
  final String name;
  final String tempatLahir;
  final DateTime tanggalLahir;
  final JenisKelamin jk;
  final StatusPerkawinan status;
  final Agama agama;
  final String alamat;
  final Pendidikan pendidikan;
  final Pekerjaan pekerjaan;
  final String nomorTelepon;
  final String password;
  final DateTime createdAt;
  final DateTime updatedAt;

  DataClient({
    required this.id,
    required this.nik,
    required this.name,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.jk,
    required this.status,
    required this.agama,
    required this.alamat,
    required this.pendidikan,
    required this.pekerjaan,
    required this.nomorTelepon,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DataClient.fromJson(Map<String, dynamic> json) => DataClient(
        id: json["id"],
        nik: json["nik"],
        name: json["name"],
        tempatLahir: json["tempat_lahir"],
        tanggalLahir: DateTime.parse(json["tanggal_lahir"]),
        jk: JenisKelamin.fromJson(json["jk"]),
        status: StatusPerkawinan.fromJson(json["status"]),
        agama: Agama.fromJson(json["agama"]),
        alamat: json["alamat"],
        pendidikan: Pendidikan.fromJson(json["pendidikan"]),
        pekerjaan: Pekerjaan.fromJson(json["pekerjaan"]),
        nomorTelepon: json["nomor_telepon"],
        password: json["password"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nik": nik,
        "name": name,
        "tempat_lahir": tempatLahir,
        "tanggal_lahir": tanggalLahir.toIso8601String(),
        "jk": jk.toJson(),
        "status": status.toJson(),
        "agama": agama.toJson(),
        "alamat": alamat,
        "pendidikan": pendidikan.toJson(),
        "pekerjaan": pekerjaan.toJson(),
        "nomor_telepon": nomorTelepon,
        "password": password,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
