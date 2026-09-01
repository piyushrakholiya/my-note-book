import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LockViewModel extends ChangeNotifier {
  final LocalAuthentication _auth = LocalAuthentication();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // ================= CHECK PIN =================

  Future<bool> checkPin(String pin) async {
    if (pin.length != 6) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      final savedPin = prefs.getString("appLockPin");

      return savedPin != null && savedPin == pin;
    } catch (e) {
      debugPrint("PIN error: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ================= FINGERPRINT =================

  Future<bool> authenticate() async {
    if (_isLoading) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Device biometric support check
      final bool isSupported = await _auth.isDeviceSupported();

      debugPrint("Biometric supported: $isSupported");

      if (!isSupported) {
        debugPrint("Biometric authentication is not supported");
        return false;
      }

      // Check available biometric
      final List<BiometricType> biometrics = await _auth
          .getAvailableBiometrics();

      debugPrint("Available biometrics: $biometrics");

      if (biometrics.isEmpty) {
        debugPrint("No fingerprint/biometric is registered");
        return false;
      }

      // Authenticate
      final bool authenticated = await _auth.authenticate(
        localizedReason: "Please authenticate to unlock My Notebook",
        biometricOnly: true,
      );

      debugPrint("Authentication result: $authenticated");

      return authenticated;
    } catch (e) {
      debugPrint("Authentication error: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
