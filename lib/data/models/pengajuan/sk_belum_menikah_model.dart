class SkBelumMenikahModel {
  int id;
  String nama;
  String? nik;
  String tempatLahir;
  String tanggalLahir;
  String jenisKelamin;
  String agama;
  String pekerjaan;
  String? statusPernikahan;
  String imageKk;
  String? alamat;
  String? pengajuanBantuan;

  SkBelumMenikahModel({
    required this.id,
    required this.nama,
    this.nik,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.agama,
    required this.pekerjaan,
    this.statusPernikahan,
    required this.imageKk,
    this.alamat,
    this.pengajuanBantuan,
  });

  factory SkBelumMenikahModel.fromJson(Map<String, dynamic> json) => SkBelumMenikahModel(
        id: json["id"],
        nama: json["nama"],
        nik: json["nik"],
        tempatLahir: json["tempat_lahir"],
        tanggalLahir: json["tanggal_lahir"],
        jenisKelamin: json["jenis_kelamin"],
        agama: json["agama"],
        pekerjaan: json["pekerjaan"],
        statusPernikahan: json["status_pernikahan"],
        imageKk: json["image_kk"],
        alamat: json["alamat"],
        pengajuanBantuan: json["pengajuan_bantuan"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "nik": nik,
        "tempat_lahir": tempatLahir,
        "tanggal_lahir": tanggalLahir,
        "jenis_kelamin": jenisKelamin,
        "agama": agama,
        "pekerjaan": pekerjaan,
        "status_pernikahan": statusPernikahan,
        "image_kk": imageKk,
        "alamat": alamat,
        "pengajuan_bantuan": pengajuanBantuan,
      };
}
