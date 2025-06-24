class BeritaHome {
  bool error;
  String message;
  List<Datum> data;

  BeritaHome({
    required this.error,
    required this.message,
    required this.data,
  });

  factory BeritaHome.fromJson(Map<String, dynamic> json) => BeritaHome(
        error: json["error"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  String judul;
  String kategori;
  String isi;
  DateTime createdAt;
  String penulis;
  String gambar;

  Datum({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.isi,
    required this.createdAt,
    required this.penulis,
    required this.gambar,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        judul: json["judul"],
        kategori: json["kategori"],
        isi: json["isi"],
        createdAt: DateTime.parse(json["created_at"]),
        penulis: json["penulis"],
        gambar: json["gambar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "judul": judul,
        "kategori": kategori,
        "isi": isi,
        "created_at": createdAt.toIso8601String(),
        "penulis": penulis,
        "gambar": gambar,
      };
}
