import 'package:flutter/material.dart';
import 'package:proyek2/screen/pengajuan/buat_surat_screen.dart';
import 'package:proyek2/screen/pengajuan/sk_screen.dart';

enum NavigationRoute {
  mainRoute("/"),
  buatSuratRoute("/buat_surat"),
  skRoute("/sk_screen");

  const NavigationRoute(this.name);
  final String name;
}

// Map ini yang dipakai buat routing
final Map<String, WidgetBuilder> appRoutes = {
  NavigationRoute.buatSuratRoute.name: (context) => const BuatSuratScreen(),
  NavigationRoute.skRoute.name: (context) => const SkScreen(),
};
