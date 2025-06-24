import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:proyek2/data/api/api_services.dart';
import 'package:proyek2/data/models/bansos/bansos_model.dart';
import 'package:proyek2/style/colors.dart';
import 'dart:convert';
import 'form.dart';

class BansosPage extends StatefulWidget {
  const BansosPage({super.key});

  @override
  State<BansosPage> createState() => _BansosPageState();
}

class _BansosPageState extends State<BansosPage> with TickerProviderStateMixin {
  TextEditingController _searchControllerProses = TextEditingController();
  TextEditingController _searchControllerSelesai = TextEditingController();

  int _currentPageProses = 1;
  int _currentPageSelesai = 1;
  final int _itemsPerPage = 5;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Timer untuk update jam
  Timer? _timer;
  String _currentTime = '';
  String _currentDate = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();

    // Initialize waktu dan mulai timer
    _updateDateTime();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateDateTime();
    });
  }

  void _updateDateTime() {
    setState(() {
      _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
      _currentDate =
          DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now());
    });
  }

  @override
  void dispose() {
    _searchControllerProses.dispose();
    _searchControllerSelesai.dispose();
    _animationController.dispose();
    _timer?.cancel(); // Cancel timer saat dispose
    super.dispose();
  }

  Future<List<Pengajuan>> fetchAllData() async {
    List<Pengajuan> allData = [];
    const urlBansos = ApiServices.urlBansos;

    for (int id = 1; id <= 3; id++) {
      final response = await http.get(Uri.parse(
          '$urlBansos/get_pengajuan.php?id_jenis_bansos=$id'));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        allData.addAll(
            jsonResponse.map((data) => Pengajuan.fromJson(data)).toList());
      } else {
        throw Exception('Gagal load data untuk id: $id');
      }
    }
    return allData;
  }

  Widget buildDashboardCard(
      String title, String count, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            SizedBox(height: 15),
            Text(
              count,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaginationButton(
      int page, int currentPage, Function(int) onPressed) {
    bool isSelected = page == currentPage;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3),
      child: Material(
        color: isSelected ? Colors.blue : Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => onPressed(page),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey[300]!,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$page',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPagination(
      int totalItems, int currentPage, Function(int) onPageChanged) {
    int totalPages = (totalItems / _itemsPerPage).ceil();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed:
              currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
          color: Colors.grey[700],
        ),
        ...List.generate(
          totalPages,
          (index) =>
              buildPaginationButton(index + 1, currentPage, onPageChanged),
        ),
        IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
          color: Colors.grey[700],
        ),
      ],
    );
  }

  Widget buildStatusTable(
      List<Pengajuan> data,
      String title,
      TextEditingController controller,
      int currentPage,
      Function(int) onPageChanged) {
    List<Pengajuan> filteredData = data
        .where(
            (e) => e.nama.toLowerCase().contains(controller.text.toLowerCase()))
        .toList();

    int startIndex = (currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    if (endIndex > filteredData.length) {
      endIndex = filteredData.length;
    }

    List<Pengajuan> paginatedData = filteredData.sublist(
      startIndex,
      endIndex,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.grey[800],
                ),
              ),
              Container(
                width: 120,
                height: 45,
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Cari',
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blue, width: 1),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (title.contains('Diproses')) {
                        _currentPageProses = 1;
                      } else {
                        _currentPageSelesai = 1;
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
              dataRowHeight: 60,
              headingRowHeight: 60,
              columnSpacing: 30,
              columns: const [
                DataColumn(
                    label: Text('No',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('No Permohonan',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Nama',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Tgl Pengajuan',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Layanan',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Status',
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: paginatedData.isNotEmpty
                  ? List<DataRow>.generate(
                      paginatedData.length,
                      (index) => DataRow(
                        cells: [
                          DataCell(Text('${startIndex + index + 1}')),
                          DataCell(Text(paginatedData[index].idPengajuan)),
                          DataCell(Text(paginatedData[index].nama)),
                          DataCell(Text(paginatedData[index].tglPengajuan)),
                          DataCell(Text(paginatedData[index].namaBansos)),
                          DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color:
                                    paginatedData[index].status.toLowerCase() ==
                                            'proses'
                                        ? Colors.orange
                                        : paginatedData[index]
                                                    .status
                                                    .toLowerCase() ==
                                                'disetujui'
                                            ? Colors.green
                                            : Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                paginatedData[index].status,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : [
                      DataRow(cells: [
                        DataCell(Text('-')),
                        DataCell(Text('-')),
                        DataCell(Text('Data tidak ditemukan')),
                        DataCell(Text('-')),
                        DataCell(Text('-')),
                        DataCell(Text('-')),
                      ])
                    ],
            ),
          ),
          if (filteredData.length > _itemsPerPage) ...[
            SizedBox(height: 20),
            buildPagination(filteredData.length, currentPage, onPageChanged),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: fbackgroundColor4,
        title: const Row(
          children: [
            Text(
              "Layanan Bansos",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Pengajuan>>(
        future: fetchAllData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final allData = snapshot.data!;

            final menungguDiproses = allData
                .where((e) =>
                    e.status.toLowerCase() != 'disetujui' &&
                    e.status.toLowerCase() != 'ditolak')
                .toList();

            final selesai = allData
                .where((e) =>
                    e.status.toLowerCase() == 'disetujui' ||
                    e.status.toLowerCase() == 'ditolak')
                .toList();

            return FadeTransition(
              opacity: _fadeAnimation,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Header Section dengan jam realtime
                  Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[400]!, Colors.blue[600]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Image.asset('assets/images/bupati.png', width: 150),
                        SizedBox(height: 20),
                        Text(
                          "Pelayanan Bantuan Sosial Desa",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Text(
                                _currentTime,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                _currentDate,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 25),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue[600],
                            minimumSize: Size(200, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FormPage()),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                color: Colors.blue[600],
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Daftar Pengajuan Bansos",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),

                  // Dashboard Statistics
                  Text(
                    "Statistik Pengajuan Bansos",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: buildDashboardCard(
                          "Dalam Proses",
                          "${menungguDiproses.length}",
                          Icons.access_time,
                          Colors.orange,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: buildDashboardCard(
                          "Selesai",
                          "${selesai.length}",
                          Icons.check_circle,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  // Tables
                  buildStatusTable(
                    menungguDiproses,
                    'Data Diproses',
                    _searchControllerProses,
                    _currentPageProses,
                    (page) {
                      setState(() {
                        _currentPageProses = page;
                      });
                    },
                  ),
                  SizedBox(height: 30),
                  buildStatusTable(
                    selesai,
                    'Data Selesai',
                    _searchControllerSelesai,
                    _currentPageSelesai,
                    (page) {
                      setState(() {
                        _currentPageSelesai = page;
                      });
                    },
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red),
                  SizedBox(height: 20),
                  Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                SizedBox(height: 20),
                Text(
                  'Memuat data...',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
