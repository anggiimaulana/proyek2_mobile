class SkPekerjaanModel {
  int id;
  String namaLengkap;
  String nik;
  String tempatLahir;
  String tanggalLahir;
  String jenisKelamin;
  String statusPernikahan;
  String pekerjaanTerdahulu;
  String pekerjaanSekarang;
  String imageKk;

  SkPekerjaanModel({
    required this.id,
    required this.namaLengkap,
    required this.nik,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.statusPernikahan,
    required this.pekerjaanTerdahulu,
    required this.pekerjaanSekarang,
    required this.imageKk,
  });

  factory SkPekerjaanModel.fromJson(Map<String, dynamic> json) => SkPekerjaanModel(
        id: json["id"],
        namaLengkap: json["nama_lengkap"],
        nik: json["nik"],
        tempatLahir: json["tempat_lahir"],
        tanggalLahir: json["tanggal_lahir"],
        jenisKelamin: json["jenis_kelamin"],
        statusPernikahan: json["status_pernikahan"],
        pekerjaanTerdahulu: json["pekerjaan_terdahulu"],
        pekerjaanSekarang: json["pekerjaan_sekarang"],
        imageKk: json["image_kk"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_lengkap": namaLengkap,
        "nik": nik,
        "tempat_lahir": tempatLahir,
        "tanggal_lahir": tanggalLahir,
        "jenis_kelamin": jenisKelamin,
        "status_pernikahan": statusPernikahan,
        "pekerjaan_terdahulu": pekerjaanTerdahulu,
        "pekerjaan_sekarang": pekerjaanSekarang,
        "image_kk": imageKk,
      };
}
