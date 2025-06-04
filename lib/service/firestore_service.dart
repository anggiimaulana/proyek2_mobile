import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get collection
  final CollectionReference notes = FirebaseFirestore.instance.collection(
    'notes',
  );

  // create
  Future<void> addNote(String note, DateTime? reminderTime, bool status) {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
      'status': status,
      'reminderTime':
          reminderTime != null ? Timestamp.fromDate(reminderTime) : null,
    });
  }

  // read
  Stream<QuerySnapshot> getNoteStream() {
    final notesStream =
        notes.orderBy('timestamp', descending: true).snapshots();

    return notesStream;
  }

  // update
  Future<void> updateNote(
    String docId,
    String newNote,
    DateTime? reminderTime,
  ) {
    return notes.doc(docId).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
      'status': false,
      'reminderTime':
          reminderTime != null ? Timestamp.fromDate(reminderTime) : null,
    });
  }

  // update status only
  Future<void> updateNoteStatus(String docId, bool status) {
    return notes.doc(docId).update({
      'status': status,
    });
  }

  // delete
  Future<void> deleteNote(String docId) {
    return notes.doc(docId).delete();
  }
}
