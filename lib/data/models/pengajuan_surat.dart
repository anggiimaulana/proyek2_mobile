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
