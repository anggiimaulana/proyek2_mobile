import 'package:flutter/material.dart';
import 'package:proyek2/view/layouts/pengajuan/buat_surat_screen.dart';
import 'package:proyek2/view/layouts/pengajuan/sk/sk_screen.dart';
import 'package:proyek2/view/layouts/pengajuan/sl/sl_screen.dart';
import 'package:proyek2/view/layouts/pengajuan/sp/sp_screen.dart';
import 'package:proyek2/view/layouts/pengajuan/sr/sr_screen.dart';
import 'package:proyek2/view/main_screen.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AppMainScreen(),
      routes: {
        '/buat_surat': (context) => const BuatSuratScreen(),
        '/sk_screen': (context) => const SkScreen(),
        '/sp_screen': (context) => const SpScreen(),
        '/sr_screen': (context) => const SrScreen(),
        '/sl_screen': (context) => const SlScreen(),
      },
    );
  }
}
