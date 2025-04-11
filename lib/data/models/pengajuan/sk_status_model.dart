class SkStatusModel {
  int id;
  String namaLengkap;
  String tempatLahir;
  String tanggalLahir;
  String jenisKelamin;
  String agama;
  String pekerjaan;
  String status;
  String keterangan;
  String imageKk;

  SkStatusModel({
    required this.id,
    required this.namaLengkap,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.agama,
    required this.pekerjaan,
    required this.status,
    required this.keterangan,
    required this.imageKk,
  });

  factory SkStatusModel.fromJson(Map<String, dynamic> json) => SkStatusModel(
        id: json["id"],
        namaLengkap: json["nama_lengkap"],
        tempatLahir: json["tempat_lahir"],
        tanggalLahir: json["tanggal_lahir"],
        jenisKelamin: json["jenis_kelamin"],
        agama: json["agama"],
        pekerjaan: json["pekerjaan"],
        status: json["status"],
        keterangan: json["keterangan"],
        imageKk: json["image_kk"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_lengkap": namaLengkap,
        "tempat_lahir": tempatLahir,
        "tanggal_lahir": tanggalLahir,
        "jenis_kelamin": jenisKelamin,
        "agama": agama,
        "pekerjaan": pekerjaan,
        "status": status,
        "keterangan": keterangan,
        "image_kk": imageKk,
      };
}
