import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AddNoteViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> addNote({
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

    await _firestore.collection("users").doc(user.uid).collection("notes").add({
      "title": title,
      "description": description,
    });

    return true;
  }
}
