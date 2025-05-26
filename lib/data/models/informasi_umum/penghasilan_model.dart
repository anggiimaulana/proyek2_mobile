class Penghasilan {
  bool error;
  String message;
  List<PenghasilanData> data;

  Penghasilan({
    required this.error,
    required this.message,
    required this.data,
  });

  factory Penghasilan.fromJson(Map<String, dynamic> json) => Penghasilan(
        error: json["error"],
        message: json["message"],
        data: List<PenghasilanData>.from(json["data"].map((x) => PenghasilanData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class PenghasilanData {
  int id;
  String rentangPenghasilan;

  PenghasilanData({
    required this.id,
    required this.rentangPenghasilan,
  });

  factory PenghasilanData.fromJson(Map<String, dynamic> json) => PenghasilanData(
        id: json["id"],
        rentangPenghasilan: json["rentang_penghasilan"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rentang_penghasilan": rentangPenghasilan,
      };
}
