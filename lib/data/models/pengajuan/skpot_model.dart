import 'package:proyek2/data/models/informasi_umum/agama_model.dart';
import 'package:proyek2/data/models/informasi_umum/hubungan_model.dart';
import 'package:proyek2/data/models/informasi_umum/jk_model.dart';
import 'package:proyek2/data/models/informasi_umum/kartu_keluarga_detail.dart';
import 'package:proyek2/data/models/informasi_umum/kartu_keluarga_model.dart';
import 'package:proyek2/data/models/informasi_umum/pekerjaan_model.dart';
import 'package:proyek2/data/models/informasi_umum/penghasilan_model.dart';

class PengajuanSkpot {
  final List<DataSkpot> data;
  final Links links;
  final Meta meta;

  PengajuanSkpot({
    required this.data,
    required this.links,
    required this.meta,
  });

  factory PengajuanSkpot.fromJson(Map<String, dynamic> json) => PengajuanSkpot(
        data: List<DataSkpot>.from(
            json["data"].map((x) => DataSkpot.fromJson(x))),
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.map((x) => x.toJson()).toList(),
        "links": links.toJson(),
        "meta": meta.toJson(),
      };
}

class DataSkpot {
  int id;
  Hubungan hubungan;
  String nama;
  KartuKeluarga kkId;
  Nik nikId;
  String tempatLahir;
  DateTime tanggalLahir;
  JenisKelamin jk;
  Agama agama;
  String namaOrtu;
  Pekerjaan pekerjaan;
  Penghasilan penghasilan;
  String fileKk;
  String alamat;
  DateTime createdAt;
  DateTime updatedAt;

  DataSkpot({
    required this.id,
    required this.hubungan,
    required this.nama,
    required this.kkId,
    required this.nikId,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.jk,
    required this.agama,
    required this.namaOrtu,
    required this.pekerjaan,
    required this.penghasilan,
    required this.fileKk,
    required this.alamat,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DataSkpot.fromJson(Map<String, dynamic> json) => DataSkpot(
        id: json["id"],
        hubungan: json["hubungan"],
        nama: json["nama"],
        kkId: KartuKeluarga.fromJson(json["kk_id"]),
        nikId: Nik.fromJson(json["nik_id"]),
        tempatLahir: json["tempat_lahir"],
        tanggalLahir: DateTime.parse(json["tanggal_lahir"]),
        jk: json["jk"],
        agama: json["agama"],
        namaOrtu: json["nama_ortu"],
        pekerjaan: json["pekerjaan"],
        penghasilan: json["penghasilan"],
        fileKk: json["file_kk"],
        alamat: json["alamat"],
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
        "agama": agama,
        "nama_ortu": namaOrtu,
        "pekerjaan": pekerjaan,
        "penghasilan": penghasilan,
        "file_kk": fileKk,
        "alamat": alamat,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Links {
  final String first;
  final String last;
  final String prev;
  final String next;

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
