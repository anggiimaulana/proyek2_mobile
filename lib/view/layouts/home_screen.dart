import 'package:flutter/material.dart';
import 'package:proyek2/config/colors.dart';
import 'package:proyek2/view/widgets/berita_home.dart';
import 'package:proyek2/view/widgets/fitur_utama.dart';
import 'package:proyek2/view/widgets/header_home.dart';

class AppHomeScreen extends StatefulWidget {
  const AppHomeScreen({super.key});

  @override
  State<AppHomeScreen> createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const MyHeader(),
            SizedBox(
              height: size.height * 0.20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        "Fitur Utama",
                        style: TextStyle(
                          color: fbackgroundColor4,
                          fontSize: 18,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const FiturUtama(),
            SizedBox(height: size.height * 0.025),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        "Berita Desa Terkini",
                        style: TextStyle(
                          color: fbackgroundColor4,
                          fontSize: 18,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const BeritaHome(),
            SizedBox(
              height: size.height * 0.02,
            )
          ],
        ),
      ),
    );
  }
}
