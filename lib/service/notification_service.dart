// services/notification_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyek2/data/api/api_services.dart';
import 'package:proyek2/data/models/pengajuan/pengajuan_detail_model.dart';

class GlobalNotificationService {
  static final GlobalNotificationService _instance =
      GlobalNotificationService._internal();
  factory GlobalNotificationService() => _instance;
  GlobalNotificationService._internal();

  FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;
  Timer? _backgroundTimer;
  bool _isInitialized = false;
  bool _isMonitoring = false;

  // Add this to track first run
  bool _isFirstRun = true;

  // Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin!.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationTap(response);
      },
    );

    _isInitialized = true;
    debugPrint("Global Notification Service initialized");
  }

  // Handle notification tap
  void _handleNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    debugPrint("Notification tapped with payload: $payload");

    // TODO: Add navigation logic here
    // You can use a global navigator key or event bus to navigate
  }

  // Start global monitoring
  Future<void> startGlobalMonitoring() async {
    if (_isMonitoring) return;

    await initialize();

    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getInt('client_id');

    if (idUser == null) {
      debugPrint("Cannot start monitoring: client_id not found");
      return;
    }

    // Load initial status without notifications on first run
    await _loadAndCheckStatus(idUser, isInitialLoad: true);

    // Start periodic checking (setiap 30 detik untuk testing, bisa diubah ke 2 menit)
    _backgroundTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      await _loadAndCheckStatus(idUser, isInitialLoad: false);
    });

    _isMonitoring = true;
    debugPrint("Global status monitoring started for user: $idUser");
  }

  // Stop global monitoring
  void stopGlobalMonitoring() {
    _backgroundTimer?.cancel();
    _backgroundTimer = null;
    _isMonitoring = false;
    debugPrint("Global status monitoring stopped");
  }

  // Check status changes - IMPROVED VERSION
  Future<void> _loadAndCheckStatus(int idUser,
      {bool isInitialLoad = false}) async {
    try {
      const baseUrl = ApiServices.baseUrl;
      final url = "$baseUrl/pengajuan/user/$idUser";

      debugPrint("🔄 Checking status for user: $idUser at ${DateTime.now()}");

      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Debug: Print raw response
        debugPrint("📥 API Response: ${response.body}");

        final pengajuanData = PengajuanDetailModel.fromJson(data);

        if (pengajuanData.data.isNotEmpty) {
          debugPrint("📋 Found ${pengajuanData.data.length} pengajuan(s)");
          await _checkForStatusChanges(pengajuanData.data,
              isInitialLoad: isInitialLoad);
        } else {
          debugPrint("📭 No pengajuan data found");
        }
      } else {
        debugPrint("❌ API Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      debugPrint("💥 Error in background status check: $e");
    }
  }

  // IMPROVED: Check for status changes and send notifications
  Future<void> _checkForStatusChanges(List<dynamic> newData,
      {bool isInitialLoad = false}) async {
    final prefs = await SharedPreferences.getInstance();

    // Use a more specific key to avoid conflicts
    final storageKey = 'pengajuan_statuses_v2';
    final previousStatusesJson = prefs.getString(storageKey);

    Map<String, Map<String, dynamic>> previousStatuses = {};

    if (previousStatusesJson != null && previousStatusesJson.isNotEmpty) {
      try {
        final Map<String, dynamic> statusesMap =
            json.decode(previousStatusesJson);
        previousStatuses = statusesMap
            .map((key, value) => MapEntry(key, value as Map<String, dynamic>));
        debugPrint(
            "📚 Loaded ${previousStatuses.length} previous statuses from storage");
      } catch (e) {
        debugPrint("❌ Error parsing previous statuses: $e");
        // Clear corrupted data
        await prefs.remove(storageKey);
      }
    } else {
      debugPrint("📝 No previous statuses found in storage");
    }

    Map<String, Map<String, dynamic>> currentStatuses = {};
    int changesDetected = 0;

    // Process each pengajuan
    for (var pengajuan in newData) {
      final id = pengajuan.id.toString();
      final currentStatus = pengajuan.statusPengajuanText ?? 'Unknown';
      final jenisSurat = pengajuan.namaKategoriPengajuan ?? 'Surat';
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      // Store comprehensive data
      currentStatuses[id] = {
        'status': currentStatus,
        'jenis_surat': jenisSurat,
        'last_updated': timestamp,
        'pengajuan_id': pengajuan.id,
      };

      debugPrint(
          "🔍 Processing: $jenisSurat (ID: $id) - Status: $currentStatus");

      // Check if this is a known pengajuan with changed status
      if (previousStatuses.containsKey(id)) {
        final previousStatus = previousStatuses[id]?['status'] ?? '';

        debugPrint("📊 Comparing: '$previousStatus' vs '$currentStatus'");

        if (previousStatus != currentStatus && !isInitialLoad) {
          debugPrint(
              "🚨 STATUS CHANGED for $jenisSurat (ID: $id): '$previousStatus' -> '$currentStatus'");

          await _showStatusChangeNotification(
              jenisSurat, currentStatus, pengajuan.id,
              previousStatus: previousStatus);

          changesDetected++;
        } else if (previousStatus == currentStatus) {
          debugPrint("✅ No change for $jenisSurat (ID: $id): $currentStatus");
        }
      } else {
        if (isInitialLoad || _isFirstRun) {
          debugPrint(
              "🆕 New pengajuan registered: $jenisSurat (ID: $id) - Status: $currentStatus");
        } else {
          debugPrint(
              "🆕 NEW PENGAJUAN DETECTED: $jenisSurat (ID: $id) - Status: $currentStatus");

          // Show notification for new pengajuan
          await _showNewPengajuanNotification(
              jenisSurat, currentStatus, pengajuan.id);
          changesDetected++;
        }
      }
    }

    // Always save current statuses
    try {
      final statusesJson = json.encode(currentStatuses);
      await prefs.setString(storageKey, statusesJson);
      debugPrint("💾 Saved ${currentStatuses.length} statuses to storage");

      if (changesDetected > 0) {
        debugPrint("🎉 Total changes detected and notified: $changesDetected");
      }
    } catch (e) {
      debugPrint("❌ Error saving statuses: $e");
    }

    // Set first run to false after initial load
    if (_isFirstRun) {
      _isFirstRun = false;
      debugPrint("🏁 First run completed");
    }
  }

  // Show notification for status change
  Future<void> _showStatusChangeNotification(
      String jenisSurat, String newStatus, int pengajuanId,
      {String? previousStatus}) async {
    if (_flutterLocalNotificationsPlugin == null) {
      debugPrint("❌ Notification plugin not initialized");
      return;
    }

    String title = '';
    String body = '';

    // More descriptive messages
    switch (newStatus.toLowerCase().trim()) {
      case 'disetujui':
        title = '✅ Pengajuan Disetujui!';
        body =
            'Pengajuan $jenisSurat Anda telah disetujui oleh Kuwu dan surat siap diunduh';
        break;
      case 'ditolak':
        title = '❌ Pengajuan Ditolak';
        body =
            'Pengajuan $jenisSurat Anda ditolak. Silakan perbarui dan ajukan kembali';
        break;
      case 'diproses':
        title = '⏳ Pengajuan Sedang Diproses';
        body =
            'Pengajuan $jenisSurat Anda telah lolos review dan sedang diproses oleh Kuwu';
        break;
      case 'direvisi':
        title = '📝 Pengajuan Sudah Direvisi';
        body =
            'Pengajuan $jenisSurat Anda sudah direvisi. Menunggu review oleh admin';
        break;
      case 'menunggu':
        title = '⏰ Menunggu Review';
        body = 'Pengajuan $jenisSurat Anda menunggu review dari admin';
        break;
      default:
        title = '🔄 Status Berubah';
        body = 'Status pengajuan $jenisSurat berubah menjadi: $newStatus';
    }

    if (previousStatus != null) {
      body += '\n(Sebelumnya: $previousStatus)';
    }

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'global_status_channel',
      'Status Pengajuan',
      channelDescription: 'Notifikasi perubahan status pengajuan surat',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      autoCancel: true,
      enableVibration: true,
      playSound: true,
      // Add these for better visibility
      ticker: 'Status pengajuan berubah',
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    // Use unique notification ID based on pengajuan ID
    final notificationId = pengajuanId + 1000; // offset to avoid conflicts

    try {
      await _flutterLocalNotificationsPlugin!.show(
        notificationId,
        title,
        body,
        notificationDetails,
        payload: json.encode({
          'type': 'status_change',
          'pengajuan_id': pengajuanId,
          'jenis_surat': jenisSurat,
          'status': newStatus,
          'previous_status': previousStatus,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        }),
      );

      debugPrint("🔔 Notification sent: $title - $body");
    } catch (e) {
      debugPrint("❌ Error showing notification: $e");
    }
  }

  // Show notification for new pengajuan
  Future<void> _showNewPengajuanNotification(
      String jenisSurat, String status, int pengajuanId) async {
    if (_flutterLocalNotificationsPlugin == null) return;

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'new_pengajuan_channel',
      'Pengajuan Baru',
      channelDescription: 'Notifikasi pengajuan baru',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      autoCancel: true,
      enableVibration: true,
      playSound: true,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin!.show(
      pengajuanId + 2000, // offset for new pengajuan notifications
      '🆕 Pengajuan Baru',
      'Pengajuan $jenisSurat telah diajukan. Menunggu Review dari admin',
      notificationDetails,
      payload: json.encode({
        'type': 'new_pengajuan',
        'pengajuan_id': pengajuanId,
        'jenis_surat': jenisSurat,
        'status': status,
      }),
    );
  }

  // Method to clear stored statuses (useful for testing or reset)
  Future<void> clearStoredStatuses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('pengajuan_statuses_v2');
    await prefs.remove('global_previous_statuses'); // remove old key too
    _isFirstRun = true;
    debugPrint("🧹 Cleared all stored statuses");
  }

  // Debug method to check stored statuses
  Future<void> debugStoredStatuses() async {
    final prefs = await SharedPreferences.getInstance();
    final statusesJson = prefs.getString('pengajuan_statuses_v2');

    if (statusesJson != null) {
      try {
        final statuses = json.decode(statusesJson);
        debugPrint("🔍 Current stored statuses:");
        statuses.forEach((key, value) {
          debugPrint(
              "  - ID: $key | Status: ${value['status']} | Jenis: ${value['jenis_surat']}");
        });
      } catch (e) {
        debugPrint("❌ Error reading stored statuses: $e");
      }
    } else {
      debugPrint("📭 No stored statuses found");
    }
  }

  // Force check status (for manual testing)
  Future<void> forceCheckStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getInt('client_id');

    if (idUser != null) {
      debugPrint("🔧 Force checking status for user: $idUser");
      await _loadAndCheckStatus(idUser, isInitialLoad: false);
    } else {
      debugPrint("❌ Cannot force check: client_id not found");
    }
  }

  // Check if monitoring is active
  bool get isMonitoring => _isMonitoring;

  // Get monitoring status for debugging
  String get monitoringStatus {
    if (!_isInitialized) return "Not initialized";
    if (!_isMonitoring) return "Initialized but not monitoring";
    return "Active monitoring (Timer: ${_backgroundTimer != null ? 'Active' : 'Inactive'})";
  }
}
