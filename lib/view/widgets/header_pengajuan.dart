import 'package:flutter/material.dart';
import 'package:proyek2/utils/colors.dart';
import 'package:proyek2/view/layouts/pengajuan/pengajuan_screen.dart';
import 'package:proyek2/view/layouts/pengajuan/tracking_pengajuan.dart';

class PengajuanPage extends StatelessWidget {
  const PengajuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Column(
        children: [
          // Stack untuk Header dan Tabs
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Background Header
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                  ),
                  color: fbackgroundColor3,
                ),
                height: size.height * 0.20,
                width: double.infinity,
                child: const Padding(
                  padding: EdgeInsets.only(top: 60, left: 15),
                  child: Text(
                    "Pengajuan",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              // Tabs di atas Header
              Positioned(
                top: size.height * 0.08,
                left: size.width * 0.05,
                right: size.width * 0.05,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: DefaultTabController(
                    length: 2, // Jumlah tab
                    child: Column(
                      children: [
                        // TabBar dengan Background Putih dan Teks Biru
                        const TabBar(
                          labelColor: Colors.blue,
                          unselectedLabelColor: Colors.blueGrey,
                          indicatorColor: Colors.blue,
                          tabs: [
                            Tab(text: "Buat Surat"),
                            Tab(text: "Tracking Surat"),
                          ],
                        ),

                        // Konten TabBar
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: const TabBarView(
                            children: [
                              PengajuanScreen(), // Halaman buat surat
                              TrackingPengajuan(), // Halaman tracking surat
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
