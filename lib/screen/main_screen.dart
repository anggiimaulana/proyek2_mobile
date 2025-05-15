import 'package:flutter/material.dart';
import 'package:proyek2/screen/home/home_screen.dart';
import 'package:proyek2/screen/pengajuan/pengajuan_screen.dart';
import 'package:proyek2/style/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  String? userName;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('name');

      if (mounted) {
        setState(() {
          userName = name;
        });
      }
    } catch (e) {
      print('Error getting user info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const AppHomeScreen(),
      const PengajuanScreen(),
      _buildPlaceholderScreen("Bansos"),
      _buildPlaceholderScreen("Pengaduan"),
      _buildPlaceholderScreen("Berita"),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: fbackgroundColor3, // Warna background
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
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
              label: "Beranda",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Iconsax.document,
                size: 22,
              ),
              label: "Pengajuan",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Iconsax.wallet,
                size: 22,
              ),
              label: "Bansos",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Iconsax.camera,
                size: 22,
              ),
              label: "Pengaduan",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Iconsax.gallery,
                size: 22,
              ),
              label: "Berita",
            ),
          ],
        ),
      ),
      body: pages[selectedIndex],
    );
  }

  // Helper method to create placeholder screens
  Widget _buildPlaceholderScreen(String title) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: fbackgroundColor4,
            ),
            const SizedBox(height: 16),
            Text(
              "Halaman $title",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: fbackgroundColor4,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Fitur ini sedang dalam pengembangan",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
