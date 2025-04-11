import 'package:proyek2/data/models/pengajuan/pengajuan_surat_model.dart';

class UserDetail {
  bool error;
  String message;
  User user;

  UserDetail({
    required this.error,
    required this.message,
    required this.user,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        error: json["error"],
        message: json["message"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "user": user.toJson(),
      };
}

class User {
  String id;
  String name;
  String nik;
  String tempatLahir;
  String tanggalLahir;
  String suku;
  String agama;
  String jenisKelamin;
  String alamat;
  String pekerjaan;
  Pengajuan pengajuan;

  User({
    required this.id,
    required this.name,
    required this.nik,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.suku,
    required this.agama,
    required this.jenisKelamin,
    required this.alamat,
    required this.pekerjaan,
    required this.pengajuan,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        nik: json["nik"],
        tempatLahir: json["tempat_lahir"],
        tanggalLahir: json["tanggal_lahir"],
        suku: json["suku"],
        agama: json["agama"],
        jenisKelamin: json["jenis_kelamin"],
        alamat: json["alamat"],
        pekerjaan: json["pekerjaan"],
        pengajuan: Pengajuan.fromJson(json["pengajuan"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "nik": nik,
        "tempat_lahir": tempatLahir,
        "tanggal_lahir": tanggalLahir,
        "suku": suku,
        "agama": agama,
        "jenis_kelamin": jenisKelamin,
        "alamat": alamat,
        "pekerjaan": pekerjaan,
        "pengajuan": pengajuan.toJson(),
      };
}
