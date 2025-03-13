import 'package:flutter/material.dart';
import 'package:proyek2/view/layouts/pengajuan/buat_surat_screen.dart';
import 'package:proyek2/view/layouts/pengajuan/sk/sk_screen.dart';
import 'package:proyek2/view/layouts/pengajuan/sl/sl_screen.dart';
import 'package:proyek2/view/layouts/pengajuan/sp/sp_screen.dart';
import 'package:proyek2/view/layouts/pengajuan/sr/sr_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/buat_surat': (context) => const BuatSuratScreen(),
  '/sk_screen': (context) => const SkScreen(),
  '/sp_screen': (context) => const SpScreen(),
  '/sr_screen': (context) => const SrScreen(),
  '/sl_screen': (context) => const SlScreen(),
};
