import 'package:proyek2/data/models/informasi_umum/agama_model.dart';
import 'package:proyek2/data/models/informasi_umum/jk_model.dart';
import 'package:proyek2/data/models/informasi_umum/pekerjaan_model.dart';
import 'package:proyek2/data/models/informasi_umum/pendidikan_model.dart';
import 'package:proyek2/data/models/informasi_umum/status_perkawinan.dart';

class ClientModel {
  bool error;
  String message;
  Data data;

  ClientModel({
    required this.error,
    required this.message,
    required this.data,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
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
  int currentPage;
  List<DataUser> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  Data({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        data: List<DataUser>.from(json["data"].map((x) => DataUser.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class DataUser {
  int id;
  String nik;
  String name;
  String tempatLahir;
  DateTime tanggalLahir;
  JenisKelamin jk;
  StatusPerkawinan status;
  Agama agama;
  String alamat;
  Pendidikan pendidikan;
  Pekerjaan pekerjaan;
  String nomorTelepon;
  String password;
  DateTime createdAt;
  DateTime updatedAt;

  DataUser({
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

  factory DataUser.fromJson(Map<String, dynamic> json) => DataUser(
        id: json["id"],
        nik: json["nik"],
        name: json["name"],
        tempatLahir: json["tempat_lahir"],
        tanggalLahir: DateTime.parse(json["tanggal_lahir"]),
        jk: json["jk"],
        status: json["status"],
        agama: json["agama"],
        alamat: json["alamat"],
        pendidikan: json["pendidikan"],
        pekerjaan: json["pekerjaan"],
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
        "tanggal_lahir":
            "${tanggalLahir.year.toString().padLeft(4, '0')}-${tanggalLahir.month.toString().padLeft(2, '0')}-${tanggalLahir.day.toString().padLeft(2, '0')}",
        "jk": jk,
        "status": status,
        "agama": agama,
        "alamat": alamat,
        "pendidikan": pendidikan,
        "pekerjaan": pekerjaan,
        "nomor_telepon": nomorTelepon,
        "password": password,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Link {
  String? url;
  String label;
  bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
