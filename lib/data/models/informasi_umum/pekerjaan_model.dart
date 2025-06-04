class Pekerjaan {
  bool error;
  String message;
  List<PekerjaanData> data;

  Pekerjaan({
    required this.error,
    required this.message,
    required this.data,
  });

  factory Pekerjaan.fromJson(Map<String, dynamic> json) => Pekerjaan(
        error: json["error"],
        message: json["message"],
        data: List<PekerjaanData>.from(json["data"].map((x) => PekerjaanData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class PekerjaanData {
  int id;
  String namaPekerjaan;

  PekerjaanData({
    required this.id,
    required this.namaPekerjaan,
  });

  factory PekerjaanData.fromJson(Map<String, dynamic> json) => PekerjaanData(
        id: json["id"],
        namaPekerjaan: json["nama_pekerjaan"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_pekerjaan": namaPekerjaan,
      };
}
