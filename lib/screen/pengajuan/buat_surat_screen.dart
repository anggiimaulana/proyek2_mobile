import 'package:flutter/material.dart';
import 'package:proyek2/screen/pengajuan/surat_card.dart';
import 'package:proyek2/data/models/pengajuan/surat/surat_list.dart';

class BuatSuratScreen extends StatelessWidget {
  const BuatSuratScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0), 
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10.0), 
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Ajukan pembuatan surat yang sesuai dengan kebutuhan Anda. Pilih kategori di bawah ini:",
                style: TextStyle(
                  fontSize: 16,
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
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: suratList.length,
              itemBuilder: (context, index) {
                final surat = suratList[index];
                return GestureDetector(
                  onTap: () {
                    if (surat.route.isNotEmpty) {
                      Navigator.pushNamed(context, surat.route);
                    } else {
                      debugPrint("Route kosong");
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
