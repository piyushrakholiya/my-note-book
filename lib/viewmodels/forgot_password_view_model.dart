import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> forgotPassword(String email) async {
    if (email.isEmpty) {
      _errorMessage = "Enter your email";
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      _isLoading = false;
      notifyListeners();

      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = e.message ?? "Something went wrong";
      notifyListeners();

      return false;
    }
  }
}
