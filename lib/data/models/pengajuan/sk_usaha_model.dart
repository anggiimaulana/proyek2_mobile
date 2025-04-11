class SkUsahaModel {
  int id;
  String namaLengkap;
  String namaUsaha;
  String statusUsaha;
  String kegiatanUsaha;
  String alamatUsaha;
  String imageKtp;
  String sertifikatUsahaImage;

  SkUsahaModel({
    required this.id,
    required this.namaLengkap,
    required this.namaUsaha,
    required this.statusUsaha,
    required this.kegiatanUsaha,
    required this.alamatUsaha,
    required this.imageKtp,
    required this.sertifikatUsahaImage,
  });

  factory SkUsahaModel.fromJson(Map<String, dynamic> json) => SkUsahaModel(
        id: json["id"],
        namaLengkap: json["nama_lengkap"],
        namaUsaha: json["nama_usaha"],
        statusUsaha: json["status_usaha"],
        kegiatanUsaha: json["kegiatan_usaha"],
        alamatUsaha: json["alamat_usaha"],
        imageKtp: json["image_ktp"],
        sertifikatUsahaImage: json["sertifikat_usaha_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_lengkap": namaLengkap,
        "nama_usaha": namaUsaha,
        "status_usaha": statusUsaha,
        "kegiatan_usaha": kegiatanUsaha,
        "alamat_usaha": alamatUsaha,
        "image_ktp": imageKtp,
        "sertifikat_usaha_image": sertifikatUsahaImage,
      };
}
