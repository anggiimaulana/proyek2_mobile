import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:proyek2/data/api/api_services.dart';
import 'package:proyek2/provider/pengajuan/tracking_surat_provider.dart';
import 'package:proyek2/screen/pengajuan/edit_surat/skbm_edit_screen.dart';
import 'package:proyek2/screen/pengajuan/edit_surat/skp_edit_screen.dart';
import 'package:proyek2/screen/pengajuan/edit_surat/skpot_edit_screen.dart';
import 'package:proyek2/screen/pengajuan/edit_surat/sks_edit_screen..dart';
import 'package:proyek2/screen/pengajuan/edit_surat/sktm_beasiswa_edit_screen.dart';
import 'package:proyek2/screen/pengajuan/edit_surat/sktm_listrik_edit_screen.dart';
import 'package:proyek2/screen/pengajuan/edit_surat/sktm_sekolah_edit_screen.dart';
import 'package:proyek2/screen/pengajuan/edit_surat/sku_edit_screen.dart';
import 'package:proyek2/style/colors.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class TrackingSuratScreen extends StatefulWidget {
  const TrackingSuratScreen({super.key});

  @override
  State<TrackingSuratScreen> createState() => _TrackingSuratScreenState();
}

class _TrackingSuratScreenState extends State<TrackingSuratScreen> {
  late TrackingSuratProvider _provider;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

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
  void initState() {
    super.initState();
    initNotification();
    _provider = Provider.of<TrackingSuratProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.startFetchingFromPrefs();
    });
  }

  @override
  void dispose() {
    super.dispose();
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
                            icon: const Icon(Icons.refresh),
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
                            final jenis = surat.namaKategoriPengajuan;
                            final status = surat.statusPengajuanText;
                            final urlFile = surat.urlFile;
                            final pengajuanId = surat.id.toString();
                            final detailId = surat.detailId;
                            final catatan = surat.catatan;
                            final kategoriPengajuanId =
                                surat.kategoriPengajuanId;

                            debugPrint(
                                'kategoriPengajuan value: ${surat.kategoriPengajuan}');
                            debugPrint(
                                'kategoriPengajuan runtimeType: ${surat.kategoriPengajuan.runtimeType}');
                            debugPrint(
                                'kategoriPengajuanId: $kategoriPengajuanId');

                            List<Widget> actionWidgets = getActionWidgets(
                              status,
                              urlFile: urlFile,
                              namaKategori: jenis,
                              pengajuanId: pengajuanId,
                              kategoriPengajuanId: kategoriPengajuanId,
                              detailId: detailId,
                              catatan: catatan,
                            );

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
                                      jenis,
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
                                        color: getStatusColor(status),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Text(
                                          status,
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
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: actionWidgets,
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
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
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
      ],
    );
  }

  Future<void> downloadFile(String url, String namaKategori) async {
    final ValueNotifier<double> progressNotifier = ValueNotifier<double>(0.0);
    final ValueNotifier<String> statusNotifier =
        ValueNotifier<String>("Memulai unduhan...");

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return ValueListenableBuilder<double>(
            valueListenable: progressNotifier,
            builder: (context, progress, child) {
              return ValueListenableBuilder<String>(
                valueListenable: statusNotifier,
                builder: (context, status, child) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    content: Container(
                      width: double.maxFinite,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.download,
                              size: 25,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            status,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.transparent,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  progress < 1.0 ? Colors.blue : Colors.green,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${(progress * 100).toInt()}%",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: progress < 1.0
                                      ? Colors.blue
                                      : Colors.green,
                                ),
                              ),
                              if (progress > 0 && progress < 1.0)
                                Text(
                                  "Mengunduh...",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      );

      debugPrint("Original URL: $url");

      Uri? downloadUri;
      if (Uri.tryParse(url)?.hasScheme ?? false) {
        downloadUri = Uri.parse(url);
      } else {
        const baseUrl = ApiServices.baseUrl2;
        final cleanPath = url.startsWith('/') ? url.substring(1) : url;
        downloadUri = Uri.parse('$baseUrl/$cleanPath');
      }

      debugPrint("Final download URL: ${downloadUri.toString()}");

      if (Platform.isAndroid) {
        if (!(await Permission.storage.isGranted ||
            await Permission.manageExternalStorage.isGranted)) {
          final storageStatus = await Permission.storage.request();
          final manageStatus = await Permission.manageExternalStorage.request();

          if (!(storageStatus.isGranted || manageStatus.isGranted)) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text("Izin penyimpanan diperlukan untuk mengunduh file"),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
        }
      }

      String fileName =
          '${namaKategori.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';

      if (!fileName.contains('.')) {
        fileName = '$fileName.pdf';
      }

      String? downloadPath;

      if (Platform.isAndroid) {
        try {
          Directory? downloadDir = Directory('/storage/emulated/0/Download');
          if (!await downloadDir.exists()) {
            try {
              downloadDir.createSync(recursive: true);
            } catch (e) {
              debugPrint("Error creating Download directory: $e");
            }
          }
          if (await downloadDir.exists()) {
            downloadPath = '${downloadDir.path}/$fileName';
            debugPrint("Will save to Downloads folder: $downloadPath");
          } else {
            throw Exception(
                "Download directory doesn't exist and couldn't be created");
          }
        } catch (e) {
          debugPrint("Could not access Download directory: $e");
          final appDir = await getExternalStorageDirectory();
          if (appDir != null) {
            downloadPath = '${appDir.path}/$fileName';
            debugPrint("Falling back to app directory: $downloadPath");
          } else {
            throw Exception("Cannot access any storage directories");
          }
        }
      } else if (Platform.isIOS) {
        final directory = await getApplicationDocumentsDirectory();
        downloadPath = '${directory.path}/$fileName';
      }

      if (downloadPath == null) {
        throw Exception("Cannot determine download path");
      }

      Dio dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        followRedirects: true,
      ));

      await dio.download(
        downloadUri.toString(),
        downloadPath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final newProgress = received / total;
            final percentage = (newProgress * 100).toInt();

            progressNotifier.value = newProgress;
            statusNotifier.value = percentage < 100
                ? "Mengunduh file... ($percentage%)"
                : "Unduhan selesai! 🎉";

            debugPrint('Unduhan Progress: $percentage%');
          }
        },
      );

      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.pop(context);
      progressNotifier.dispose();
      statusNotifier.dispose();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "File berhasil diunduh ke folder Download: $fileName",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );

      await flutterLocalNotificationsPlugin.show(
        0,
        '✅ Unduhan Selesai',
        'File $fileName berhasil diunduh! Klik untuk membuka.',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'download_channel',
            'Download Notifikasi',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
          ),
        ),
        payload: downloadPath,
      );
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Gagal mengunduh file: ${e.toString()}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 5),
        ),
      );
      debugPrint("Download error: $e");
    }
  }

  List<Widget> getActionWidgets(
    String status, {
    String? urlFile,
    String? namaKategori,
    required String pengajuanId,
    required int kategoriPengajuanId,
    required dynamic detailId,
    String? catatan,
  }) {
    switch (status.toLowerCase()) {
      case "diserahkan":
        return [
          ActionButton(
            text: "Tarik",
            color: Colors.redAccent,
            onPressed: () {
              _showConfirmationDialog(
                "Tarik Pengajuan",
                "Apakah Anda yakin ingin menarik pengajuan ini?",
                () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text("Menarik pengajuan..."),
                        ],
                      ),
                    ),
                  );
                  try {
                    bool success = await Provider.of<TrackingSuratProvider>(
                            context,
                            listen: false)
                        .deletePengajuan(pengajuanId);
                    Navigator.of(context).pop();
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Pengajuan berhasil ditarik"),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 3),
                        ),
                      );
                      await _provider.refreshData();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Gagal menarik pengajuan. Kemungkinan:\n• Pengajuan sudah diproses\n• Token tidak valid\n• Tidak ada izin akses"),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 5),
                        ),
                      );
                    }
                  } catch (e) {
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop();
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error koneksi: ${e.toString()}"),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  }
                },
              );
            },
          )
        ];
      case "diproses":
      case "direvisi":
        return [
          const ActionButton(
            text: "Menunggu",
            color: Colors.blue,
            onPressed: null,
          ),
        ];
      case "disetujui":
        return [
          ActionButton(
            text: "Unduh",
            color: fbackgroundColor4,
            onPressed: urlFile == null || urlFile.isEmpty
                ? null
                : () async {
                    debugPrint("URL File to download: $urlFile");
                    await downloadFile(urlFile, namaKategori ?? 'Document');
                  },
          ),
        ];
      case "ditolak":
        return [
          ActionButton(
            text: "Perbarui",
            color: Colors.deepOrangeAccent,
            onPressed: () {
              _navigateToEditScreen(
                kategoriPengajuanId,
                detailId,
                pengajuanId,
                catatan,
              );
            },
          ),
        ];
      default:
        return [
          const ActionButton(
            text: "Menunggu",
            color: Colors.grey,
            onPressed: null,
          ),
        ];
    }
  }

  void _navigateToEditScreen(
    int kategoriPengajuan,
    dynamic detailId,
    String pengajuanId,
    String? catatan,
  ) {
    // Pastikan detailId dikirim sesuai tipe parameter pada screen
    switch (kategoriPengajuan) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SktmListrikEditScreen(
                detailId: detailId is int
                    ? detailId
                    : int.tryParse(detailId.toString()) ?? 0,
                pengajuanId: pengajuanId,
                catatan: catatan,
                ),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SktmBeasiswaEditScreen(
                detailId: detailId is int
                    ? detailId
                    : int.tryParse(detailId.toString()) ?? 0,
                pengajuanId: pengajuanId,
                catatan: catatan,
                ),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SktmSekolahEditScreen(
                detailId: detailId is int
                    ? detailId
                    : int.tryParse(detailId.toString()) ?? 0,
                pengajuanId: pengajuanId,
                catatan: catatan,
                ),
          ),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SksEditScreen(
                detailId: detailId is int
                    ? detailId
                    : int.tryParse(detailId.toString()) ?? 0,
                pengajuanId: pengajuanId,
                catatan: catatan,
                ),
          ),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SkbmEditScreen(
                detailId: detailId is int
                    ? detailId
                    : int.tryParse(detailId.toString()) ?? 0,
                pengajuanId: pengajuanId,
                catatan: catatan,
                ),
          ),
        );
        break;
      case 6:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SkpEditScreen(
                detailId: detailId is int
                    ? detailId
                    : int.tryParse(detailId.toString()) ?? 0,
                pengajuanId: pengajuanId,
                catatan: catatan,
                ),
          ),
        );
        break;
      case 7:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SkpotEditScreen(
                detailId: detailId is int
                    ? detailId
                    : int.tryParse(detailId.toString()) ?? 0,
                pengajuanId: pengajuanId,
                catatan: catatan,
                ),
          ),
        );
        break;
      case 8:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SkuEditScreen(
              kategoriPengajuan: kategoriPengajuan,
              detailId: detailId is int
                  ? detailId
                  : int.tryParse(detailId.toString()) ?? 0,
              pengajuanId: pengajuanId,
              catatan: catatan,
            ),
          ),
        );
        break;
      default:
        debugPrint('[ERROR] Kategori pengajuan tidak dikenali!');
        debugPrint('kategoriPengajuan: $kategoriPengajuan');
        debugPrint('detailId: $detailId');
        debugPrint('pengajuanId: $pengajuanId');
        debugPrint('catatan: $catatan');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Kategori pengajuan tidak dikenali"),
            backgroundColor: Colors.red,
          ),
        );
    }
  }

  void _showConfirmationDialog(
      String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(title),
          content: Text(message),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Batal", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[800],
                textStyle: const TextStyle(fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: const Text("Ya"),
            ),
          ],
        );
      },
    );
  }
}

class ActionButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback? onPressed;

  const ActionButton({
    required this.text,
    required this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case "disetujui":
      return Colors.green;
    case "ditolak":
      return Colors.red;
    case "diproses":
      return Colors.lightBlue;
    case "diserahkan":
      return Colors.amber;
    case "direvisi":
      return Colors.orange;
    default:
      return Colors.grey;
  }
}
