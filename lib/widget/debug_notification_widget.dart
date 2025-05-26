// widgets/debug_notification_widget.dart
import 'package:flutter/material.dart';
import 'package:proyek2/service/notification_service.dart';

class DebugNotificationWidget extends StatefulWidget {
  const DebugNotificationWidget({super.key});

  @override
  State<DebugNotificationWidget> createState() =>
      _DebugNotificationWidgetState();
}

class _DebugNotificationWidgetState extends State<DebugNotificationWidget> {
  String _monitoringStatus = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _updateStatus();
  }

  void _updateStatus() {
    setState(() {
      _monitoringStatus = GlobalNotificationService().monitoringStatus;
    });
  }

  Future<void> _executeAction(String action, VoidCallback onAction) async {
    setState(() {
      _isLoading = true;
    });

    try {
      onAction();
      await Future.delayed(
          const Duration(milliseconds: 500)); // Small delay for UI feedback
    } catch (e) {
      debugPrint("Error executing $action: $e");
    }

    setState(() {
      _isLoading = false;
    });
    _updateStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.bug_report, color: Colors.orange),
                const SizedBox(width: 8),
                const Text(
                  'Debug Notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (_isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Monitoring Status:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _monitoringStatus,
                    style: TextStyle(
                      color: _monitoringStatus.contains('Active')
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Debug Actions
            const Text(
              'Debug Actions:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () => _executeAction(
                            'Debug Stored Statuses',
                            () async => await GlobalNotificationService()
                                .debugStoredStatuses(),
                          ),
                  icon: const Icon(Icons.storage, size: 16),
                  label: const Text('Debug Storage'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () => _executeAction(
                            'Clear Stored Statuses',
                            () async => await GlobalNotificationService()
                                .clearStoredStatuses(),
                          ),
                  icon: const Icon(Icons.clear_all, size: 16),
                  label: const Text('Clear Storage'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () => _executeAction(
                            'Force Check Status',
                            () async => await GlobalNotificationService()
                                .forceCheckStatus(),
                          ),
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Force Check'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () => _executeAction(
                            'Restart Monitoring',
                            () async {
                              GlobalNotificationService()
                                  .stopGlobalMonitoring();
                              await Future.delayed(const Duration(seconds: 1));
                              await GlobalNotificationService()
                                  .startGlobalMonitoring();
                            },
                          ),
                  icon: const Icon(Icons.restart_alt, size: 16),
                  label: const Text('Restart Monitor'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Instructions
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue[700], size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Testing Instructions:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '1. Clear Storage untuk reset semua status\n'
                    '2. Force Check untuk trigger manual check\n'
                    '3. Ubah status via admin panel\n'
                    '4. Tunggu 30 detik atau Force Check lagi\n'
                    '5. Notifikasi akan muncul jika ada perubahan\n'
                    '6. Restart Monitor jika ada masalah',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Real-time status
            StreamBuilder<int>(
              stream: Stream.periodic(const Duration(seconds: 5), (i) => i),
              builder: (context, snapshot) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        GlobalNotificationService().isMonitoring
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: GlobalNotificationService().isMonitoring
                            ? Colors.green
                            : Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Live Status: ${GlobalNotificationService().isMonitoring ? "ACTIVE" : "INACTIVE"}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Updated: ${DateTime.now().toLocal().toString().substring(11, 19)}',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
