import 'package:flutter/material.dart';
import 'package:proyek2/screen/pengajuan/buat_surat_screen.dart';
import 'package:proyek2/screen/pengajuan/tracking/tracking_surat_screen.dart';
import 'package:proyek2/style/colors.dart';

class PengajuanScreen extends StatelessWidget {
  const PengajuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F5FF),
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
                  height: 130, 
                  width: double.infinity,
                  alignment: Alignment.topLeft,
                  child: const Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, top: 50.0),
                    child: Text(
                      "Pengajuan Surat",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0), 

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
            Positioned(
              top: 95, 
              left: 0,
              right: 0,
              child: Container(
                height: 50, 
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F5FF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
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
