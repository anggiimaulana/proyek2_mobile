class StatusPerkawinan {
  bool error;
  String message;
  List<StatusPerkawinanData> data;

  StatusPerkawinan({
    required this.error,
    required this.message,
    required this.data,
  });

  factory StatusPerkawinan.fromJson(Map<String, dynamic> json) =>
      StatusPerkawinan(
        error: json["error"],
        message: json["message"],
        data: List<StatusPerkawinanData>.from(json["data"].map((x) => StatusPerkawinanData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class StatusPerkawinanData {
  int id;
  String statusPerkawinan;
  DateTime createdAt;
  DateTime updatedAt;

  StatusPerkawinanData({
    required this.id,
    required this.statusPerkawinan,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StatusPerkawinanData.fromJson(Map<String, dynamic> json) => StatusPerkawinanData(
        id: json["id"],
        statusPerkawinan: json["status_perkawinan"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status_perkawinan": statusPerkawinan,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
