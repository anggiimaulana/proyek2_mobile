class JenisKelamin {
  bool error;
  String message;
  List<Datum> data;

  JenisKelamin({
    required this.error,
    required this.message,
    required this.data,
  });

  factory JenisKelamin.fromJson(Map<String, dynamic> json) => JenisKelamin(
        error: json["error"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  String jenisKelamin;

  Datum({
    required this.id,
    required this.jenisKelamin,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        jenisKelamin: json["jenis_kelamin"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "jenis_kelamin": jenisKelamin,
      };
}
