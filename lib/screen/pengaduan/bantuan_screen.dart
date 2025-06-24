import 'package:flutter/material.dart';
import 'package:proyek2/style/colors.dart';

class Pengaduan {
  final String langkah;
  const Pengaduan(this.langkah);
}

class BantuanScreen extends StatelessWidget {
  const BantuanScreen({Key? key}) : super(key: key);

  final List<Pengaduan> langkahPengaduan = const [
    Pengaduan('Masuk ke aplikasi dan pilih menu "Pilih Pengaduan".'),
    Pengaduan('Pilih jenis pengaduan yang ingin Anda laporkan.'),
    Pengaduan(
        'Pastikan jenis layanan pengaduan sesuai dengan kategori masalah Anda, seperti: Sosial, Lingkungan, atau Infrastruktur.'),
    Pengaduan('Klik pada pengaduan yang telah dipilih.'),
    Pengaduan(
        'Isi formulir pengaduan dengan informasi yang diperlukan, seperti nama, dan data lainnya.'),
    Pengaduan(
        'Pilih kategori pengaduan yang sesuai. Jika tidak tersedia, Anda dapat memilih "Lainnya".'),
    Pengaduan(
        'Isi bagian Deskripsi dengan penjelasan lengkap mengenai aduan yang ingin Anda sampaikan.'),
    Pengaduan('Lengkapi juga informasi pada bagian Lokasi Kejadian.'),
    Pengaduan(
        'Pastikan Anda memiliki bukti pendukung berupa foto terkait laporan yang dibuat.'),
    Pengaduan(
        'Periksa kembali data yang telah diisi, lalu klik tombol "Laporkan".'),
    Pengaduan(
        'Laporan Anda berhasil dikirim. Silakan tunggu tindak lanjut dari petugas.'),
    Pengaduan(
        'Anda dapat memantau status pengaduan melalui menu "Riwayat Pelaporan".'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FF),
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: fbackgroundColor4,
          title: const Text(
            'Panduan Pelaporan',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          )),
      body: Expanded(
        child: SingleChildScrollView(
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
                      'Panduan Pelaporan',
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
                      'Ikuti langkah-langkah berikut untuk memastikan laporan Anda terkirim dengan benar.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Langkah-langkah Pelaporan:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: fbackgroundColor4,
                  fontSize: 18,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: langkahPengaduan.asMap().entries.map((entry) {
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
      ),
    );
  }
}

// Clipper untuk header melengkung
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Widget langkah dengan desain modern
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
