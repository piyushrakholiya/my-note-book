import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (newPassword != confirmPassword) {
      _errorMessage = "New Password અને Confirm Password અલગ છે";

      notifyListeners();
      return false;
    }

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      _errorMessage = "બધી fields ભરો";

      notifyListeners();
      return false;
    }

    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _errorMessage = "User login નથી";

      notifyListeners();
      return false;
    }

    if (user.email == null) {
      _errorMessage = "User email મળ્યો નથી";

      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);

      _isLoading = false;

      notifyListeners();

      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;

      _errorMessage = e.message ?? "Password change failed";

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
