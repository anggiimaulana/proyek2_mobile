import 'package:flutter/material.dart';
import 'package:proyek2/screen/main_screen.dart';
import 'package:proyek2/screen/pengajuan/create_surat/skp_screen.dart';
import 'package:proyek2/screen/pengajuan/sk_screen.dart';
import 'package:proyek2/screen/pengajuan/create_surat/sks_screen.dart';
import 'package:proyek2/screen/pengajuan/create_surat/skbm_screen.dart';
import 'package:proyek2/screen/pengajuan/create_surat/skpot_screen.dart';
import 'package:proyek2/screen/pengajuan/create_surat/sktm_beasiswa_screen.dart';
import 'package:proyek2/screen/pengajuan/create_surat/sktm_listrik_screen.dart';
import 'package:proyek2/screen/pengajuan/create_surat/sktm_sekolah_screen.dart';
import 'package:proyek2/screen/pengajuan/create_surat/sku_screen.dart';

enum NavigationRoute {
  mainRoute("/"),
  homeRoute("/home"),
  skRoute("/sk_screen"),
  sktmListrikRoute("/sk_screen/sktml"),
  sktmBeasiswaRoute("/sk_screen/sktmb"),
  sktmSekolahRoute("/sk_screen/sktms"),
  skpbRoute("/sk_screen/skpb"),
  skpotRoute("/sk_screen/skpot"),
  skuRoute("/sk_screen/sku"),
  sksRoute("/sk_screen/sks"),
  skbmRoute("/sk_screen/skbm"),
  skpRoute("/sk_screen/skp");

  const NavigationRoute(this.name);
  final String name;
}

final Map<String, WidgetBuilder> appRoutes = {
  NavigationRoute.homeRoute.name: (context) =>
      const MainScreen(), // Tambahkan ini
  NavigationRoute.skRoute.name: (context) => const SkScreen(),
  NavigationRoute.sktmListrikRoute.name: (context) => const SktmListrikScreen(),
  NavigationRoute.sktmBeasiswaRoute.name: (context) =>
      const SktmBeasiswaScreen(),
  NavigationRoute.sktmSekolahRoute.name: (context) => const SktmSekolahScreen(),
  NavigationRoute.skpotRoute.name: (context) => const SkpotScreen(),
  NavigationRoute.skuRoute.name: (context) => const SkuScreen(),
  NavigationRoute.sksRoute.name: (context) => const SksScreen(),
  NavigationRoute.skbmRoute.name: (context) => const SkbmScreen(),
  NavigationRoute.skpRoute.name: (context) => const SkpScreen(),
};
