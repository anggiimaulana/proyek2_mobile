import 'package:proyek2/data/models/informasi_umum/agama_model.dart';
import 'package:proyek2/data/models/informasi_umum/hubungan_model.dart';
import 'package:proyek2/data/models/informasi_umum/jk_model.dart';
import 'package:proyek2/data/models/informasi_umum/kartu_keluarga_detail.dart';
import 'package:proyek2/data/models/informasi_umum/kartu_keluarga_model.dart';
import 'package:proyek2/data/models/informasi_umum/pekerjaan_model.dart';

class SktmSekolahModel {
  List<Datum> data;
  Links links;
  Meta meta;

  SktmSekolahModel({
    required this.data,
    required this.links,
    required this.meta,
  });

  factory SktmSekolahModel.fromJson(Map<String, dynamic> json) =>
      SktmSekolahModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "links": links.toJson(),
        "meta": meta.toJson(),
      };
}

class Datum {
  int id;
  KartuKeluarga kkId;
  Nik nikId;
  Hubungan hubungan;
  String nama;
  String tempatLahirOrtu;
  DateTime tanggalLahirOrtu;
  Pekerjaan pekerjaan;
  String alamat;
  String namaAnak;
  String tempatLahir;
  DateTime tanggalLahir;
  JenisKelamin jk;
  Agama agama;
  String asalSekolah;
  String kelas;
  String fileKk;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.kkId,
    required this.nikId,
    required this.id,
    required this.hubungan,
    required this.nama,
    required this.tempatLahirOrtu,
    required this.tanggalLahirOrtu,
    required this.pekerjaan,
    required this.alamat,
    required this.namaAnak,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.jk,
    required this.agama,
    required this.asalSekolah,
    required this.kelas,
    required this.fileKk,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        kkId: KartuKeluarga.fromJson(json["kk_id"]),
        nikId: Nik.fromJson(json["nik_id"]),
        hubungan: json["hubungan"],
        nama: json["nama"],
        tempatLahirOrtu: json["tempat_lahir_ortu"],
        tanggalLahirOrtu: DateTime.parse(json["tanggal_lahir_ortu"]),
        pekerjaan: json["pekerjaan"],
        alamat: json["alamat"],
        namaAnak: json["nama_anak"],
        tempatLahir: json["tempat_lahir"],
        tanggalLahir: DateTime.parse(json["tanggal_lahir"]),
        jk: json["jk"],
        agama: json["agama"],
        asalSekolah: json["asal_sekolah"],
        kelas: json["kelas"],
        fileKk: json["file_kk"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kk_id": kkId.toJson(),
        "nik_id": nikId.toJson(),
        "hubungan": hubungan,
        "nama": nama,
        "tempat_lahir_ortu": tempatLahirOrtu,
        "tanggal_lahir_ortu":
            "${tanggalLahirOrtu.year.toString().padLeft(4, '0')}-${tanggalLahirOrtu.month.toString().padLeft(2, '0')}-${tanggalLahirOrtu.day.toString().padLeft(2, '0')}",
        "pekerjaan": pekerjaan,
        "alamat": alamat,
        "nama_anak": namaAnak,
        "tempat_lahir": tempatLahir,
        "tanggal_lahir":
            "${tanggalLahir.year.toString().padLeft(4, '0')}-${tanggalLahir.month.toString().padLeft(2, '0')}-${tanggalLahir.day.toString().padLeft(2, '0')}",
        "jk": jk,
        "agama": agama,
        "asal_sekolah": asalSekolah,
        "kelas": kelas,
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
