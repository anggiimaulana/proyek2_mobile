class Pengaduan {
  bool error;
  String message;
  Data data;

  Pengaduan({
    required this.error,
    required this.message,
    required this.data,
  });

  factory Pengaduan.fromJson(Map<String, dynamic> json) => Pengaduan(
        error: json["error"] ?? false,
        message: json["message"] ?? "",
        data: Data.fromJson(json["data"] ?? {}),
      );

  get kategori => null;

  get deskripsi => null;

  get createdAt => null;

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  int currentPage;
  List<Datum> data;
  String firstPageUrl;
  int? from;
  int lastPage;
  String lastPageUrl;
  List<Link> links;
  String? nextPageUrl;
  String path;
  int perPage;
  String? prevPageUrl;
  int? to;
  int total;

  Data({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,
    required this.total,
  });

  bool get hasMorePages => currentPage < lastPage;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"] ?? 1,
        data: json["data"] != null
            ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))
            : [],
        firstPageUrl: json["first_page_url"] ?? "",
        from: json["from"],
        lastPage: json["last_page"] ?? 1,
        lastPageUrl: json["last_page_url"] ?? "",
        links: json["links"] != null
            ? List<Link>.from(json["links"].map((x) => Link.fromJson(x)))
            : [],
        nextPageUrl: json["next_page_url"],
        path: json["path"] ?? "",
        perPage: json["per_page"] ?? 10,
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"] ?? 0,
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

class Datum {
  int id;
  int clientId;
  String kategori;
  String jenisLayanan;
  String keluhan;
  String lokasi;
  String gambar;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  Client client;

  Datum({
    required this.id,
    required this.clientId,
    required this.kategori,
    required this.jenisLayanan,
    required this.keluhan,
    required this.lokasi,
    required this.gambar,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.client,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] ?? 0,
        clientId: json["client_id"] ?? 0,
        kategori: json["kategori"] ?? "",
        jenisLayanan: json["jenis_layanan"] ?? "",
        keluhan: json["keluhan"] ?? "",
        lokasi: json["lokasi"] ?? "",
        gambar: json["gambar"] ?? "",
        status: json["status"] ?? "",
        createdAt: json["created_at"] != null
            ? DateTime.tryParse(json["created_at"]) ?? DateTime.now()
            : DateTime.now(),
        updatedAt: json["updated_at"] != null
            ? DateTime.tryParse(json["updated_at"]) ?? DateTime.now()
            : DateTime.now(),
        client: Client.fromJson(json["client"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "kategori": kategori,
        "jenis_layanan": jenisLayanan,
        "keluhan": keluhan,
        "lokasi": lokasi,
        "gambar": gambar,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "client": client.toJson(),
      };
}

class Client {
  int id;

  Client({
    required this.id,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        id: json["id"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
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
        url: json["url"],
        label: json["label"] ?? "",
        active: json["active"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
