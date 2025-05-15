import 'package:flutter/material.dart';
import 'package:proyek2/data/models/pengajuan/surat/surat_list.dart';
import 'package:proyek2/style/colors.dart';
import 'package:proyek2/screen/pengajuan/category_sk.dart';

class SkScreen extends StatelessWidget {
  const SkScreen({super.key});

  void navigateToRoute(BuildContext context, String? route) {
    if (route?.isNotEmpty ?? false) {
      Navigator.pushNamed(context, route!);
    } else {
      print("Route kosong atau null");
    }
  }

  List<Widget> buildCategoryItems(BuildContext context) {
    return listCategorySk.map((surat) {
      return GestureDetector(
        onTap: () => navigateToRoute(context, surat.route),
        child: CardCategorySk(
          title: surat.title,
          icon: surat.icon,
          color: surat.color,
          route: surat.route,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FF),
      appBar: AppBar(
        title: const Text(
          "Pengajuan Surat Keterangan",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: fbackgroundColor3,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(
              top: 20.0,
              right: 20.0,
              left: 20.0,
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Silahkan pilih surat keterangan yang ingin Anda ajukan!",
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 0.75,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                children: buildCategoryItems(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
