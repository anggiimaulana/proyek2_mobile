class PengajuanSurat {
  final String jenis;
  final String status;
  final String aksi;

  PengajuanSurat({
    required this.jenis,
    required this.status,
    required this.aksi,
  });
}

List<PengajuanSurat> dummyPengajuanSurat = [
  PengajuanSurat(
      jenis: 'Surat Keterangan Tidak Mampu',
      status: 'Diserahkan',
      aksi: 'Menunggu'),
  PengajuanSurat(
      jenis: 'Surat Keterangan Usaha', status: 'Diproses', aksi: 'Menunggu'),
  PengajuanSurat(
      jenis: 'Surat Keterangan Lainnya', status: 'Ditolak', aksi: 'Menunggu'),
  PengajuanSurat(
      jenis: 'Surat Keterangan Status', status: 'Disetujui', aksi: 'Download'),
  PengajuanSurat(
      jenis: 'Surat Keterangan Penghasilan Orang Tua',
      status: 'Diserahkan',
      aksi: 'Menunggu'),
  PengajuanSurat(
      jenis: 'Surat Keterangan Belum Menikah',
      status: 'Disetujui',
      aksi: 'Download'),
  PengajuanSurat(
      jenis: 'Surat Keterangan Tidak Mampu',
      status: 'Ditolak',
      aksi: 'Menunggu'),
  PengajuanSurat(
      jenis: 'Surat Keterangan Usaha', status: 'Diproses', aksi: 'Menunggu'),
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

class PengajuanSk {
  final String title;
  final String icon;
  final String color;
  final String route;

  PengajuanSk(
      {required this.title,
      required this.icon,
      required this.color,
      required this.route});
}

final List<PengajuanSk> listCategorySk = [
  PengajuanSk(
    title: "Surat Keterangan Tidak Mampu (Listrik)",
    icon: "assets/icons/sktml_icon.png",
    color: "F3A889",
    route: "/sk_screen/sktml",
  ),
  PengajuanSk(
    title: "Surat Keterangan Tidak Mampu (Beasiswa)",
    icon: "assets/icons/sktmb_icon.png",
    color: "5C89DA",
    route: "/sk_screen/sktmb",
  ),
  PengajuanSk(
    title: "Surat Keterangan Penghasilan Orang Tua (Beasiswa)",
    icon: "assets/icons/skpot_icon.png",
    color: "899EC4",
    route: "/sk_screen/skpot",
  ),
  PengajuanSk(
    title: "Surat Keterangan Penghasilan (Bantuan)",
    icon: "assets/icons/skpb_icon.png",
    color: "BD3D3D",
    route: "/sk_screen/skpb",
  ),
  PengajuanSk(
    title: "Surat Keterangan Tidak Mampu (Sekolah)",
    icon: "assets/icons/sktms_icon.png",
    color: "254379",
    route: "/sk_screen/sktms",
  ),
  PengajuanSk(
    title: "Surat Keterangan Usaha",
    icon: "assets/icons/sku_icon.png",
    color: "3DB35B",
    route: "/sk_screen/sku",
  ),
  PengajuanSk(
    title: "Surat Keterangan Status",
    icon: "assets/icons/sks_icon.png",
    color: "F6BE05",
    route: "/sk_screen/sks",
  ),
  PengajuanSk(
    title: "Surat Keterangan Belum Menikah",
    icon: "assets/icons/skbm_icon.png",
    color: "E88B99",
    route: "/sk_screen/skbm",
  ),
  PengajuanSk(
    title: "Surat Keterangan Pekerjaan",
    icon: "assets/icons/skp_icon.png",
    color: "6652A1",
    route: "/sk_screen/skp",
  ),
];
