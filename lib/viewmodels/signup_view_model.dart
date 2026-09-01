import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class SignupViewModel extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<bool> signup({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      _isLoading = false;
      notifyListeners();

      return credential.user != null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = e.code;

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
