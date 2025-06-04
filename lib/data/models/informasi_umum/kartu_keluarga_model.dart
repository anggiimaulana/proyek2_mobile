class KartuKeluarga {
    bool error;
    String message;
    List<DataKk> data;

    KartuKeluarga({
        required this.error,
        required this.message,
        required this.data,
    });

    factory KartuKeluarga.fromJson(Map<String, dynamic> json) => KartuKeluarga(
        error: json["error"],
        message: json["message"],
        data: List<DataKk>.from(json["data"].map((x) => DataKk.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DataKk {
    int id;
    String nomorKk;
    String kepalaKeluarga;

    DataKk({
        required this.id,
        required this.nomorKk,
        required this.kepalaKeluarga,
    });

    factory DataKk.fromJson(Map<String, dynamic> json) => DataKk(
        id: json["id"],
        nomorKk: json["nomor_kk"],
        kepalaKeluarga: json["kepala_keluarga"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nomor_kk": nomorKk,
        "kepala_keluarga": kepalaKeluarga,
    };
}