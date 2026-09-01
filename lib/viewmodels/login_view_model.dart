import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _isLoading = false;
      notifyListeners();

      return credential.user != null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;

      if (e.code == 'user-not-found') {
        _errorMessage = "user-not-found";
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        _errorMessage = "wrong-password";
      } else {
        _errorMessage = e.message ?? "Login failed";
      }

      notifyListeners();

      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = "Something went wrong";

      notifyListeners();

      return false;
    }
  }
}
