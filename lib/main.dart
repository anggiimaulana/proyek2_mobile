import 'package:flutter/material.dart';
import 'package:proyek2/bottom_navigation.dart';
import 'package:proyek2/layouts/pengajuan_screen.dart';
import 'package:proyek2/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      routes: appRoutes,
    );
  }
}

final Map<String, WidgetBuilder> appRoutes = {
  '/buat_surat': (context) => const BuatSuratScreen(),
  '/sk_screen': (context) => const SkScreen(),
};
