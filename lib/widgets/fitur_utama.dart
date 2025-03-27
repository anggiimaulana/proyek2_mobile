import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:proyek2/utils/colors.dart';

class FiturUtama extends StatefulWidget {
  const FiturUtama({super.key});

  @override
  State<FiturUtama> createState() => _FiturUtamaState();
}

class _FiturUtamaState extends State<FiturUtama> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> fiturList = [
      {
        "icon": Iconsax.document,
        "label": "Pengajuan Surat",
      },
      {
        "icon": Iconsax.money,
        "label": "Bantuan Sosial Desa",
      },
      {
        "icon": Iconsax.camera,
        "label": "Pengaduan Masyarakat",
      },
      {
        "icon": Iconsax.gallery,
        "label": "Berita Desa Terkini",
      },
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(fiturList.length, (index) {
          return Expanded(
            child: InkWell(
              onTap: () {},
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: fbackgroundColor3,
                    ),
                    child: Icon(
                      fiturList[index]["icon"],
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    fiturList[index]["label"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
