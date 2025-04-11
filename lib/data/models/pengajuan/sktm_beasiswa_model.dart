class SktmBeasiswaModel {
  int id;
  String namaAnak;
  String tempatLahirAnak;
  String tanggalLahirAnak;
  String suku;
  String agama;
  String jenisKelamin;
  String pekerjaan;
  String namaAyah;
  String namaIbu;
  String pekerjaanOrtu;
  String imageKk;

  SktmBeasiswaModel({
    required this.id,
    required this.namaAnak,
    required this.tempatLahirAnak,
    required this.tanggalLahirAnak,
    required this.suku,
    required this.agama,
    required this.jenisKelamin,
    required this.pekerjaan,
    required this.namaAyah,
    required this.namaIbu,
    required this.pekerjaanOrtu,
    required this.imageKk,
  });

  factory SktmBeasiswaModel.fromJson(Map<String, dynamic> json) => SktmBeasiswaModel(
        id: json["id"],
        namaAnak: json["nama_anak"],
        tempatLahirAnak: json["tempat_lahir_anak"],
        tanggalLahirAnak: json["tanggal_lahir_anak"],
        suku: json["suku"],
        agama: json["agama"],
        jenisKelamin: json["jenis_kelamin"],
        pekerjaan: json["pekerjaan"],
        namaAyah: json["nama_ayah"],
        namaIbu: json["nama_ibu"],
        pekerjaanOrtu: json["pekerjaan_ortu"],
        imageKk: json["image_kk"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_anak": namaAnak,
        "tempat_lahir_anak": tempatLahirAnak,
        "tanggal_lahir_anak": tanggalLahirAnak,
        "suku": suku,
        "agama": agama,
        "jenis_kelamin": jenisKelamin,
        "pekerjaan": pekerjaan,
        "nama_ayah": namaAyah,
        "nama_ibu": namaIbu,
        "pekerjaan_ortu": pekerjaanOrtu,
        "image_kk": imageKk,
      };
}
