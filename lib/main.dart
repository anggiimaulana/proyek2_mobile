import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proyek2/check_auth_screen.dart';
import 'package:proyek2/provider/auth/auth_provider.dart';
import 'package:proyek2/provider/pengajuan/data/data_provider.dart';
import 'package:proyek2/provider/pengajuan/skbm_provider.dart';
import 'package:proyek2/provider/pengajuan/skp_provider.dart';
import 'package:proyek2/provider/pengajuan/skpot_provider.dart';
import 'package:proyek2/provider/pengajuan/sks_provider.dart';
import 'package:proyek2/provider/pengajuan/sktm_beasiswa_provider.dart';
import 'package:proyek2/provider/pengajuan/sktm_listrik_provider.dart';
import 'package:proyek2/provider/pengajuan/sktm_sekolah_provider.dart';
import 'package:proyek2/provider/pengajuan/sku_provider.dart';
import 'package:proyek2/static/navigation_route.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Minta izin akses file
  await mintaIzin();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SktmListrikProvider()),
        ChangeNotifierProvider(create: (_) => SktmBeasiswaProvider()),
        ChangeNotifierProvider(create: (_) => SktmSekolahProvider()),
        ChangeNotifierProvider(create: (_) => SkpotProvider()),
        ChangeNotifierProvider(create: (_) => SksProvider()),
        ChangeNotifierProvider(create: (_) => SkbmProvider()),
        ChangeNotifierProvider(create: (_) => SkpProvider()),
        ChangeNotifierProvider(create: (_) => SkuProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> mintaIzin() async {
  // Untuk Android 11 ke atas
  if (await Permission.manageExternalStorage.request().isGranted) {
    print("✅ Izin granted!");
  } else {
    print("❌ Izin ditolak!");
    await openAppSettings(); // redirect ke settings jika ditolak
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CheckAuthScreen(),
      routes: {
        ...appRoutes,
      },
    );
  }
}
