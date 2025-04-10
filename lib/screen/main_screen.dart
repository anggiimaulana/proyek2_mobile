import 'package:flutter/material.dart';
import 'package:proyek2/screen/home/home_screen.dart';
import 'package:proyek2/screen/pengajuan/pengajuan_screen.dart';
import 'package:proyek2/utils/colors.dart';
import 'package:iconsax/iconsax.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() =>
      _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  final List pages = [
    const AppHomeScreen(),
    const PengajuanScreen(),
    const Scaffold(),
    const Scaffold(),
    const Scaffold(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        height: 57, // Tambah tinggi navbar
        decoration: BoxDecoration(
          color: fbackgroundColor3, // Warna background
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: BottomNavigationBar(
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          selectedFontSize: 11,
          unselectedFontSize: 11,
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
                  size: 22,
                ),
                label: "Beranda"),
            BottomNavigationBarItem(
                icon: Icon(
                  Iconsax.document,
                  size: 22,
                ),
                label: "Pengajuan"),
            BottomNavigationBarItem(
                icon: Icon(
                  Iconsax.wallet,
                  size: 22,
                ),
                label: "Bansos"),
            BottomNavigationBarItem(
                icon: Icon(
                  Iconsax.camera,
                  size: 22,
                ),
                label: "Pengaduan"),
            BottomNavigationBarItem(
                icon: Icon(
                  Iconsax.gallery,
                  size: 22,
                ),
                label: "Berita"),
          ],
        ),
      ),
      body: pages[selectedIndex],
    );
  }
}
