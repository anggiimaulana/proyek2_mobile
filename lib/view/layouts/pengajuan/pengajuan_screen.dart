import 'package:flutter/material.dart';
import 'package:proyek2/utils/colors.dart';

class PengajuanScreen extends StatelessWidget {
  const PengajuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: DefaultTabController(
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
                    height: size.height * 0.10,
                    width: double.infinity,
                    alignment: Alignment.topLeft,
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
                  SizedBox(
                      height: size.height *
                          0.03), // Untuk memberi ruang tab menimpa header

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
                top: size.height * 0.075, // Setengah masuk ke header
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
      ),
    );
  }
}

// Dummy Screen untuk tab
class BuatSuratScreen extends StatelessWidget {
  const BuatSuratScreen({super.key});

  final List<Map<String, String>> suratList = const [
    {
      "title": "Surat Keterangan",
      "subtitle": "6 Jenis surat",
      "icon": "assets/icons/sk_logo.png",
      "color": "F6BE05"
    },
    {
      "title": "Surat Pengantar Desa",
      "subtitle": "2 Jenis surat",
      "icon": "assets/icons/sp_logo.png",
      "color": "08AB31"
    },
    {
      "title": "Surat Rekomendasi",
      "subtitle": "3 Jenis surat",
      "icon": "assets/icons/sr_logo.png",
      "color": "6495ED"
    },
    {
      "title": "Pengajuan Surat Lainnya",
      "subtitle": "8 Jenis surat",
      "icon": "assets/icons/sl_logo.png",
      "color": "F6056D"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Tambahkan teks di tengah
          const Padding(
            padding: EdgeInsets.only(bottom: 10, top: 10, left: 5, right: 5),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Ajukan pembuatan surat yang sesuai kebutuhan Anda. Pilih kategori dibawah ini:",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 10), // Spasi antara teks dan GridView

          // GridView untuk daftar surat
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.77,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: suratList.length,
              itemBuilder: (context, index) {
                final surat = suratList[index];
                return SuratCard(
                  title: surat["title"]!,
                  subtitle: surat["subtitle"]!,
                  iconPath: surat["icon"]!,
                  colorHex: surat["color"]!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SuratCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconPath;
  final String colorHex;

  const SuratCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.colorHex,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color bgColor = Color(int.parse("0xFF$colorHex"));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kotak ikon (persegi panjang ke bawah)
            Container(
              width: size.width * 0.20,
              height: size.height * 0.10,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Image.asset(iconPath, width: 45, height: 45),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              title,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: size.height * 0.005),
            Row(
              children: [
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black54),
                ),
                const Icon(Icons.chevron_right, color: Colors.black45),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TrackingSuratScreen extends StatelessWidget {
  const TrackingSuratScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> data = [
      {
        'jenis': 'Surat Keterangan Tidak Mampu',
        'status': 'Diserahkan',
        'aksi': 'Menunggu'
      },
      {
        'jenis': 'Surat Keterangan Usaha',
        'status': 'Diproses',
        'aksi': 'Menunggu'
      },
      {
        'jenis': 'Surat Keterangan Lainnya',
        'status': 'Ditolak',
        'aksi': 'Menunggu'
      },
      {
        'jenis': 'Surat Keterangan Status',
        'status': 'Disetujui',
        'aksi': 'Download'
      },
      {
        'jenis': 'Surat Keterangan Penghasilan Orang Tua',
        'status': 'Diserahkan',
        'aksi': 'Menunggu'
      },
      {
        'jenis': 'Surat Keterangan Belum Menikah',
        'status': 'Disetujui',
        'aksi': 'Download'
      },
      {
        'jenis': 'Surat Keterangan Tidak Mampu',
        'status': 'Ditolak',
        'aksi': 'Menunggu'
      },
      {
        'jenis': 'Surat Keterangan Usaha',
        'status': 'Diproses',
        'aksi': 'Menunggu'
      },
    ];

    Color getStatusColor(String status) {
      switch (status) {
        case 'Diserahkan':
          return Colors.amber;
        case 'Diproses':
          return Colors.lightBlue;
        case 'Ditolak':
          return Colors.red;
        case 'Disetujui':
          return Colors.green;
        default:
          return Colors.grey;
      }
    }

    Color getAksiColor(String aksi) {
      return aksi == 'Menunggu'
          ? const Color.fromARGB(255, 98, 174, 209)
          : Colors.blue;
    }

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20, top: 10, left: 5, right: 5),
                child: Text(
                  "Lacak progres pengajuan surat Anda di sini untuk mengetahui status terkini pengajuan Anda.",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Table(
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
                  ...data.map((item) => TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(item['jenis']!),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(7.5),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: getStatusColor(item['status']!),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: Text(
                                    item['status']!,
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
                                  color: getAksiColor(item['aksi']!),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: Text(
                                    item['aksi']!,
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
            ],
          ),
        ),
      ),
    );
  }
}
