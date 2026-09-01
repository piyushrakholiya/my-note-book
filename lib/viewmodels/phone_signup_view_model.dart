import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class PhoneSignupViewModel extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> sendOtp({
    required String phone,
    required void Function(String verificationId) onCodeSent,
    required void Function() onVerificationCompleted,
    required void Function(String message) onVerificationFailed,
  }) async {
    _isLoading = true;
    notifyListeners();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,

      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await FirebaseAuth.instance.signInWithCredential(credential);

          _isLoading = false;
          notifyListeners();

          onVerificationCompleted();
        } on FirebaseAuthException catch (e) {
          _isLoading = false;
          notifyListeners();

          onVerificationFailed(e.message ?? "Verification failed");
        }
      },

      verificationFailed: (FirebaseAuthException e) {
        _isLoading = false;
        notifyListeners();

        onVerificationFailed(e.message ?? "OTP મોકલી શકાયો નથી");
      },

      codeSent: (String verificationId, int? resendToken) {
        _isLoading = false;
        notifyListeners();

        onCodeSent(verificationId);
      },

      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
