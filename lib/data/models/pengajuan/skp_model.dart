import 'package:proyek2/data/models/informasi_umum/hubungan_model.dart';
import 'package:proyek2/data/models/informasi_umum/jk_model.dart';
import 'package:proyek2/data/models/informasi_umum/kartu_keluarga_detail.dart';
import 'package:proyek2/data/models/informasi_umum/kartu_keluarga_model.dart';
import 'package:proyek2/data/models/informasi_umum/pekerjaan_model.dart';
import 'package:proyek2/data/models/informasi_umum/status_perkawinan.dart';

class SkpModel {
  List<DataSkp> data;
  Links links;
  Meta meta;

  SkpModel({
    required this.data,
    required this.links,
    required this.meta,
  });

  factory SkpModel.fromJson(Map<String, dynamic> json) => SkpModel(
        data: List<DataSkp>.from(json["data"].map((x) => DataSkp.fromJson(x))),
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "links": links.toJson(),
        "meta": meta.toJson(),
      };
}

class DataSkp {
  int id;
  Hubungan hubungan;
  String nama;
  KartuKeluarga kkId;
  Nik nikId;
  String tempatLahir;
  DateTime tanggalLahir;
  JenisKelamin jk;
  StatusPerkawinan statusPerkawinan;
  Pekerjaan pekerjaanTerdahulu;
  Pekerjaan pekerjaanSekarang;
  String alamat;
  String fileKk;
  DateTime createdAt;
  DateTime updatedAt;

  DataSkp({
    required this.id,
    required this.hubungan,
    required this.nama,
    required this.kkId,
    required this.nikId,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.jk,
    required this.statusPerkawinan,
    required this.pekerjaanTerdahulu,
    required this.pekerjaanSekarang,
    required this.alamat,
    required this.fileKk,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DataSkp.fromJson(Map<String, dynamic> json) => DataSkp(
        id: json["id"],
        hubungan: json["hubungan"],
        nama: json["nama"],
        kkId: KartuKeluarga.fromJson(json["kk_id"]),
        nikId: Nik.fromJson(json["nik_id"]),
        tempatLahir: json["tempat_lahir"],
        tanggalLahir: DateTime.parse(json["tanggal_lahir"]),
        jk: json["jk"],
        statusPerkawinan: json["status_perkawinan"],
        pekerjaanTerdahulu: json["pekerjaan_terdahulu"],
        pekerjaanSekarang: json["pekerjaan_sekarang"],
        alamat: json["alamat"],
        fileKk: json["file_kk"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "hubungan": hubungan,
        "nama": nama,
        "kk_id": kkId.toJson(),
        "nik_id": nikId.toJson(),
        "tempat_lahir": tempatLahir,
        "tanggal_lahir":
            "${tanggalLahir.year.toString().padLeft(4, '0')}-${tanggalLahir.month.toString().padLeft(2, '0')}-${tanggalLahir.day.toString().padLeft(2, '0')}",
        "jk": jk,
        "status_perkawinan": statusPerkawinan,
        "pekerjaan_terdahulu": pekerjaanTerdahulu,
        "pekerjaan_sekarang": pekerjaanSekarang,
        "alamat": alamat,
        "file_kk": fileKk,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Links {
  String first;
  String last;
  dynamic prev;
  dynamic next;

  Links({
    required this.first,
    required this.last,
    required this.prev,
    required this.next,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json["first"],
        last: json["last"],
        prev: json["prev"],
        next: json["next"],
      );

  Map<String, dynamic> toJson() => {
        "first": first,
        "last": last,
        "prev": prev,
        "next": next,
      };
}

class Meta {
  int currentPage;
  int from;
  int lastPage;
  List<Link> links;
  String path;
  int perPage;
  int to;
  int total;

  Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
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
