import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class NotesViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get notesCollection {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User is not logged in");
    }

    return _firestore.collection("users").doc(user.uid).collection("notes");
  }

  // ================= FETCH NOTES =================

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchNotes() {
    final user = _auth.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection("users")
        .doc(user.uid)
        .collection("notes")
        .snapshots();
  }

  // ================= UPDATE NOTE =================

  Future<bool> updateNote({
    required String noteId,
    required String title,
    required String description,
  }) async {
    if (title.isEmpty || description.isEmpty) {
      return false;
    }

    final user = _auth.currentUser;

    if (user == null) {
      return false;
    }

    try {
      await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("notes")
          .doc(noteId)
          .update({"title": title, "description": description});

      return true;
    } catch (e) {
      return false;
    }
  }

  // ================= DELETE NOTE =================

  Future<bool> deleteNote(String noteId) async {
    final user = _auth.currentUser;

    if (user == null) {
      return false;
    }

    try {
      await _firestore
          .collection("users")
          .doc(user.uid)
          .collection("notes")
          .doc(noteId)
          .delete();

      return true;
    } catch (e) {
      return false;
    }
  }
}
