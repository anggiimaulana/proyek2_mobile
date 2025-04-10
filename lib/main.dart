import 'package:flutter/material.dart';
import 'package:proyek2/screen/main_screen.dart';
import 'package:proyek2/screen/pengajuan/buat_surat_screen.dart';
import 'package:proyek2/screen/pengajuan/sk_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
      routes: appRoutes,
    );
  }
}

final Map<String, WidgetBuilder> appRoutes = {
  '/buat_surat': (context) => const BuatSuratScreen(),
  '/sk_screen': (context) => const SkScreen(),
};
