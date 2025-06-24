class BeritaDetailModel {
  bool error;
  String message;
  Data data;

  BeritaDetailModel({
    required this.error,
    required this.message,
    required this.data,
  });

  factory BeritaDetailModel.fromJson(Map<String, dynamic> json) =>
      BeritaDetailModel(
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
  int id;
  String judul;
  String kategori;
  String isi;
  DateTime createdAt;
  String penulis;
  String gambar;

  Data({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.isi,
    required this.createdAt,
    required this.penulis,
    required this.gambar,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
