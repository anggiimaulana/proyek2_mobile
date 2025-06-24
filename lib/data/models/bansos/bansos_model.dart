class Pengajuan {
  final String idPengajuan;
  final String nama;
  final String status;
  final String tglPengajuan;
  final String namaBansos;

  Pengajuan({
    required this.idPengajuan,
    required this.nama,
    required this.status,
    required this.tglPengajuan,
    required this.namaBansos,
  });

  factory Pengajuan.fromJson(Map<String, dynamic> json) {
    return Pengajuan(
      idPengajuan: json['no_permohonan'].toString(),
      nama: json['nama'],
      status: json['status'],
      tglPengajuan: json['tgl_pengajuan'],
      namaBansos: json['nama_bansos'],
    );
  }
}
