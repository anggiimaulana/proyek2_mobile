import 'package:proyek2/data/models/informasi_umum/agama_model.dart';
import 'package:proyek2/data/models/informasi_umum/hubungan_model.dart';
import 'package:proyek2/data/models/informasi_umum/jk_model.dart';
import 'package:proyek2/data/models/informasi_umum/kategori_pengajuan.dart';
import 'package:proyek2/data/models/informasi_umum/pekerjaan_model.dart';
import 'package:proyek2/data/models/informasi_umum/penghasilan_model.dart';
import 'package:proyek2/data/models/informasi_umum/status_pengajuan.dart';
import 'package:proyek2/data/models/client/client_model.dart';

class PengajuanSuratModel {
  List<PengajuanDetail> data;
  Links links;
  Meta meta;

  PengajuanSuratModel({
    required this.data,
    required this.links,
    required this.meta,
  });

  factory PengajuanSuratModel.fromJson(Map<String, dynamic> json) =>
      PengajuanSuratModel(
        data: List<PengajuanDetail>.from(
            json["data"].map((x) => PengajuanDetail.fromJson(x))),
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.map((x) => x.toJson()).toList(),
        "links": links.toJson(),
        "meta": meta.toJson(),
      };
}

class PengajuanDetail {
  int id;
  DataClient idUserPengajuan;
  int idAdmin;
  KategoriPengajuanData kategoriPengajuan;
  int detailId;
  String detailType;
  DetailPengajuan detail;
  StatusPengajuanData statusPengajuan;
  String catatan;
  int idAdminUpdated;
  int idKuwuUpdated;
  DateTime createdAt;
  DateTime updatedAt;

  PengajuanDetail({
    required this.id,
    required this.idUserPengajuan,
    required this.idAdmin,
    required this.kategoriPengajuan,
    required this.detailId,
    required this.detailType,
    required this.detail,
    required this.statusPengajuan,
    required this.catatan,
    required this.idAdminUpdated,
    required this.idKuwuUpdated,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PengajuanDetail.fromJson(Map<String, dynamic> json) =>
      PengajuanDetail(
        id: json["id"],
        idUserPengajuan: DataClient.fromJson(json["id_user_pengajuan"]),
        idAdmin: json["id_admin"] != null ? json["id_admin"]["id"] : 0,
        kategoriPengajuan:
            KategoriPengajuanData.fromJson(json["kategori_pengajuan"]),
        detailId: json["detail_id"],
        detailType: json["detail_type"],
        detail: DetailPengajuan.fromJson(json["detail"]),
        statusPengajuan: StatusPengajuanData.fromJson(json["status_pengajuan"]),
        catatan: json["catatan"] ?? '',
        idAdminUpdated: json["id_admin_updated"]?["id"] ?? 0,
        idKuwuUpdated: json["id_kuwu_updated"]?["id"] ?? 0,
        createdAt:
            DateTime.tryParse(json["created_at"] ?? '') ?? DateTime.now(),
        updatedAt:
            DateTime.tryParse(json["updated_at"] ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user_pengajuan": idUserPengajuan.toJson(),
        "id_admin": idAdmin != 0 ? {"id": idAdmin} : null,
        "kategori_pengajuan": kategoriPengajuan.toJson(),
        "detail_id": detailId,
        "detail_type": detailType,
        "detail": detail.toJson(),
        "status_pengajuan": statusPengajuan.toJson(),
        "catatan": catatan,
        "id_admin_updated": idAdminUpdated != 0 ? {"id": idAdminUpdated} : null,
        "id_kuwu_updated": idKuwuUpdated != 0 ? {"id": idKuwuUpdated} : null,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class DetailPengajuan {
  int id;
  Hubungan hubungan;
  String nama;
  String nik;
  String alamat;
  Pekerjaan pekerjaan;
  Penghasilan penghasilan;
  String namaPln;
  Agama agama;
  JenisKelamin jk;
  int umur;
  String fileKk;
  DateTime createdAt;
  DateTime updatedAt;

  DetailPengajuan({
    required this.id,
    required this.hubungan,
    required this.nama,
    required this.nik,
    required this.alamat,
    required this.pekerjaan,
    required this.penghasilan,
    required this.namaPln,
    required this.agama,
    required this.jk,
    required this.umur,
    required this.fileKk,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DetailPengajuan.fromJson(Map<String, dynamic> json) =>
      DetailPengajuan(
        id: json["id"],
        hubungan: Hubungan.fromJson(json["hubungan"]),
        nama: json["nama"],
        nik: json["nik"],
        alamat: json["alamat"],
        pekerjaan: Pekerjaan.fromJson(json["pekerjaan"]),
        penghasilan: Penghasilan.fromJson(json["penghasilan"]),
        namaPln: json["nama_pln"],
        agama: Agama.fromJson(json["agama"]),
        jk: JenisKelamin.fromJson(json["jk"]),
        umur: json["umur"],
        fileKk: json["file_kk"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "hubungan": hubungan.toJson(),
        "nama": nama,
        "nik": nik,
        "alamat": alamat,
        "pekerjaan": pekerjaan.toJson(),
        "penghasilan": penghasilan.toJson(),
        "nama_pln": namaPln,
        "agama": agama.toJson(),
        "jk": jk.toJson(),
        "umur": umur,
        "file_kk": fileKk,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Links {
  String first;
  String last;
  String? prev;
  String? next;

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
        "links": links.map((x) => x.toJson()).toList(),
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
