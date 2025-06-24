import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:proyek2/provider/pengajuan/tracking_surat_provider.dart';
import 'package:proyek2/screen/pengajuan/tracking/tracking_surat_action.dart';
import 'package:proyek2/screen/pengajuan/tracking/tracking_surat_download.dart';
import 'package:proyek2/style/colors.dart';

class TrackingSuratScreen extends StatefulWidget {
  const TrackingSuratScreen({super.key});

  @override
  State<TrackingSuratScreen> createState() => _TrackingSuratScreenState();
}

class _TrackingSuratScreenState extends State<TrackingSuratScreen> {
  late TrackingSuratProvider _provider;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initNotification();
    _provider = Provider.of<TrackingSuratProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.startFetchingFromPrefs();
    });
  }

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null) {
          if (payload == 'tracking_screen') {
            _provider.refreshData();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Data telah diperbarui berdasarkan notifikasi"),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            OpenFile.open(payload);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrackingSuratProvider>(context);
    final pengajuanList = provider.pengajuanData?.data ?? [];

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 10, left: 14, right: 14),
          child: Text(
            "Lacak progres pengajuan surat Anda di sini untuk mengetahui status terkini pengajuan Anda.",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await provider.refreshData();
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (provider.isLoading)
                      const Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text("Memuat data pengajuan..."),
                          ],
                        ),
                      )
                    else if (provider.errorMessage != null)
                      Center(
                        child: Column(
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.red, size: 48),
                            const SizedBox(height: 8),
                            Text(
                              provider.errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => provider.refreshData(),
                              icon: const Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                              label: const Text("Coba Lagi"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (pengajuanList.isEmpty)
                      Center(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.assignment_outlined,
                                    color: Colors.grey,
                                    size: 64,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    "Belum Ada Pengajuan",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Anda belum memiliki pengajuan surat apapun.\nSilakan buat pengajuan baru terlebih dahulu.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Table(
                          columnWidths: const {
                            0: FlexColumnWidth(1.35),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1),
                          },
                          border: TableBorder.all(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black12,
                          ),
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                color: fbackgroundColor3,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              children: const [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Center(
                                      child: Text(
                                        "Jenis Surat",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Center(
                                      child: Text(
                                        "Status",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Center(
                                      child: Text(
                                        "Aksi",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ...pengajuanList.map((surat) {
                              return TableRow(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF1F5FF),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        surat.namaKategoriPengajuan,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 6,
                                          horizontal: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: getStatusColor(
                                              surat.statusPengajuanText),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Text(
                                            surat.statusPengajuanText,
                                            style: TextStyle(
                                              color: getTextStatusColor(
                                                  surat.statusPengajuanText),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: getActionWidgets(
                                            context: context,
                                            provider: _provider,
                                            status: surat.statusPengajuanText,
                                            urlFile: surat.urlFile,
                                            namaKategori:
                                                surat.namaKategoriPengajuan,
                                            pengajuanId: surat.id.toString(),
                                            kategoriPengajuanId:
                                                surat.kategoriPengajuanId,
                                            detailId: surat.detailId,
                                            catatan: surat.catatan,
                                            downloadFile: (url, namaKategori) =>
                                                downloadFile(
                                              context: context,
                                              url: url,
                                              namaKategori: namaKategori,
                                              flutterLocalNotificationsPlugin:
                                                  flutterLocalNotificationsPlugin,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: provider.isLoading
                            ? null
                            : () {
                                provider.refreshData();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Memperbarui data..."),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                        icon: provider.isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                        label: Text(provider.isLoading
                            ? "Memperbarui..."
                            : "Refresh Data"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: fbackgroundColor3,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
