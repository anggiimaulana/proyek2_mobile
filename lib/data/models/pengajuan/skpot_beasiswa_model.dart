class SkpotBeasiswaModel {
  int id;
  String namaAnak;
  String? nikAnak;
  String tempatLahirAnak;
  String tanggalLahirAnak;
  String jenisKelaminAnak;
  String agamaAnak;
  String namaOrtu;
  int? penghasilanOrtu;
  String imageKk;
  String? asalSekolah;
  String? kelas;

  SkpotBeasiswaModel({
    required this.id,
    required this.namaAnak,
    this.nikAnak,
    required this.tempatLahirAnak,
    required this.tanggalLahirAnak,
    required this.jenisKelaminAnak,
    required this.agamaAnak,
    required this.namaOrtu,
    this.penghasilanOrtu,
    required this.imageKk,
    this.asalSekolah,
    this.kelas,
  });

  factory SkpotBeasiswaModel.fromJson(Map<String, dynamic> json) => SkpotBeasiswaModel(
        id: json["id"],
        namaAnak: json["nama_anak"],
        nikAnak: json["nik_anak"],
        tempatLahirAnak: json["tempat_lahir_anak"],
        tanggalLahirAnak: json["tanggal_lahir_anak"],
        jenisKelaminAnak: json["jenis_kelamin_anak"],
        agamaAnak: json["agama_anak"],
        namaOrtu: json["nama_ortu"],
        penghasilanOrtu: json["penghasilan_ortu"],
        imageKk: json["image_kk"],
        asalSekolah: json["asal_sekolah"],
        kelas: json["kelas"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_anak": namaAnak,
        "nik_anak": nikAnak,
        "tempat_lahir_anak": tempatLahirAnak,
        "tanggal_lahir_anak": tanggalLahirAnak,
        "jenis_kelamin_anak": jenisKelaminAnak,
        "agama_anak": agamaAnak,
        "nama_ortu": namaOrtu,
        "penghasilan_ortu": penghasilanOrtu,
        "image_kk": imageKk,
        "asal_sekolah": asalSekolah,
        "kelas": kelas,
      };
}
