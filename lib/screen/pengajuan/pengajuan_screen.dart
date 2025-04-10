import 'package:flutter/material.dart';
import 'package:proyek2/screen/pengajuan/buat_surat_screen.dart';
import 'package:proyek2/screen/pengajuan/tracking_surat_screen.dart';
import 'package:proyek2/style/colors.dart';

class PengajuanScreen extends StatelessWidget {
  const PengajuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              children: [
                // Header
                Container(
                  decoration: BoxDecoration(
                    color: fbackgroundColor3,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(0),
                    ),
                  ),
                  height: size.height * 0.17,
                  width: double.infinity,
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: size.width * 0.05,
                      top: size.height * 0.065,
                    ),
                    child: const Text(
                      "Pengajuan Surat",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    height: size.height *
                        0.03),

                // Tab View
                const Expanded(
                  child: TabBarView(
                    children: [
                      BuatSuratScreen(),
                      TrackingSuratScreen(),
                    ],
                  ),
                ),
              ],
            ),

            // Tab Bar Menimpa Header
            Positioned(
              top: size.height * 0.12, // Setengah masuk ke header
              left: 0,
              right: 0,
              child: Container(
                height: size.height * 0.06,
                width: size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: TabBar(
                  labelColor: fbackgroundColor4,
                  unselectedLabelColor: Colors.blueGrey,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: fbackgroundColor4,
                  tabs: const [
                    Tab(text: "Buat Surat"),
                    Tab(text: "Tracking Surat"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}