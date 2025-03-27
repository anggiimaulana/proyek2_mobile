import 'package:flutter/material.dart';
import 'package:proyek2/utils/colors.dart';
import 'package:proyek2/models/surat.dart';
import 'package:proyek2/widgets/category_sk.dart';
import 'package:proyek2/widgets/surat_card.dart';

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

class BuatSuratScreen extends StatelessWidget {
  const BuatSuratScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding:
          EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.05),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.010),
            child: const Align(
              alignment: Alignment.center,
              child: Text(
                "Ajukan pembuatan surat yang sesuai kebutuhan Anda. Pilih kategori di bawah ini:",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.77,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: suratList.length,
              itemBuilder: (context, index) {
                final surat = suratList[index];
                return GestureDetector(
                  onTap: () {
                    if (surat.route?.isNotEmpty ?? false) {
                      Navigator.pushNamed(context, surat.route!);
                    } else {
                      print("Route kosong atau null");
                    }
                  },
                  child: SuratCard(
                    title: surat.title,
                    subtitle: surat.subtitle,
                    iconPath: surat.iconPath,
                    colorHex: surat.colorHex,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TrackingSuratScreen extends StatelessWidget {
  const TrackingSuratScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: size.width * 0.05, right: size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.010),
                child: const Text(
                  "Lacak progres pengajuan surat Anda di sini untuk mengetahui status terkini pengajuan Anda.",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.03),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1.35),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                  },
                  border: TableBorder.all(
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(14),
                        bottomLeft: Radius.circular(14)),
                    color: Colors.black12,
                  ),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: fbackgroundColor3,
                      ),
                      children: const [
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                "Jenis Surat",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                "Status",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                "Aksi",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...dummyPengajuanSurat
                        .map((PengajuanSurat surat) => TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(surat.jenis),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(7.5),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: getStatusColor(surat.status),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Center(
                                        child: Text(
                                          surat.status,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(7.5),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: getAksiColor(surat.aksi),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Center(
                                        child: Text(
                                          surat.aksi,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SkScreen extends StatelessWidget {
  const SkScreen({super.key});

  void navigateToRoute(BuildContext context, String? route) {
    if (route?.isNotEmpty ?? false) {
      Navigator.pushNamed(context, route!);
    } else {
      print("Route kosong atau null");
    }
  }

  List<Widget> buildCategoryItems(BuildContext context) {
    return listCategorySk.map((surat) {
      return GestureDetector(
        onTap: () => navigateToRoute(context, surat.route),
        child: CardCategorySk(
          title: surat.title,
          icon: surat.icon,
          color: surat.color,
          route: surat.route,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Pengajuan Surat Keterangan",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: fbackgroundColor3,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: size.height * 0.025,
                right: size.width * 0.05,
                left: size.width * 0.05),
            child: const Align(
              alignment: Alignment.center,
              child: Text(
                "Silahkan pilih surat keterangan yang ingin Anda ajukan!",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 0.80,
                crossAxisSpacing: size.width * 0.03,
                mainAxisSpacing: size.height * 0.02,
                children: buildCategoryItems(context),
              ),
            ),
          )
        ],
      ),
    );
  }
}
