import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:proyek2/utils/colors.dart';
import 'package:proyek2/view/layouts/home_screen.dart';
import 'package:proyek2/view/layouts/pengajuan/pengajuan_screen.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int selectedIndex = 0;
  final List pages = [
    const AppHomeScreen(),
    const PengajuanScreen(),
    Scaffold(),
    Scaffold(),
    Scaffold(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        height: 65, // Tambah tinggi navbar
        decoration: BoxDecoration(
          color: fbackgroundColor3, // Warna background
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: BottomNavigationBar(
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          unselectedItemColor: Colors.white60,
          selectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          onTap: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          elevation: 0,
          backgroundColor: Colors.transparent,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Iconsax.home_14,
                  size: 26,
                ),
                label: "Beranda"),
            BottomNavigationBarItem(
                icon: Icon(
                  Iconsax.document,
                  size: 26,
                ),
                label: "Pengajuan"),
            BottomNavigationBarItem(
                icon: Icon(
                  Iconsax.wallet,
                  size: 26,
                ),
                label: "Bansos"),
            BottomNavigationBarItem(
                icon: Icon(
                  Iconsax.camera,
                  size: 26,
                ),
                label: "Pengaduan"),
            BottomNavigationBarItem(
                icon: Icon(
                  Iconsax.gallery,
                  size: 26,
                ),
                label: "Berita"),
          ],
        ),
      ),
      body: pages[selectedIndex],
    );
  }
}
