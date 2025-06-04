import 'package:flutter/material.dart';
import 'package:proyek2/provider/pengajuan/tracking_surat_provider.dart';
import 'package:proyek2/screen/pengajuan/edit_surat/skbm_edit_screen.dart';
import 'package:proyek2/screen/pengajuan/edit_surat/skp_edit_screen.dart';
import 'package:proyek2/screen/pengajuan/edit_surat/skpot_edit_screen.dart';
import 'package:proyek2/screen/pengajuan/edit_surat/sks_edit_screen..dart';
import 'package:proyek2/screen/pengajuan/edit_surat/sktm_beasiswa_edit_screen.dart';
import 'package:proyek2/screen/pengajuan/edit_surat/sktm_listrik_edit_screen.dart';
import 'package:proyek2/screen/pengajuan/edit_surat/sktm_sekolah_edit_screen.dart';
import 'package:proyek2/screen/pengajuan/edit_surat/sku_edit_screen.dart';
import 'package:proyek2/screen/pengajuan/tracking/action_button.dart';
import 'package:proyek2/style/colors.dart';

List<Widget> getActionWidgets({
  required BuildContext context,
  required TrackingSuratProvider provider,
  required String status,
  String? urlFile,
  String? namaKategori,
  required String pengajuanId,
  required int kategoriPengajuanId,
  required dynamic detailId,
  String? catatan,
  required Future<void> Function(String url, String namaKategori) downloadFile,
}) {
  switch (status.toLowerCase()) {
    case "diserahkan":
      return [
        ActionButton(
          text: "Tarik",
          color: Colors.redAccent,
          onPressed: () {
            _showConfirmationDialog(
              context,
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
                  bool success = await provider.deletePengajuan(pengajuanId);
                  Navigator.of(context).pop();
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Pengajuan berhasil ditarik"),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 3),
                      ),
                    );
                    await provider.refreshData();
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
              context,
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

void _showConfirmationDialog(BuildContext context, String title, String message,
    VoidCallback onConfirm) {
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

void _navigateToEditScreen(
  BuildContext context,
  int kategoriPengajuan,
  dynamic detailId,
  String pengajuanId,
  String? catatan,
) {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kategori pengajuan tidak dikenali"),
          backgroundColor: Colors.red,
        ),
      );
  }
}
