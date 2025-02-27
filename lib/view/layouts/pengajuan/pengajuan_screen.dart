import 'package:flutter/material.dart';
import 'package:proyek2/utils/colors.dart';

class PengajuanScreen extends StatelessWidget {
  const PengajuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header + Tabs
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Background Header
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(0),
                    ),
                    color: fbackgroundColor3,
                  ),
                  height: size.height * 0.12,
                  width: double.infinity,
                  child: const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Pengajuan Surat",
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
                  top: size.height * 0.080,
                  left: size.width * 0,
                  right: size.width * 0,
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        Container(
                          height: size.height * 0.06,
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
                        SizedBox(
                          height: size.height * 0.6,
                          child: const TabBarView(
                            children: [
                              BuatSuratScreen(),
                              TrackingSuratScreen(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy Screen untuk tab
class BuatSuratScreen extends StatelessWidget {
  const BuatSuratScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Halaman Buat Surat"));
  }
}

class TrackingSuratScreen extends StatelessWidget {
  const TrackingSuratScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Halaman Tracking Surat"));
  }
}
