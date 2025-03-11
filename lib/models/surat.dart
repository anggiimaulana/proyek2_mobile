class Surat {
  final String jenis;
  final String status;
  final String aksi;

  Surat({
    required this.jenis,
    required this.status,
    required this.aksi,
  });
}

List<Surat> dummySurat = [
  Surat(
      jenis: 'Surat Keterangan Tidak Mampu',
      status: 'Diserahkan',
      aksi: 'Menunggu'),
  Surat(jenis: 'Surat Keterangan Usaha', status: 'Diproses', aksi: 'Menunggu'),
  Surat(jenis: 'Surat Keterangan Lainnya', status: 'Ditolak', aksi: 'Menunggu'),
  Surat(
      jenis: 'Surat Keterangan Status', status: 'Disetujui', aksi: 'Download'),
  Surat(
      jenis: 'Surat Keterangan Penghasilan Orang Tua',
      status: 'Diserahkan',
      aksi: 'Menunggu'),
  Surat(
      jenis: 'Surat Keterangan Belum Menikah',
      status: 'Disetujui',
      aksi: 'Download'),
  Surat(
      jenis: 'Surat Keterangan Tidak Mampu',
      status: 'Ditolak',
      aksi: 'Menunggu'),
  Surat(jenis: 'Surat Keterangan Usaha', status: 'Diproses', aksi: 'Menunggu'),
];

class SuratModel {
  final String title;
  final String subtitle;
  final String iconPath;
  final String colorHex;
  final String route;

  SuratModel({
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.colorHex,
    required this.route,
  });
}

// Data Dummy
final List<SuratModel> suratList = [
  SuratModel(
    title: "Surat Keterangan",
    subtitle: "6 Jenis surat",
    iconPath: "assets/icons/sk_logo.png",
    colorHex: "F6BE05",
    route: "/sk_screen",
  ),
  SuratModel(
    title: "Surat Pengantar Desa",
    subtitle: "2 Jenis surat",
    iconPath: "assets/icons/sp_logo.png",
    colorHex: "08AB31",
    route: "/sp_screen",
  ),
  SuratModel(
    title: "Surat Rekomendasi",
    subtitle: "3 Jenis surat",
    iconPath: "assets/icons/sr_logo.png",
    colorHex: "6495ED",
    route: "/sr_screen",
  ),
  SuratModel(
    title: "Pengajuan Surat Lainnya",
    subtitle: "8 Jenis surat",
    iconPath: "assets/icons/sl_logo.png",
    colorHex: "F6056D",
    route: "/sl_screen",
  ),
];
