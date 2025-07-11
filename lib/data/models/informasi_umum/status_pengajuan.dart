class StatusPengajuan {
  bool error;
  String message;
  List<StatusPengajuanData> data;

  StatusPengajuan({
    required this.error,
    required this.message,
    required this.data,
  });

  factory StatusPengajuan.fromJson(Map<String, dynamic> json) =>
      StatusPengajuan(
        error: json["error"],
        message: json["message"],
        data: List<StatusPengajuanData>.from(json["data"].map((x) => StatusPengajuanData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class StatusPengajuanData {
  int id;
  String status;

  StatusPengajuanData({
    required this.id,
    required this.status,
  });

  factory StatusPengajuanData.fromJson(Map<String, dynamic> json) => StatusPengajuanData(
        id: json["id"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
      };
}
