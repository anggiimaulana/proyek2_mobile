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

  StatusPerkawinanData({
    required this.id,
    required this.statusPerkawinan,
  });

  factory StatusPerkawinanData.fromJson(Map<String, dynamic> json) => StatusPerkawinanData(
        id: json["id"],
        statusPerkawinan: json["status_perkawinan"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status_perkawinan": statusPerkawinan,
      };
}
