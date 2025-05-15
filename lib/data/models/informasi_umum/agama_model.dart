class Agama {
  bool error;
  String message;
  List<AgamaData> data;

  Agama({
    required this.error,
    required this.message,
    required this.data,
  });

  factory Agama.fromJson(Map<String, dynamic> json) => Agama(
        error: json["error"],
        message: json["message"],
        data: List<AgamaData>.from(json["data"].map((x) => AgamaData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class AgamaData {
  int id;
  String namaAgama;
  DateTime createdAt;
  DateTime updatedAt;

  AgamaData({
    required this.id,
    required this.namaAgama,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AgamaData.fromJson(Map<String, dynamic> json) => AgamaData(
        id: json["id"],
        namaAgama: json["nama_agama"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_agama": namaAgama,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
