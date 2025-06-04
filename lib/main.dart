import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proyek2/check_auth_screen.dart';
import 'package:proyek2/data/models/informasi_umum/data_kk_hive_model.dart';
import 'package:proyek2/firebase_options.dart';
import 'package:proyek2/provider/auth/auth_provider.dart';
import 'package:proyek2/provider/pengajuan/data/data_provider2.dart';
import 'package:proyek2/provider/pengajuan/edit/skbm_edit_provider.dart';
import 'package:proyek2/provider/pengajuan/edit/skp_edit_provider.dart';
import 'package:proyek2/provider/pengajuan/edit/skpot_edit_provider.dart';
import 'package:proyek2/provider/pengajuan/edit/sks_edit_provider.dart';
import 'package:proyek2/provider/pengajuan/edit/sktm_beasiswa_edit_provider.dart';
import 'package:proyek2/provider/pengajuan/edit/sktm_listrik_edit_provider.dart';
import 'package:proyek2/provider/pengajuan/edit/sktm_sekolah_edit_provider.dart';
import 'package:proyek2/provider/pengajuan/edit/sku_edit_provider.dart';
import 'package:proyek2/provider/pengajuan/kartu_keluarga_provider.dart';
import 'package:proyek2/provider/pengajuan/create/skbm_create_provider.dart';
import 'package:proyek2/provider/pengajuan/create/skp_create_provider.dart';
import 'package:proyek2/provider/pengajuan/create/skpot_create_provider.dart';
import 'package:proyek2/provider/pengajuan/create/sks_create_provider.dart';
import 'package:proyek2/provider/pengajuan/create/sktm_beasiswa_create_provider.dart';
import 'package:proyek2/provider/pengajuan/create/sktm_listrik_create_provider.dart';
import 'package:proyek2/provider/pengajuan/create/sktm_sekolah_create_provider.dart';
import 'package:proyek2/provider/pengajuan/create/sku_create_provider.dart';
import 'package:proyek2/provider/pengajuan/tracking_surat_provider.dart';
import 'package:proyek2/service/global_navigation_service.dart';
import 'package:proyek2/service/notification_service.dart';
import 'package:proyek2/static/navigation_route.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(KartuKeluargaHiveAdapter());
  Hive.registerAdapter(NikHiveAdapter());

  // Initialize global notification service
  await _initializeGlobalNotifications();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => KartuKeluargaProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SktmListrikCreateProvider()),
        ChangeNotifierProvider(create: (_) => SktmListrikEditProvider()),
        ChangeNotifierProvider(create: (_) => SktmBeasiswaCreateProvider()),
        ChangeNotifierProvider(create: (_) => SktmBeasiswaEditProvider()),
        ChangeNotifierProvider(create: (_) => SktmSekolahCreateProvider()),
        ChangeNotifierProvider(create: (_) => SktmSekolahEditProvider()),
        ChangeNotifierProvider(create: (_) => SkpotCreateProvider()),
        ChangeNotifierProvider(create: (_) => SkpotEditProvider()),
        ChangeNotifierProvider(create: (_) => SksCreateProvider()),
        ChangeNotifierProvider(create: (_) => SksEditProvider()),
        ChangeNotifierProvider(create: (_) => SkbmCreateProvider()),
        ChangeNotifierProvider(create: (_) => SkbmEditProvider()),
        ChangeNotifierProvider(create: (_) => SkpCreateProvider()),
        ChangeNotifierProvider(create: (_) => SkpEditProvider()),
        ChangeNotifierProvider(create: (_) => SkuCreateProvider()),
        ChangeNotifierProvider(
          create: (_) => SkuEditProvider(),
        ),
        ChangeNotifierProvider(create: (_) => TrackingSuratProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> _initializeGlobalNotifications() async {
  try {
    await GlobalNotificationService().initialize();

    final prefs = await SharedPreferences.getInstance();
    final clientId = prefs.getInt('client_id');
    final token = prefs.getString('token');

    if (clientId != null && token != null) {
      // Jika user sudah login, mulai monitoring global notifications
      await GlobalNotificationService().startGlobalMonitoring();
      debugPrint(
          "🚀 Global notification monitoring started for user: $clientId");

      // Debug: Print stored statuses
      await GlobalNotificationService().debugStoredStatuses();
    } else {
      debugPrint(
          "👤 User not logged in, skipping global notification monitoring");
    }
  } catch (e) {
    debugPrint("💥 Error initializing global notifications: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: GlobalNavigationService.navigatorKey,
      home: const PermissionHandlerWrapper(),
      routes: {
        ...appRoutes,
        '/debug_notifications': (context) => const DebugNotificationScreen(),
      },
    );
  }
}

// Debug screen untuk testing notifications
class DebugNotificationScreen extends StatelessWidget {
  const DebugNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug Notifications')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () async {
                await GlobalNotificationService().debugStoredStatuses();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Check console for stored statuses')),
                );
              },
              child: const Text('Debug Stored Statuses'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await GlobalNotificationService().clearStoredStatuses();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Stored statuses cleared')),
                );
              },
              child: const Text('Clear Stored Statuses'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await GlobalNotificationService().forceCheckStatus();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Force check completed')),
                );
              },
              child: const Text('Force Check Status'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final status = GlobalNotificationService().monitoringStatus;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Monitoring Status: $status')),
                );
              },
              child: const Text('Check Monitoring Status'),
            ),
            const SizedBox(height: 32),
            const Text(
              'Instructions:\n'
              '1. Clear stored statuses to reset\n'
              '2. Force check to manually trigger status check\n'
              '3. Change status via admin panel\n'
              '4. Wait 30 seconds or force check again\n'
              '5. Notification should appear',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class PermissionHandlerWrapper extends StatefulWidget {
  const PermissionHandlerWrapper({super.key});

  @override
  State<PermissionHandlerWrapper> createState() =>
      _PermissionHandlerWrapperState();
}

class _PermissionHandlerWrapperState extends State<PermissionHandlerWrapper>
    with WidgetsBindingObserver {
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _mintaIzin();
      setState(() {
        _permissionGranted = true;
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Handle app lifecycle changes - IMPROVED
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    debugPrint("📱 App lifecycle changed to: $state");

    switch (state) {
      case AppLifecycleState.resumed:
        // App is in foreground - continue monitoring
        debugPrint("▶️ App resumed, checking monitoring status");
        _resumeGlobalMonitoring();
        break;
      case AppLifecycleState.paused:
        // App is in background - ensure monitoring continues
        debugPrint("⏸️ App paused, ensuring background monitoring");
        _ensureBackgroundMonitoring();
        break;
      case AppLifecycleState.detached:
        // App is being terminated
        debugPrint("🛑 App detached, stopping monitoring");
        GlobalNotificationService().stopGlobalMonitoring();
        break;
      case AppLifecycleState.hidden:
        debugPrint("👁️ App hidden");
        break;
      case AppLifecycleState.inactive:
        debugPrint("😴 App inactive");
        break;
    }
  }

  Future<void> _resumeGlobalMonitoring() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final clientId = prefs.getInt('client_id');
      final token = prefs.getString('token');

      if (clientId != null &&
          token != null &&
          !GlobalNotificationService().isMonitoring) {
        await GlobalNotificationService().startGlobalMonitoring();
        debugPrint("✅ Resumed global monitoring when app became active");
      } else if (GlobalNotificationService().isMonitoring) {
        debugPrint("✅ Global monitoring already active");
        // Force a status check when resuming
        await GlobalNotificationService().forceCheckStatus();
      }
    } catch (e) {
      debugPrint("❌ Error resuming global monitoring: $e");
    }
  }

  Future<void> _ensureBackgroundMonitoring() async {
    if (GlobalNotificationService().isMonitoring) {
      debugPrint("📱 App in background, monitoring continues with Timer");
    }
  }

  Future<void> _mintaIzin() async {
    if (Platform.isAndroid) {
      await Future.delayed(const Duration(milliseconds: 300));

      var storage = await Permission.storage.request();
      var manageStorage = await Permission.manageExternalStorage.request();
      await Future.delayed(const Duration(milliseconds: 300));
      var notif = await Permission.notification.request();

      debugPrint(
          "Permissions - Storage: $storage, ManageStorage: $manageStorage, Notification: $notif");

      if (!(storage.isGranted || manageStorage.isGranted || notif.isGranted)) {
        await openAppSettings();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_permissionGranted) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return const CheckAuthScreen();
  }
}
