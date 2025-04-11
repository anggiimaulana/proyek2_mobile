class SktmSekolahModel {
  int id;
  String namaOrtu;
  String namaAnak;
  String tempatLahirAnak;
  String tanggalLahirAnak;
  String jenisKelaminAnak;
  String agamaAnak;
  String asalSekolah;
  String kelas;
  String imageKk;

  SktmSekolahModel({
    required this.id,
    required this.namaOrtu,
    required this.namaAnak,
    required this.tempatLahirAnak,
    required this.tanggalLahirAnak,
    required this.jenisKelaminAnak,
    required this.agamaAnak,
    required this.asalSekolah,
    required this.kelas,
    required this.imageKk,
  });

  factory SktmSekolahModel.fromJson(Map<String, dynamic> json) =>
      SktmSekolahModel(
        id: json["id"],
        namaOrtu: json["nama_ortu"],
        namaAnak: json["nama_anak"],
        tempatLahirAnak: json["tempat_lahir_anak"],
        tanggalLahirAnak: json["tanggal_lahir_anak"],
        jenisKelaminAnak: json["jenis_kelamin_anak"],
        agamaAnak: json["agama_anak"],
        asalSekolah: json["asal_sekolah"],
        kelas: json["kelas"],
        imageKk: json["image_kk"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_ortu": namaOrtu,
        "nama_anak": namaAnak,
        "tempat_lahir_anak": tempatLahirAnak,
        "tanggal_lahir_anak": tanggalLahirAnak,
        "jenis_kelamin_anak": jenisKelaminAnak,
        "agama_anak": agamaAnak,
        "asal_sekolah": asalSekolah,
        "kelas": kelas,
        "image_kk": imageKk,
      };
}
