import 'package:flutter/material.dart';
import 'package:proyek2/models/surat.dart';
import 'package:proyek2/view/widgets/surat_card.dart';

class BuatSuratScreen extends StatelessWidget {
  const BuatSuratScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.05),
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
