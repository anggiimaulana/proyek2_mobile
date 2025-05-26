class Pendidikan {
  bool error;
  String message;
  List<PendidikanData> data;

  Pendidikan({
    required this.error,
    required this.message,
    required this.data,
  });

  factory Pendidikan.fromJson(Map<String, dynamic> json) => Pendidikan(
        error: json["error"],
        message: json["message"],
        data: List<PendidikanData>.from(json["data"].map((x) => PendidikanData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class PendidikanData {
  int id;
  String jenisPendidikan;

  PendidikanData({
    required this.id,
    required this.jenisPendidikan,
  });

  factory PendidikanData.fromJson(Map<String, dynamic> json) => PendidikanData(
        id: json["id"],
        jenisPendidikan: json["jenis_pendidikan"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "jenis_pendidikan": jenisPendidikan,
      };
}
