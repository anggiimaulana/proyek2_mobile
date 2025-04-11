class SktmListrikModel {
  int id;
  String namaLengkap;
  String nik;
  String alamat;
  String pekerjaan;
  int penghasilan;
  String namaDalamPln;
  String imageKk;

  SktmListrikModel({
    required this.id,
    required this.namaLengkap,
    required this.nik,
    required this.alamat,
    required this.pekerjaan,
    required this.penghasilan,
    required this.namaDalamPln,
    required this.imageKk,
  });

  factory SktmListrikModel.fromJson(Map<String, dynamic> json) => SktmListrikModel(
        id: json["id"],
        namaLengkap: json["nama_lengkap"],
        nik: json["nik"],
        alamat: json["alamat"],
        pekerjaan: json["pekerjaan"],
        penghasilan: json["penghasilan"],
        namaDalamPln: json["nama_dalam_pln"],
        imageKk: json["image_kk"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_lengkap": namaLengkap,
        "nik": nik,
        "alamat": alamat,
        "pekerjaan": pekerjaan,
        "penghasilan": penghasilan,
        "nama_dalam_pln": namaDalamPln,
        "image_kk": imageKk,
      };
}
