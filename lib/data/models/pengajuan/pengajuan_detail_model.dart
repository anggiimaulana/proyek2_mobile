import 'package:proyek2/data/models/informasi_umum/kategori_pengajuan.dart';
import 'package:proyek2/data/models/informasi_umum/status_pengajuan.dart';
import 'package:proyek2/data/models/client/client_detail.dart';
import 'package:proyek2/data/models/client/client_model.dart';

class PengajuanDetailModel {
  List<DataPengajuanUser> data;
  Links links;
  Meta meta;

  PengajuanDetailModel({
    required this.data,
    required this.links,
    required this.meta,
  });

  factory PengajuanDetailModel.fromJson(Map<String, dynamic> json) =>
      PengajuanDetailModel(
        data: List<DataPengajuanUser>.from(
          (json["data"] ?? []).map((x) => DataPengajuanUser.fromJson(x)),
        ),
        links: Links.fromJson(json["links"] ?? {}),
        meta: Meta.fromJson(json["meta"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "data": data.map((x) => x.toJson()).toList(),
        "links": links.toJson(),
        "meta": meta.toJson(),
      };
}

class DataPengajuanUser {
  int id;
  int idUserPengajuan;
  dynamic kategoriPengajuan;
  int detailId;
  String urlFile;
  String detailType;
  dynamic statusPengajuan;
  String? catatan;

  DataPengajuanUser({
    required this.id,
    required this.idUserPengajuan,
    required this.kategoriPengajuan,
    required this.detailId,
    required this.urlFile,
    required this.detailType,
    required this.statusPengajuan,
    this.catatan,
  });

  factory DataPengajuanUser.fromJson(Map<String, dynamic> json) {
    return DataPengajuanUser(
      id: _parseToInt(json["id"]) ?? 0,
      // Handle id_user_pengajuan with null safety
      idUserPengajuan: _parseIdUserPengajuan(json["id_user_pengajuan"]),
      // Handle kategori_pengajuan based on its type
      kategoriPengajuan: _parseKategoriPengajuan(json["kategori_pengajuan"]),
      urlFile: json["url_file"]?.toString() ?? "",
      detailId: _parseToInt(json["detail_id"]) ?? 0,
      detailType: json["detail_type"]?.toString() ?? "",
      // Handle status_pengajuan based on its type
      statusPengajuan: _parseStatusPengajuan(json["status_pengajuan"]),
      catatan: json["catatan"]?.toString(),
    );
  }

  // Helper method to safely parse integers
  static int? _parseToInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  // Helper method to parse id_user_pengajuan
  static int _parseIdUserPengajuan(dynamic value) {
    if (value == null) return 0;

    if (value is int) {
      return value;
    } else if (value is Map<String, dynamic>) {
      try {
        final clientDetail = ClientDetail.fromJson(value);
        return clientDetail.data.id;
      } catch (e) {
        print("Error parsing ClientDetail: $e");
        return 0;
      }
    } else if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return 0;
  }

  // Helper method to parse kategori_pengajuan
  static dynamic _parseKategoriPengajuan(dynamic value) {
    if (value == null) return "Unknown";

    if (value is String) {
      return value;
    } else if (value is Map<String, dynamic>) {
      try {
        return KategoriPengajuanData.fromJson(value);
      } catch (e) {
        print("Error parsing KategoriPengajuanData: $e");
        return "Unknown";
      }
    }

    return "Unknown";
  }

  // Helper method to parse status_pengajuan
  static dynamic _parseStatusPengajuan(dynamic value) {
    if (value == null) return "Unknown";

    if (value is String) {
      return value;
    } else if (value is Map<String, dynamic>) {
      try {
        return StatusPengajuanData.fromJson(value);
      } catch (e) {
        print("Error parsing StatusPengajuanData: $e");
        return "Unknown";
      }
    }

    return "Unknown";
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user_pengajuan": idUserPengajuan,
        "kategori_pengajuan": kategoriPengajuan is String
            ? kategoriPengajuan
            : (kategoriPengajuan as KategoriPengajuanData?)?.toJson(),
        "detail_id": detailId,
        "url_file": urlFile,
        "detail_type": detailType,
        "status_pengajuan": statusPengajuan is String
            ? statusPengajuan
            : (statusPengajuan as StatusPengajuanData?)?.toJson(),
        "catatan": catatan,
      };

  // Helper method to get the nama kategori regardless of type
  String get namaKategoriPengajuan {
    if (kategoriPengajuan is String) {
      return kategoriPengajuan as String;
    } else if (kategoriPengajuan is KategoriPengajuanData) {
      return (kategoriPengajuan as KategoriPengajuanData).namaKategori;
    }
    return "Unknown";
  }

  // Helper method to get the status regardless of type
  String get statusPengajuanText {
    if (statusPengajuan is String) {
      return statusPengajuan as String;
    } else if (statusPengajuan is StatusPengajuanData) {
      return (statusPengajuan as StatusPengajuanData).status;
    }
    return "Unknown";
  }

  // Tambahkan di dalam class DataPengajuanUser
  int get kategoriPengajuanId {
    if (kategoriPengajuan is KategoriPengajuanData) {
      return (kategoriPengajuan as KategoriPengajuanData).id;
    } else if (kategoriPengajuan is int) {
      return kategoriPengajuan as int;
    } else if (kategoriPengajuan is String) {
      // mapping manual jika string nama
      return namaKategoriToId[kategoriPengajuan as String] ??
          int.tryParse(kategoriPengajuan as String) ??
          0;
    }
    return 0;
  }

  static const Map<String, int> namaKategoriToId = {
    "Surat Keterangan Tidak Mampu (Listrik)": 1,
    "Surat Keterangan Tidak Mampu (Beasiswa)": 2,
    "Surat Keterangan Tidak Mampu (Sekolah)": 3,
    "Surat Keterangan Status": 4,
    "Surat Keterangan Belum Menikah": 5,
    "Surat Keterangan Pekerjaan": 6,
    "Surat Keterangan Penghasilan Orang Tua (Beasiswa)": 7,
    "Surat Keterangan Usaha": 8,
  };
}

class Links {
  String first;
  String last;
  dynamic prev;
  String? next;

  Links({
    required this.first,
    required this.last,
    this.prev,
    this.next,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json["first"]?.toString() ?? "",
        last: json["last"]?.toString() ?? "",
        prev: json["prev"],
        next: json["next"]?.toString(),
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
        currentPage: json["current_page"] ?? 1,
        from: json["from"] ?? 0,
        lastPage: json["last_page"] ?? 1,
        links:
            List<Link>.from((json["links"] ?? []).map((x) => Link.fromJson(x))),
        path: json["path"]?.toString() ?? "",
        perPage: json["per_page"] ?? 10,
        to: json["to"] ?? 0,
        total: json["total"] ?? 0,
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
    this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"]?.toString(),
        label: json["label"]?.toString() ?? "",
        active: json["active"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
