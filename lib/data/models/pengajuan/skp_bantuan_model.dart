class SkpBantuanModel {
  int id;
  String nama;
  String tempatLahir;
  String tanggalLahir;
  String jenisKelamin;
  String agama;
  String alamat;
  String pekerjaan;
  String pengajuanBantuan;
  String imageKk;

  SkpBantuanModel({
    required this.id,
    required this.nama,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.agama,
    required this.alamat,
    required this.pekerjaan,
    required this.pengajuanBantuan,
    required this.imageKk,
  });

  factory SkpBantuanModel.fromJson(Map<String, dynamic> json) => SkpBantuanModel(
        id: json["id"],
        nama: json["nama"],
        tempatLahir: json["tempat_lahir"],
        tanggalLahir: json["tanggal_lahir"],
        jenisKelamin: json["jenis_kelamin"],
        agama: json["agama"],
        alamat: json["alamat"],
        pekerjaan: json["pekerjaan"],
        pengajuanBantuan: json["pengajuan_bantuan"],
        imageKk: json["image_kk"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "tempat_lahir": tempatLahir,
        "tanggal_lahir": tanggalLahir,
        "jenis_kelamin": jenisKelamin,
        "agama": agama,
        "alamat": alamat,
        "pekerjaan": pekerjaan,
        "pengajuan_bantuan": pengajuanBantuan,
        "image_kk": imageKk,
      };
}
