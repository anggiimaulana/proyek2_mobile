class KategoriPengajuan {
  bool error;
  String message;
  List<KategoriPengajuanData> data;

  KategoriPengajuan({
    required this.error,
    required this.message,
    required this.data,
  });

  factory KategoriPengajuan.fromJson(Map<String, dynamic> json) =>
      KategoriPengajuan(
        error: json["error"],
        message: json["message"],
        data: List<KategoriPengajuanData>.from(json["data"].map((x) => KategoriPengajuanData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class KategoriPengajuanData {
  int id;
  String namaKategori;

  KategoriPengajuanData({
    required this.id,
    required this.namaKategori,
  });

  factory KategoriPengajuanData.fromJson(Map<String, dynamic> json) => KategoriPengajuanData(
        id: json["id"],
        namaKategori: json["nama_kategori"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_kategori": namaKategori,
      };
}
