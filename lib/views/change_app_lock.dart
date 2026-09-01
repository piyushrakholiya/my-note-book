import 'package:firebase/utils/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeAppLockPage extends StatefulWidget {
  const ChangeAppLockPage({super.key});

  @override
  State<ChangeAppLockPage> createState() => _ChangeAppLockPageState();
}

class _ChangeAppLockPageState extends State<ChangeAppLockPage> {
  final TextEditingController currentPinController = TextEditingController();

  final TextEditingController newPinController = TextEditingController();

  final TextEditingController confirmPinController = TextEditingController();

  bool isLoading = false;

  bool obscureCurrentPin = true;
  bool obscureNewPin = true;
  bool obscureConfirmPin = true;

  // =========================================================
  // CHANGE PIN
  // =========================================================

  Future<void> changePin() async {
    final String currentPin = currentPinController.text.trim();

    final String newPin = newPinController.text.trim();

    final String confirmPin = confirmPinController.text.trim();

    // Current PIN
    if (currentPin.length != 6) {
      _showMessage("Enter your current 6 digit PIN");
      return;
    }

    // New PIN
    if (newPin.length != 6) {
      _showMessage("New PIN must be 6 digits");
      return;
    }

    // Confirm PIN
    if (confirmPin.length != 6) {
      _showMessage("Confirm PIN must be 6 digits");
      return;
    }

    // New PIN match
    if (newPin != confirmPin) {
      _showMessage("New PIN does not match");
      return;
    }

    // Same PIN
    if (currentPin == newPin) {
      _showMessage("New PIN must be different from current PIN");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();

      // Get saved PIN
      final String? savedPin = prefs.getString("appLockPin");

      // No PIN found
      if (savedPin == null || savedPin.isEmpty) {
        _showMessage("App Lock PIN not found");
        return;
      }

      // Current PIN check
      if (currentPin != savedPin) {
        _showMessage("Current PIN is incorrect");
        return;
      }

      // Save new PIN
      await prefs.setString("appLockPin", newPin);

      if (!mounted) {
        return;
      }

      _showMessage("App Lock PIN changed successfully");

      // Clear fields
      currentPinController.clear();
      newPinController.clear();
      confirmPinController.clear();

      // Go back
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showMessage("Unable to change App Lock PIN");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // =========================================================
  // MESSAGE
  // =========================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {
    currentPinController.dispose();
    newPinController.dispose();
    confirmPinController.dispose();

    super.dispose();
  }

  // =========================================================
  // PIN FIELD
  // =========================================================

  Widget _pinField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool obscureText,
    required VoidCallback onVisibilityPressed,
  }) {
    return TextField(
      controller: controller,

      keyboardType: TextInputType.number,

      obscureText: obscureText,

      maxLength: 6,

      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        letterSpacing: 5,
      ),

      decoration: InputDecoration(
        labelText: label,

        labelStyle: const TextStyle(color: Colors.white),

        hintText: hint,

        hintStyle: const TextStyle(color: Colors.white60),

        counterStyle: const TextStyle(color: Colors.white70),

        suffixIcon: IconButton(
          onPressed: onVisibilityPressed,

          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.white,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),

          borderSide: const BorderSide(color: Colors.white70),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),

          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
      ),
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change App Lock"),

        centerTitle: true,

        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            ),
          ),
        ),

        foregroundColor: Colors.white,
      ),

      body: GradientBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 30,
            bottom: MediaQuery.of(context).viewInsets.bottom + 30,
          ),

          child: Column(
            children: [
              const SizedBox(height: 20),

              // =================================================
              // LOCK ICON
              // =================================================
              Container(
                height: 100,
                width: 100,

                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),

                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.lock_reset_rounded,
                  size: 60,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 25),

              // =================================================
              // TITLE
              // =================================================
              const Text(
                "Change App Lock",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Change your 6 digit App Lock PIN",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),

              const SizedBox(height: 35),

              // =================================================
              // CURRENT PIN
              // =================================================
              _pinField(
                controller: currentPinController,
                label: "Current PIN",
                hint: "Enter current PIN",
                obscureText: obscureCurrentPin,

                onVisibilityPressed: () {
                  setState(() {
                    obscureCurrentPin = !obscureCurrentPin;
                  });
                },
              ),

              const SizedBox(height: 15),

              // =================================================
              // NEW PIN
              // =================================================
              _pinField(
                controller: newPinController,
                label: "New PIN",
                hint: "Enter new PIN",
                obscureText: obscureNewPin,

                onVisibilityPressed: () {
                  setState(() {
                    obscureNewPin = !obscureNewPin;
                  });
                },
              ),

              const SizedBox(height: 15),

              // =================================================
              // CONFIRM NEW PIN
              // =================================================
              _pinField(
                controller: confirmPinController,
                label: "Confirm New PIN",
                hint: "Enter new PIN again",
                obscureText: obscureConfirmPin,

                onVisibilityPressed: () {
                  setState(() {
                    obscureConfirmPin = !obscureConfirmPin;
                  });
                },
              ),

              const SizedBox(height: 25),

              // =================================================
              // CHANGE BUTTON
              // =================================================
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                onPressed: isLoading ? null : changePin,

                child: isLoading
                    ? const SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(),
                      )
                    : const Text(
                        "Change App Lock",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
