import 'package:flutter/material.dart';
import 'package:proyek2/style/colors.dart';
import 'package:proyek2/screen/pengaduan/form_lingkungan.dart';
import 'package:proyek2/screen/pengaduan/form_sosial.dart';
import 'package:proyek2/screen/pengaduan/form_infrastruktur.dart';

class BuatLaporanScreen extends StatelessWidget {
  const BuatLaporanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FF),
      appBar: AppBar(
        backgroundColor: fbackgroundColor4,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pilih Kategori Pengaduan',
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 248, 246, 246),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'PILIH KATEGORI PENGADUAN',
                    style: TextStyle(
                      fontSize: 16,
                      color: fbackgroundColor4,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Menu ini berisi informasi mengenai layanan apa saja yang ada pada form pengaduan masyarakat.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: const [
                  _KategoriCard(
                    iconPath: 'assets/icons/peng_lingkungan.png',
                    title: 'Pengaduan Lingkungan',
                  ),
                  _KategoriCard(
                    iconPath: 'assets/icons/peng_sosial.png',
                    title: 'Pengaduan Sosial',
                  ),
                  _KategoriCard(
                    iconPath: 'assets/icons/peng_infrastruktur.png',
                    title: 'Pengaduan Infrastruktur',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KategoriCard extends StatelessWidget {
  final String iconPath;
  final String title;

  const _KategoriCard({
    Key? key,
    required this.iconPath,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 248, 246, 246),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          if (title == 'Pengaduan Lingkungan') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FormLingkungan()),
            );
          } else if (title == 'Pengaduan Sosial') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FormSosial()),
            );
          } else if (title == 'Pengaduan Infrastruktur') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FormInfrastruktur()),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconPath,
                height: 60,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 1),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height:8,),
              const Icon(Icons.arrow_forward_ios, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}
