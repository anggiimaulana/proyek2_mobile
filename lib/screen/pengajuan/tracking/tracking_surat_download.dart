import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import 'package:proyek2/data/api/api_services.dart';

Future<void> downloadFile({
  required BuildContext context,
  required String url,
  required String namaKategori,
  required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
}) async {
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
                        const SizedBox(height: 16),
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
                                color:
                                    progress < 1.0 ? Colors.blue : Colors.green,
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

    Uri? downloadUri;
    if (Uri.tryParse(url)?.hasScheme ?? false) {
      downloadUri = Uri.parse(url);
    } else {
      // Ganti ApiServices.baseUrl2 dengan baseUrl kamu
      const baseUrl = ApiServices.baseUrl2;
      final cleanPath = url.startsWith('/') ? url.substring(1) : url;
      downloadUri = Uri.parse('$baseUrl/$cleanPath');
    }

    if (Platform.isAndroid) {
      if (!(await Permission.storage.isGranted ||
          await Permission.manageExternalStorage.isGranted)) {
        final storageStatus = await Permission.storage.request();
        final manageStatus = await Permission.manageExternalStorage.request();

        if (!(storageStatus.isGranted || manageStatus.isGranted)) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Izin penyimpanan diperlukan untuk mengunduh file"),
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
      Directory? downloadDir = Directory('/storage/emulated/0/Download');
      if (!await downloadDir.exists()) {
        try {
          downloadDir.createSync(recursive: true);
        } catch (e) {}
      }
      if (await downloadDir.exists()) {
        downloadPath = '${downloadDir.path}/$fileName';
      } else {
        final appDir = await getExternalStorageDirectory();
        if (appDir != null) {
          downloadPath = '${appDir.path}/$fileName';
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
  }
}
