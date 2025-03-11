import 'package:flutter/material.dart';
import 'package:proyek2/models/surat.dart';
import 'package:proyek2/view/widgets/surat_card.dart';

class BuatSuratScreen extends StatelessWidget {
  const BuatSuratScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10, top: 10, left: 5, right: 5),
            child: Align(
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
          const SizedBox(height: 10),
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
