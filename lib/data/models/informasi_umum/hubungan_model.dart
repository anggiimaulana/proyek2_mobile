class Hubungan {
  bool error;
  String message;
  List<HubunganData> data;

  Hubungan({
    required this.error,
    required this.message,
    required this.data,
  });

  factory Hubungan.fromJson(Map<String, dynamic> json) => Hubungan(
        error: json["error"],
        message: json["message"],
        data: List<HubunganData>.from(json["data"].map((x) => HubunganData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class HubunganData {
  int id;
  String jenisHubungan;

  HubunganData({
    required this.id,
    required this.jenisHubungan,
  });

  factory HubunganData.fromJson(Map<String, dynamic> json) => HubunganData(
        id: json["id"],
        jenisHubungan: json["jenis_hubungan"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "jenis_hubungan": jenisHubungan,
      };
}
