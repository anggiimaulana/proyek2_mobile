
import 'package:proyek2/data/models/informasi_umum/kartu_keluarga_model.dart';

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
  List<DataClient> data;
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
        data: List<DataClient>.from(json["data"].map((x) => DataClient.fromJson(x))),
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

class DataClient {
  KartuKeluarga kkId;
  String namaKepalaKeluarga;
  String nomorTelepon;

  DataClient({
    required this.kkId,
    required this.namaKepalaKeluarga,
    required this.nomorTelepon,
  });

  factory DataClient.fromJson(Map<String, dynamic> json) => DataClient(
        kkId: json["kk_id"],
        namaKepalaKeluarga: json["nama_kepala_keluarga"],
        nomorTelepon: json["nomor_telepon"],
      );

  Map<String, dynamic> toJson() => {
        "kk_id": kkId,
        "nama_kepala_keluarga": namaKepalaKeluarga,
        "nomor_telepon": nomorTelepon,
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
