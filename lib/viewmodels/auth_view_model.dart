import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  bool _isLoading = true;

  User? get user => _user;

  bool get isLoggedIn => _user != null;

  bool get isLoading => _isLoading;

  late StreamSubscription<User?> _subscription;

  AuthViewModel() {
    _subscription = _auth.authStateChanges().listen((user) {
      _user = user;
      _isLoading = false;

      notifyListeners();
    });
  }

  Future<void> logout() async {
    await _auth.signOut();

    // Firebase listener normally આ કરી દેશે,
    // પરંતુ અહીં પણ state તરત update કરી દઈએ.
    _user = null;

    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
