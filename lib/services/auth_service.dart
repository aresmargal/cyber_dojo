import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class AuthService extends ChangeNotifier {
  UserModel? _currentUserModel;
  UserModel? get currentUser => _currentUserModel;

  Stream<UserModel?> get userStream async* {
    // Stream de Firebase Auth: si user == null → logout
    final authUser = FirebaseAuth.instance.authStateChanges();

    await for (var firebaseUser in authUser) {
      if (firebaseUser == null) {
        _currentUserModel = null;
        notifyListeners();
        yield null;
        continue;
      }

      // Escuchar en tiempo real el documento del usuario en Firestore
      final firestoreStream = FirebaseFirestore.instance
          .collection("usuarios")
          .doc(firebaseUser.uid)
          .snapshots();

      await for (var doc in firestoreStream) {
        if (!doc.exists) {
          yield null;
          continue;
        }

        _currentUserModel = UserModel.fromMap(doc.id, doc.data()!);
        notifyListeners();
        yield _currentUserModel;
      }
    }
  }

  // Actualizar campos del usuario
  Future<void> updateUser(Map<String, dynamic> data) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection("usuarios")
        .doc(uid)
        .update(data);
  }
}
