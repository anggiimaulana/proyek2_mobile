import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyek2/service/firestore_service.dart';
import 'package:proyek2/style/colors.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController textController = TextEditingController();
  DateTime? selectedReminderTime;

  Timer? _timer;
  bool _hasActivePending = false; // Ada catatan menunggu?
  List<DocumentSnapshot> _currentNotes = [];

  void _startTimerIfNeeded() {
    if (_hasActivePending && _timer == null) {
      // Timer aktif hanya jika ada yang menunggu
      _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
        if (mounted) setState(() {});
      });
    } else if (!_hasActivePending && _timer != null) {
      // Tidak ada yang menunggu, stop timer
      _timer?.cancel();
      _timer = null;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  bool isReminderPassed(DateTime? reminderTime) {
    if (reminderTime == null) return false;
    return DateTime.now().isAfter(reminderTime);
  }

  // ... openNoteBox, confirmDelete, dll tetap sama ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Catatan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: fbackgroundColor3,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNoteBox(),
        backgroundColor: fbackgroundColor3,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNoteStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // Stop timer kalau tidak ada catatan
            _hasActivePending = false;
            _startTimerIfNeeded();
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_alt_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Belum ada catatan",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          final notesList = snapshot.data!.docs;
          _currentNotes = notesList;

          // Cek apakah ada catatan yang masih "Menunggu"
          bool hasPending = false;
          for (var document in notesList) {
            final data = document.data() as Map<String, dynamic>;
            final bool currentStatus = data['status'] ?? false;
            final Timestamp? reminderTS = data['reminderTime'];
            final reminderTime = reminderTS?.toDate();

            if (!currentStatus &&
                (reminderTime == null || !isReminderPassed(reminderTime))) {
              hasPending = true;
              break;
            }
          }
          // Update state dan kelola timer sesuai kondisi
          if (_hasActivePending != hasPending) {
            _hasActivePending = hasPending;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _startTimerIfNeeded();
            });
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notesList.length,
            itemBuilder: (context, index) {
              final document = notesList[index];
              final docId = document.id;
              final data = document.data() as Map<String, dynamic>;
              final noteText = data['note'];
              final Timestamp? reminderTS = data['reminderTime'];
              final reminderTime = reminderTS?.toDate();
              final bool currentStatus = data['status'] ?? false;

              final bool shouldBeCompleted = isReminderPassed(reminderTime);
              if (shouldBeCompleted && !currentStatus) {
                firestoreService.updateNoteStatus(docId, true);
              }

              final bool isCompleted = shouldBeCompleted || currentStatus;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    noteText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color:
                          isCompleted ? Colors.grey.shade600 : Colors.black87,
                      decoration:
                          isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (reminderTime != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text("Diingatkan pada: "),
                            Text(
                              "${reminderTime.day}-${reminderTime.month}-${reminderTime.year} "
                              "${reminderTime.hour.toString().padLeft(2, '0')}:${reminderTime.minute.toString().padLeft(2, '0')}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? Colors.green.shade100
                              : Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isCompleted ? "Selesai" : "Menunggu",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isCompleted
                                ? Colors.green.shade700
                                : Colors.orange.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        openNoteBox(
                          docID: docId,
                          existingText: noteText,
                          existingReminderTime: reminderTime,
                        );
                      } else if (value == 'delete') {
                        confirmDelete(docId);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Hapus', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    icon: const Icon(Icons.more_vert),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void openNoteBox(
      {String? docID, String? existingText, DateTime? existingReminderTime}) {
    textController.text = existingText ?? "";
    selectedReminderTime = existingReminderTime;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    docID == null ? 'Tambah Catatan' : 'Edit Catatan',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Note Input
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: textController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Tulis catatanmu...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date Section
                  Text(
                    'Tanggal Pengingat',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: InkWell(
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setDialogState(() {
                            selectedReminderTime = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              selectedReminderTime?.hour ?? 0,
                              selectedReminderTime?.minute ?? 0,
                            );
                          });
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today,
                                color: Colors.grey.shade600),
                            const SizedBox(width: 12),
                            Text(
                              selectedReminderTime == null
                                  ? "Pilih Tanggal"
                                  : "${selectedReminderTime!.day}-${selectedReminderTime!.month}-${selectedReminderTime!.year}",
                              style: TextStyle(
                                color: selectedReminderTime == null
                                    ? Colors.grey
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Time Section
                  Text(
                    'Waktu Pengingat',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: InkWell(
                      onTap: () async {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setDialogState(() {
                            selectedReminderTime = DateTime(
                              selectedReminderTime?.year ?? DateTime.now().year,
                              selectedReminderTime?.month ??
                                  DateTime.now().month,
                              selectedReminderTime?.day ?? DateTime.now().day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.access_time,
                                color: Colors.grey.shade600),
                            const SizedBox(width: 12),
                            Text(
                              selectedReminderTime == null
                                  ? "Pilih Waktu"
                                  : "${selectedReminderTime!.hour.toString().padLeft(2, '0')}:${selectedReminderTime!.minute.toString().padLeft(2, '0')}",
                              style: TextStyle(
                                color: selectedReminderTime == null
                                    ? Colors.grey
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          selectedReminderTime = null;
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Batal',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: fbackgroundColor3,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () {
                          final text = textController.text.trim();
                          if (text.isNotEmpty) {
                            // Status otomatis false karena baru dibuat/diedit
                            bool status = false;

                            if (docID == null) {
                              firestoreService.addNote(
                                text,
                                selectedReminderTime,
                                status,
                              );
                              showSnackBar("Catatan berhasil ditambahkan!");
                            } else {
                              firestoreService.updateNote(
                                docID,
                                text,
                                selectedReminderTime,
                              );
                              showSnackBar("Catatan berhasil diperbarui!");
                            }
                          }
                          textController.clear();
                          selectedReminderTime = null;
                          Navigator.pop(context);
                        },
                        child: Text(
                          docID == null ? 'Tambah' : 'Update',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void confirmDelete(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          "Hapus Catatan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("Yakin ingin menghapus catatan ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Batal",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              firestoreService.deleteNote(docId);
              Navigator.pop(context);
              showSnackBar("Catatan berhasil dihapus!");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }
}
