import 'package:flutter/material.dart';
import 'package:proyek2/style/colors.dart';

class Pengajuan {
  final String langkah;
  const Pengajuan(this.langkah);
}

class BantuanSuratScreen extends StatelessWidget {
  const BantuanSuratScreen({super.key});

  final List<Pengajuan> langkahPengajuan = const [
    Pengajuan('Masuk ke aplikasi dan pilih menu "Pengajuan Surat".'),
    Pengajuan(
        'Pilih kategori "Buat Surat" untuk mengajukan surat baru, atau "Tracking Surat" untuk memantau status pengajuan Anda.'),
    Pengajuan(
        'Pilih jenis surat yang ingin diajukan. Terdapat berbagai jenis surat yang tersedia seperti: Surat Keterangan Tidak Mampu, Surat Keterangan Penghasilan Orang Tua, Surat Keterangan Status, Surat Keterangan Belum Menikah, Surat Keterangan Pekerjaan, dan Surat Keterangan Usaha.'),
    Pengajuan(
        'Lengkapi formulir pengajuan surat dengan mengisi semua data yang diperlukan sesuai dengan jenis surat yang dipilih.'),
    Pengajuan(
        'Unggah dokumen pendukung yang diperlukan sesuai permintaan pada formulir, seperti: Kartu Keluarga (KK), Kartu Tanda Penduduk (KTP), atau dokumen lainnya.'),
    Pengajuan(
        'Periksa kembali semua data dan dokumen yang telah diisi untuk memastikan kelengkapan dan kebenaran informasi.'),
    Pengajuan(
        'Klik tombol "Ajukan" untuk mengirim permohonan surat ke sistem.'),
    Pengajuan(
        'Untuk melihat perkembangan status pengajuan surat Anda, masuk ke menu "Tracking Surat".'),
    Pengajuan(
        'Pada halaman tracking terdapat tabel yang berisi kolom jenis surat, status pengajuan, dan aksi yang dapat dilakukan.'),
    Pengajuan(
        'Status pengajuan surat terdiri dari:\n• Diserahkan: Pengajuan baru saja dibuat dan menunggu untuk ditinjau\n• Diproses: Pengajuan sedang diperiksa oleh petugas admin dan kepala desa\n• Ditolak: Terdapat kesalahan atau data tidak sesuai dengan persyaratan\n• Direvisi: Pengajuan perlu diperbaiki dan dikirim ulang\n• Disetujui: Surat telah ditandatangani dan siap untuk diunduh'),
    Pengajuan(
        'Kolom aksi akan menyesuaikan dengan status pengajuan saat ini:\n• Tarik: Menarik atau membatalkan pengajuan (untuk status Diserahkan)\n• Menunggu: Pengajuan dalam proses verifikasi (untuk status Diproses/Direvisi)\n• Perbarui: Mengajukan ulang dengan data yang telah diperbaiki (untuk status Ditolak)\n• Unduh: Mengunduh surat yang telah selesai (untuk status Disetujui)'),
    Pengajuan(
        'Klik tombol "Refresh Data" untuk memperbarui dan melihat status pengajuan terbaru secara manual.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FF),
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: fbackgroundColor4,
          title: const Text(
            'Panduan Pengajuan Surat',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 248, 246, 246),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Panduan Pengajuan Surat',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: fbackgroundColor4,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Ikuti langkah-langkah berikut untuk mengajukan surat keterangan secara digital dan memantau status pengajuan Anda dengan mudah.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Langkah-langkah Pengajuan dan Tracking:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: fbackgroundColor4,
                fontSize: 18,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: langkahPengajuan.asMap().entries.map((entry) {
                final index = entry.key + 1;
                final item = entry.value;
                return _StepCard(
                  number: index,
                  text: item.langkah,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final int number;
  final String text;

  const _StepCard({Key? key, required this.number, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 248, 246, 246),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: fbackgroundColor3,
            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}
